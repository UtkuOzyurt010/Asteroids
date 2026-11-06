module Movement where

import DataTypes.Types
import Data.Ord (clamp)

import Config (dragStrength, halfWidth, halfHeight, spawnMargin)
import Assets (AssetsRadii playerRadius)


class Moveable a where
    getPosition :: a -> Position
    setPosition :: Position -> a -> a
    getVelocity :: a -> Velocity
    setVelocity :: Velocity -> a -> a

instance Moveable Player where
    getPosition = playerPosition
    setPosition pos p = p {playerPosition = pos}
    getVelocity = playerVelocity
    setVelocity vel p = p {playerVelocity = vel}

instance Moveable Asteroid where
    getPosition = asteroidPosition
    setPosition pos asteroid = asteroid {asteroidPosition = pos}
    getVelocity = asteroidVelocity
    setVelocity vel asteroid = asteroid {asteroidVelocity = vel}

instance Moveable Enemy where
    getPosition = enemyPosition
    setPosition pos enemy = enemy {enemyPosition = pos}
    getVelocity = enemyVelocity
    setVelocity vel enemy = enemy {enemyVelocity = vel}

instance Moveable Bullet where
    getPosition = bulletPosition
    setPosition pos bullet = bullet {bulletPosition = pos}
    getVelocity = bulletVelocity
    setVelocity vel bullet = bullet {bulletVelocity = vel}

drag :: Moveable a => Float -> a -> a
drag dt obj = setVelocity newVel obj
    where
        currVel = getVelocity obj
        velx = vx currVel
        vely = vy currVel
        applyDrag v
            | v > 0 = max 0 (v - dragStrength * dt)
            | v < 0 = min 0 (v + dragStrength * dt)
            | otherwise = 0


        newVel = Velocity (applyDrag velx) (applyDrag vely)

-- the acceleration is an argument, so objects that compute it every frame (enemies) don't have to store it
accelerate :: Moveable a => Float -> Acceleration -> a -> a
accelerate dt acc obj = setVelocity newVel obj
    where
        currVel = getVelocity obj
        newVel = Velocity (vx currVel + ax acc * dt) (vy currVel + ay acc * dt)

-- slows an object down to maxSpeed if it is faster, keeping its direction
limitSpeed :: Moveable a => Float -> a -> a
limitSpeed maxSpeed obj
    | speed <= maxSpeed = obj
    | otherwise         = setVelocity (Velocity (vx currVel * factor) (vy currVel * factor)) obj
    where
        currVel = getVelocity obj
        speed = sqrt (vx currVel * vx currVel + vy currVel * vy currVel)
        factor = maxSpeed / speed

move :: Moveable a => Float -> a ->  a
move dt obj = setPosition newPos obj
    where
        currPos = getPosition obj
        currVel = getVelocity obj
        -- respectively add (velocity * passed time) to x and y of position
        newPos = Position (px currPos + vx currVel * dt) (py currPos + vy currVel * dt) 

clampPlayer :: AssetsRadii -> Player -> Player
clampPlayer assetsRadii p = p {
    playerPosition = Position x' y'
    , playerVelocity = Velocity velx' vely'
}
    where 
        Position x y = playerPosition p
        Velocity velx vely = playerVelocity p
        r =  playerRadius assetsRadii
        x' = clamp (-halfWidth + r, halfWidth - r) x
        y' = clamp (-halfHeight + r, halfHeight - r) y

        velx' = if x' /= x then 0 else velx
        vely' = if y' /= y then 0 else vely

-- an object that leaves spawnMargin outside the screen comes back on the other side
wrapAround :: Moveable a => a -> a
wrapAround obj = setPosition (Position (wrapAxis w (px pos)) (wrapAxis h (py pos))) obj
    where
        pos = getPosition obj
        w = halfWidth  + spawnMargin
        h = halfHeight + spawnMargin

-- keeps a coordinate between -edge and edge so new spawns exactly on the edge stay 
wrapAxis :: Float -> Float -> Float
wrapAxis edge c
    | c > edge    = c - 2 * edge
    | c < -edge   = c + 2 * edge
    | otherwise   = c

-- direction from one position to another in degrees, 0 = up and clockwise
angleTowards :: Position -> Position -> Float
angleTowards from to = atan2 (px to - px from) (py to - py from) * 180 / pi

-- direction an object is moving in, in degrees and similar as angleTowards
velocityAngle :: Velocity -> Float
velocityAngle v = atan2 (vx v) (vy v) * 180 / pi

-- straight-line distance between two positions
distance :: Position -> Position -> Float
distance a b = sqrt (dx * dx + dy * dy)
    where
        dx = px a - px b
        dy = py a - py b