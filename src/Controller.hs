module Controller where

import Graphics.Gloss.Interface.IO.Game
import Control.Monad (when)

import Config (accStrength, highScoreFile)
import AsteroidWaves (releaseIncoming, spawnWaveIfCleared)
import DataTypes.Types
import Enemies (updateEnemies)
import Explosions (updateExplosions)
import Movement
import Highscores
import Colliding
import Assets (AssetsRadii)
import Spawning (spawnPlayerbullet)

-- handle a keyboard/mouse event
-- to do: keys to rotate/accelerate, shoot, pause
input :: Event -> GameState -> IO GameState
input (EventMotion (x, y)) gs = do
    let p = player gs
        pos = playerPosition p
        dx = x - px pos
        dy = y - py pos
        angle = atan2 dx dy * 180 / pi -- -180 to 180 degrees
    return gs { player = p { playerFacingDirection = angle } }

input (EventKey (Char 'p') Down _ _) gs = do -- pause
    let gameStatus = status gs
    return gs {status = togglePause gameStatus }

input (EventKey (SpecialKey KeySpace) Down _ _) gs = do -- shoot bullet
    let 
        p = player gs
        field = playingField gs
        bs = bullets field 
    return gs {
        playingField = field {
            bullets = spawnPlayerbullet (playerPosition p) (playerFacingDirection p) : bs
        }
    }

input (EventKey (Char key) keyState _ _) gs = do -- move player
    let p = player gs
    return gs { player = handlePlayerMovement key keyState p}

input _ gs = return gs



handlePlayerMovement :: Char -> KeyState -> Player -> Player
handlePlayerMovement key keyState p =
    case (key, keyState) of
        ('w', Down) -> p {playerAcceleration = Acceleration {ax = accx, ay = accy + accStrength}}
        ('s', Down) -> p {playerAcceleration = Acceleration {ax = accx, ay = accy - accStrength}}
        ('a', Down) -> p {playerAcceleration = Acceleration {ax = accx - accStrength, ay = accy}}
        ('d', Down) -> p {playerAcceleration = Acceleration {ax = accx + accStrength, ay = accy}}
        ('w', Up) -> p {playerAcceleration = Acceleration {ax = accx, ay = 0}}
        ('s', Up) -> p {playerAcceleration = Acceleration {ax = accx, ay = 0}}
        ('a', Up) -> p {playerAcceleration = Acceleration {ax = 0, ay = accy}}
        ('d', Up) -> p {playerAcceleration = Acceleration {ax = 0, ay = accy}}
        _ -> p
        where
            acc = playerAcceleration p
            accx = ax acc
            accy = ay acc

togglePause :: GameStatus -> GameStatus
togglePause Playing = Paused
togglePause Paused = Playing
togglePause GameOver = GameOver

-- entry point for Gloss: the logic is pure, only the type is IO
-- (IO is needed later for random numbers and high-score files).
step :: AssetsRadii -> Float -> GameState -> IO GameState
step assetsRadii dt gs = case status gs of
    Playing -> do
        let gs' = update assetsRadii dt gs
        when (status gs' == GameOver) $
            saveHighScores highScoreFile (highScores gs')
        return gs'
    _ -> return gs -- Paused or GameOver: the world is frozen

-- advance the game by 'dt' seconds: steer the enemies, move everything that moves, then let
-- asteroids of the current wave enter and start the next wave if the field is cleared.
update :: AssetsRadii -> Float -> GameState -> GameState
update assetsRadii dt gs = 
    checkGameOver
    $ checkCollisions assetsRadii
    $ spawnWaveIfCleared 
    $ moveEntities assetsRadii dt gs
    

moveEntities :: AssetsRadii -> Float -> GameState -> GameState
moveEntities assetsRadii dt gs = gs
    { player = clampPlayer assetsRadii $ move dt $ accelerate dt (playerAcceleration p) (drag dt p)
    , playingField = releaseIncoming dt field
        { asteroids = map (move dt) (asteroids field)
        , enemies   = map (move dt) steeredEnemies
        , bullets   = map (move dt) (enemyBullets ++ bullets field)
        , explosions = updateExplosions dt (explosions field)
        }
    }
  where
    p     = player gs
    field = playingField gs
    (steeredEnemies, enemyBullets) = updateEnemies dt (playerPosition p) (enemies field)

-- checks collisions
-- updates adversary states
-- updates score
-- updates playerLives
checkCollisions :: AssetsRadii -> GameState -> GameState 
checkCollisions assetsRadii = 
    checkCollisionsExplosions assetsRadii     
    . checkCollisionsAsteroids assetsRadii    
    . checkCollisionsEnemies assetsRadii      
    . checkCollisionsEnemyBullets assetsRadii  -- 2nd
    . checkCollisionsPlayerBullets assetsRadii -- 1st

-- checks playerLives
-- if 0, updates gs status to GameOver and updates highscores
checkGameOver :: GameState -> GameState
checkGameOver gs 
    | pLives <= 0 = gs 
        {
            status = GameOver,
            highScores = insertScore s hs
        }
    | otherwise = gs
  where
    p = player gs
    pLives = playerLives p
    s = score gs
    hs = highScores gs