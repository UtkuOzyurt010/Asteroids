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


checkCollisionsPlayerBullets :: GameState -> GameState
checkCollisionsPlayerBullets gs = foldl' checkCollisionsPlayerBullet gs pbs --fold with gs as accumulator to remove bullets/enemies as soon as possible to prevent multiple collisions
    where 
        field = playingField gs 
        bs = bullets field
        pbs = filter ((== PlayerOwned) . bulletOwner) bs

checkCollisionsPlayerBullet :: GameState -> Bullet -> GameState
checkCollisionsPlayerBullet gs bullet = 
    case find (collides bullet) es of -- find first enemy hit by bullet
        Just enemy -> handlePlayerBulletHitEnemy bullet enemy gs
        Nothing -> 
            case find (collides bullet) as of -- then check first asteroid hit by bullet
                Just asteroid -> handlePlayerBulletHitAsteroid bullet asteroid gs
                Nothing -> gs
    where 
        field = playingField gs
        es = enemeis field
        as = asteroids field

handlePlayerBulletHitEnemy :: Bullet -> Enemy -> GameState -> GameState
handlePlayerBulletHitEnemy b e gs = gs { 
    playingField = field {
        bullets = filter (/= b) bs -- remove bullet
        enemies = filter (/= e) es -- remove enemy
        score = s + 1              -- increment score
    }
}
    where
        field = playingField gs
        bs = bullets field
        es = enemies field
        s = score field

handlePlayerBulletHitAsteroid :: Bullet -> Asteroid -> GameState -> GameState
handlePlayerBulletHitAsteroid b a gs = gs {
    playingField = field {
        bullets = filter (/= b) bs -- remove bullet
        asteroid = filter (/= a) as -- remove asteroid
        score = s + 1              -- increment score
    }
}
    where
        field = playingField gs
        bs = bullets field
        as = asteroids field
        s = score field

checkCollisionsEnemyBullets :: GameState -> GameState
checkCollisionsEnemyBullets gs = foldl' checkCollisionsEnemyBullet gs ebs --fold with gs as accumulator to remove bullets/enemies as soon as possible to prevent multiple collisions
    where 
        field = playingField gs 
        bs = bullets field
        ebs = filter ((== EnemyOwned) . bulletOwner) bs

checkCollisionsEnemyBullet :: GameState -> Bullet -> GameState
checkCollisionsEnemyBullet gs bullet
    | collides bullet p = handleEnemyBulletHitPlayer bullet gs
    | otherwise = gs
    where
        field = playingField gs
        p = player field

handleEnemyBulletHitPlayer :: Bullet -> GameState -> GameState -- only 1 player in gameState so no need to pass it as argument
handleBulletHitPlayer b gs = gs {
    playingField = field {
        bullets = filter (/= b) bs -- remove bullet
        player = p {playerLives = pLives - 1} -- decrement playLives by 1, gameOver is checked in a alter step
    }
}
    where
        field = playingField gs
        bs = bullets field
        p = player field
        pLives = playerLives p


    