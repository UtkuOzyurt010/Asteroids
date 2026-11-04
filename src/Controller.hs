module Controller where

import Graphics.Gloss.Interface.IO.Game (Event, Event(EventMotion, EventKey), KeyState(Down, Up), Key(Char))

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

input (EventKey (Char 'w') Down _ _) gs = do -- move player up
    let p = player gs
        vel = playerVelocity p
        velx = vx vel
        vely = vy vel 
    return gs { player = p { playerVelocity = Velocity {vx = velx, vy = vely+150}}}
input (EventKey (Char 'w') Up _ _) gs = do -- stop moving player up
    let p = player gs
        vel = playerVelocity p
        velx = vx vel
        vely = vy vel 
    return gs { player = p { playerVelocity = Velocity {vx = velx, vy = vely-150}}}

input (EventKey (Char 's') Down _ _) gs = do -- move player down
    let p = player gs
        vel = playerVelocity p
        velx = vx vel
        vely = vy vel 
    return gs { player = p { playerVelocity = Velocity {vx = velx, vy = vely-150}}}
input (EventKey (Char 's') Up _ _) gs = do -- stop moving player down
    let p = player gs
        vel = playerVelocity p
        velx = vx vel
        vely = vy vel 
    return gs { player = p { playerVelocity = Velocity {vx = velx, vy = vely+150}}}

input (EventKey (Char 'd') Down _ _) gs = do -- move player right
    let p = player gs
        vel = playerVelocity p
        velx = vx vel
        vely = vy vel 
    return gs { player = p { playerVelocity = Velocity {vx = velx+150, vy = vely}}}

input (EventKey (Char 'd') Up _ _) gs = do -- stop moving player left
    let p = player gs
        vel = playerVelocity p
        velx = vx vel
        vely = vy vel 
    return gs { player = p { playerVelocity = Velocity {vx = velx-150, vy = vely}}}

input (EventKey (Char 'a') Down _ _) gs = do -- move player left
    let p = player gs
        vel = playerVelocity p
        velx = vx vel
        vely = vy vel 
    return gs { player = p { playerVelocity = Velocity {vx = velx-100, vy = vely}}}
input (EventKey (Char 'a') Up _ _) gs = do -- stop moving player left
    let p = player gs
        vel = playerVelocity p
        velx = vx vel
        vely = vy vel 
    return gs { player = p { playerVelocity = Velocity {vx = velx+100, vy = vely}}}



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
    { player = move dt (player gs)
    , playingField = field
        { asteroids = map (move dt) (asteroids field)
        , enemies   = map (move dt) (enemies field)
        , bullets   = map (move dt) (bullets field)
        }
    }
  where
    field = playingField gs
