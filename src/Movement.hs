module Movement where

import DataTypes.Types

class Moveable a where
    getPosition :: a -> Position
    setPosition :: a -> Position -> a
    getVelocity :: a -> Velocity
    setVelocity :: a -> Velocity -> a

instance Moveable Player where
    getPosition = playerPosition
    setPosition p pos = p {playerPosition = pos}
    getVelocity = playerVelocity
    setVelocity p vel = p {playerVelocity = vel}

instance Moveable Asteroid where
    getPosition = asteroidPosition
    setPosition asteroid pos = asteroid {asteroidPosition = pos}
    getVelocity = asteroidVelocity
    setVelocity asteroid vel = asteroid {asteroidVelocity = vel}

instance Moveable Enemy where
    getPosition = enemyPosition
    setPosition enemy pos = enemy {enemyPosition = pos}
    getVelocity = enemyVelocity
    setVelocity enemy vel = enemy {enemyVelocity = vel}

instance Moveable Bullet where
    getPosition = bulletPosition
    setPosition bullet pos = bullet {bulletPosition = pos}
    getVelocity = bulletVelocity
    setVelocity bullet vel = bullet {bulletVelocity = vel}

move :: Moveable a => a -> Float -> a
move obj dt = setPosition obj newPos
    where
        currPos = getPosition obj
        currVel = getVelocity obj
        -- respectively add (velocity * passed time) to x and y of position
        newPos = Position (px currPos + vx currVel * dt) (py currPos + vy currVel * dt) 

