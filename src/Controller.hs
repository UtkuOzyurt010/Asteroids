module Controller where

import Graphics.Gloss.Interface.IO.Game (Event, Event(EventMotion, EventKey), KeyState(Down, Up), Key(Char))

import AsteroidWaves (releaseIncoming, spawnWaveIfCleared)
import DataTypes.Types
import Movement

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
            accStrength = 150

togglePause :: GameStatus -> GameStatus
togglePause Playing = Paused
togglePause Paused = Playing
togglePause GameOver = GameOver

-- entry point for Gloss: the logic is pure, only the type is IO
-- (IO is needed later for random numbers and high-score files).
step :: Float -> GameState -> IO GameState
step dt gs = case status gs of
    Playing -> return (update dt gs)
    _       -> return gs  -- Paused or GameOver: the world is frozen

-- advance the game by 'dt' seconds: move everything that moves, then let asteroids
-- of the current wave enter and start the next wave if the field is cleared.
update :: Float -> GameState -> GameState
update dt gs = spawnWaveIfCleared gs
    { player = move dt (accelerate dt (drag dt (player gs)))
    , playingField = releaseIncoming dt field
        { asteroids = map (move dt) (asteroids field)
        , enemies   = map (move dt) (enemies field)
        , bullets   = map (move dt) (bullets field)
        }
    }
  where
    field = playingField gs
