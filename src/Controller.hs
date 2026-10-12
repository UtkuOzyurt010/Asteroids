module Controller where

import Graphics.Gloss.Interface.IO.Game (Event)

import DataTypes.Types
import Movement

-- | Handle a keyboard/mouse event. Stub for now: ignores all input.
-- Next step: arrow keys to rotate/thrust, space to shoot, a key to pause.
input :: Event -> GameState -> IO GameState
input _ gs = return gs

-- | Entry point for Gloss: the logic is pure, only the type is IO
-- (IO is needed later for random numbers and high-score files).
step :: Float -> GameState -> IO GameState
step dt = return . update dt

-- | Advance the game by @dt@ seconds: move everything that moves.
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
