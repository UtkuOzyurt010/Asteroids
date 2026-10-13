module Controller where

import Graphics.Gloss.Interface.IO.Game (Event)

import DataTypes.Types
import Movement

-- handle a keyboard/mouse event
-- to do: keys to rotate/accelerate, shoot, pause
input :: Event -> GameState -> IO GameState
input _ gs = return gs

-- entry point for Gloss: the logic is pure, only the type is IO
-- (IO is needed later for random numbers and high-score files).
step :: Float -> GameState -> IO GameState
step dt gs = case status gs of
    Playing -> return (update dt gs)
    _       -> return gs  -- Paused or GameOver: the world is frozen

-- advance the game by 'dt' seconds: move everything that moves.
update :: Float -> GameState -> GameState
update dt gs = gs
    { player = move (player gs) dt
    , playingField = field
        { asteroids = map (`move` dt) (asteroids field)
        , enemies   = map (`move` dt) (enemies field)
        , bullets   = map (`move` dt) (bullets field)
        }
    }
  where
    field = playingField gs
