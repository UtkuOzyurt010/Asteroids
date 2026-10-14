module Movement where

import DataTypes.Types

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

move :: Moveable a => Float -> a ->  a
move dt obj = setPosition newPos obj
    where
        currPos = getPosition obj
        currVel = getVelocity obj
        -- respectively add (velocity * passed time) to x and y of position
        newPos = Position (px currPos + vx currVel * dt) (py currPos + vy currVel * dt) 

