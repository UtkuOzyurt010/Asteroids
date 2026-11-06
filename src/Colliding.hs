module Colliding where

import Graphics.Gloss (Picture)
import Data.List (find)

import Config (waveAsteroidSize)

import Movement (distance)
import DataTypes.Types
import Assets

class Collideable a where
    getCollisionPosition :: a -> Position
    getCollisionRadius :: AssetsRadii -> a -> Float

instance Collideable Player where
    getCollisionPosition p = playerPosition p
    getCollisionRadius assetsRadii _ = playerRadius assetsRadii

instance Collideable Asteroid where
    getCollisionPosition a = asteroidPosition a
    getCollisionRadius assetsRadii a = aScale * (asteroidRadius assetsRadii)
        where
            aScale = (fromIntegral (asteroidSize a)) / (fromIntegral waveAsteroidSize) 
                -- scale also calculated and used in Drawing.hs - refactor?

instance Collideable Enemy where
    getCollisionPosition e = enemyPosition e
    getCollisionRadius assetsRadii _ = enemyRadius assetsRadii

instance Collideable Bullet where
    getCollisionPosition b = bulletPosition b
    getCollisionRadius assetsRadii _ = bulletRadius assetsRadii

collides :: (Collideable a, Collideable b) => AssetsRadii -> a -> b -> Bool
collides assetsRadii a b = distance (getCollisionPosition a) (getCollisionPosition b)
    < getCollisionRadius assetsRadii a + getCollisionRadius assetsRadii b


checkCollisionsPlayerBullets :: AssetsRadii -> GameState -> GameState
checkCollisionsPlayerBullets assetsRadii gs = foldl' (checkCollisionsPlayerBullet assetsRadii) gs pbs --fold with gs as accumulator to remove bullets/enemies as soon as possible to prevent multiple collisions
    where 
        field = playingField gs 
        bs = bullets field
        pbs = filter ((== FromPlayer) . bulletOwner) bs

checkCollisionsPlayerBullet :: AssetsRadii -> GameState -> Bullet -> GameState
checkCollisionsPlayerBullet assetsRadii gs bullet = 
    case find (collides assetsRadii bullet) es of -- find first enemy hit by bullet
        Just enemy -> handlePlayerBulletHitEnemy bullet enemy gs
        Nothing -> 
            case find (collides assetsRadii bullet) as of -- then check first asteroid hit by bullet
                Just asteroid -> handlePlayerBulletHitAsteroid bullet asteroid gs
                Nothing -> gs
    where 
        field = playingField gs
        es = enemies field
        as = asteroids field

handlePlayerBulletHitEnemy :: Bullet -> Enemy -> GameState -> GameState
handlePlayerBulletHitEnemy b e gs = gs { 
    playingField = field {
        bullets = filter (/= b) bs -- remove bullet
        , enemies = filter (/= e) es -- remove enemy
    }
    , score = s + 1              -- increment score
}
    where
        field = playingField gs
        bs = bullets field
        es = enemies field
        s = score gs

handlePlayerBulletHitAsteroid :: Bullet -> Asteroid -> GameState -> GameState
handlePlayerBulletHitAsteroid b a gs = gs {
    playingField = field {
        bullets = filter (/= b) bs -- remove bullet
        , asteroids = filter (/= a) as -- remove asteroid
    }
    , score = s + 1              -- increment score
}
    where
        field = playingField gs
        bs = bullets field
        as = asteroids field
        s = score gs

checkCollisionsEnemyBullets :: AssetsRadii -> GameState -> GameState
checkCollisionsEnemyBullets assetsRadii gs = foldl' (checkCollisionsEnemyBullet assetsRadii) gs ebs --fold with gs as accumulator to remove bullets/enemies as soon as possible to prevent multiple collisions
    where 
        field = playingField gs 
        bs = bullets field
        ebs = filter ((== FromEnemy) . bulletOwner) bs

checkCollisionsEnemyBullet :: AssetsRadii -> GameState -> Bullet -> GameState
checkCollisionsEnemyBullet assetsRadii gs bullet
    | collides assetsRadii bullet p = handleEnemyBulletHitPlayer bullet gs
    | otherwise = gs
    where
        -- field = playingField gs
        p = player gs

handleEnemyBulletHitPlayer :: Bullet -> GameState -> GameState -- only 1 player in gameState so no need to pass it as argument
handleEnemyBulletHitPlayer b gs = gs {
    playingField = field {
        bullets = filter (/= b) bs -- remove bullet
    }
    , player = p {playerLives = pLives - 1} -- decrement playLives by 1, gameOver is checked in a alter step
}
    where
        field = playingField gs
        bs = bullets field
        p = player gs
        pLives = playerLives p

checkCollisionsEnemies :: AssetsRadii -> GameState -> GameState
checkCollisionsEnemies assetsRadii gs = foldl' (checkCollisionsEnemy assetsRadii) gs es --fold with gs as accumulator to remove enemies as soon as possible to prevent multiple collisions
    where 
        field = playingField gs 
        es = enemies field

checkCollisionsEnemy :: AssetsRadii -> GameState -> Enemy -> GameState
checkCollisionsEnemy assetsRadii gs enemy
    | collides assetsRadii enemy p = handleEnemyHitPlayer enemy gs
    | otherwise = gs
    where
        -- field = playingField gs
        p = player gs

handleEnemyHitPlayer :: Enemy -> GameState -> GameState -- only 1 player in gameState so no need to pass it as argument
handleEnemyHitPlayer e gs = gs {
    playingField = field {
        enemies = filter (/= e) es -- remove enemy
    }
    , player = p {playerLives = pLives - 1} -- decrement playLives by 1, gameOver is checked in a alter step
}
    where
        field = playingField gs
        es = enemies field
        p = player gs
        pLives = playerLives p

checkCollisionsAsteroids :: AssetsRadii -> GameState -> GameState
checkCollisionsAsteroids assetsRadii gs = foldl' (checkCollisionsAsteroid assetsRadii) gs as --fold with gs as accumulator to remove enemies as soon as possible to prevent multiple collisions
    where 
        field = playingField gs 
        as = asteroids field

checkCollisionsAsteroid :: AssetsRadii -> GameState -> Asteroid -> GameState
checkCollisionsAsteroid assetsRadii gs asteroid
    | collides assetsRadii asteroid p = handleAsteroidHitPlayer asteroid gs
    | otherwise = gs
    where
        -- field = playingField gs
        p = player gs

handleAsteroidHitPlayer :: Asteroid -> GameState -> GameState -- only 1 player in gameState so no need to pass it as argument
handleAsteroidHitPlayer a gs = gs {
    playingField = field {
        asteroids = filter (/= a) as -- remove asteroid
    }
    , player = p {playerLives = pLives - 1} -- decrement playLives by 1, gameOver is checked in a alter step
}
    where
        field = playingField gs
        as = asteroids field
        p = player gs
        pLives = playerLives p
    