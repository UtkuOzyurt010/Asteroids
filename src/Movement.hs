module Movement where

import DataTypes.Types

class Moveable a where
    getPosition :: a -> Position
    setPosition :: Position -> a -> a
    getVelocity :: a -> Velocity
    setVelocity :: Velocity -> a -> a
    getAcceleration :: a -> Acceleration
    setAcceleration :: Acceleration -> a -> a

instance Moveable Player where
    getPosition = playerPosition
    setPosition pos p = p {playerPosition = pos}
    getVelocity = playerVelocity
    setVelocity vel p = p {playerVelocity = vel}
    getAcceleration = playerAcceleration
    setAcceleration acc p = p {playerAcceleration = acc}

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
        dragStrength = 60
        applyDrag v
            | v > 0 = max 0 (v - dragStrength * dt)
            | v < 0 = min 0 (v + dragStrength * dt)
            | otherwise = 0


        newVel = Velocity (applyDrag velx) (applyDrag vely)

accelerate :: Moveable a => Float -> a -> a
accelerate dt obj = setVelocity newVel obj
    where
        currVel = getVelocity obj
        currAcc = getAcceleration obj
        newVel = Velocity (vx currVel + ax currAcc * dt) (vy currVel + ay currAcc * dt)

move :: Moveable a => Float -> a ->  a
move dt obj = setPosition newPos obj
    where
        currPos = getPosition obj
        currVel = getVelocity obj
        -- respectively add (velocity * passed time) to x and y of position
        newPos = Position (px currPos + vx currVel * dt) (py currPos + vy currVel * dt) 

