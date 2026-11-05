module Colliding where

import Graphics.Gloss (Picture)

import Config (waveAsteroidSize)

import DataTypes.Types
import Assets

getRadiusfromPicture :: Picture -> Float

class Collideable a where
    getCollisionPosition :: a -> Position
    getCollisionRadius :: Assets -> a -> Float -- is a still necessary here?

instance Collideable Player where
    getCollisionPosition p = playerPosition p
    getCollisionRadius assets _ = playerRadius assets

instance Collideable Asteroid where
    getCollisionPosition a = asteroidPosition a
    getCollisionRadius assets a = aScale (asteroidRadius assets)
        where
            aScale = (fromIntegral (asteroidSize a)) / (fromIntegral waveAsteroidSize) 
                -- scale also calculated and used in Drawing.hs - refactor?

instance Collideable Enemy where
    getCollisionPosition e = enemyPosition e
    getCollisionRadius assets _ = enemyRadius assets

instance Collideable Bullet where
    getCollisionPosition b = bulletPosition b
    getCollisionRadius assets _ = bulletRadius assets

collides :: (Collidable a, Collidable b) => a -> b -> Bool
collides a b = distance (getCollisionPosition a) (getCollisionPosition b)
    < getCollisionRadius a + getCollisionRadius b


    