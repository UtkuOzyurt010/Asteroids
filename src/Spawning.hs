-- creating random objects: new asteroids, pieces of split asteroids and enemies
module Spawning
    ( randomSpawnPosition
    , randomInwardVelocity
    , spawnAsteroid
    , splitAsteroid
    , spawnEnemy
    ) where

import Data.Foldable (maximumBy)
import Data.List (find)
import Data.List.NonEmpty (NonEmpty (..))
import Data.Maybe (fromMaybe)
import Data.Ord (comparing)

import Config
import DataTypes.Types
import Movement (distance)
import Randomness

-- random spot just outside the screen, at least minSpawnDistance from the player
-- if none of the maxSpawnAttempts tries is far enough, takes the one furthest away
randomSpawnPosition :: Position -> Rand Position
randomSpawnPosition playerPos gen = (fromMaybe furthest (find farEnough candidates), gen2)
  where
    (first, gen1) = randomEdgePosition gen
    (rest, gen2)  = replicateRand (maxSpawnAttempts - 1) randomEdgePosition gen1
    candidates    = first : rest
    farEnough pos = distance playerPos pos >= minSpawnDistance
    furthest      = maximumBy (comparing (distance playerPos)) (first :| rest)

-- random spot on a rectangle spawnMargin outside the screen edges
randomEdgePosition :: Rand Position
randomEdgePosition gen = (pos, gen2)
  where
    (side, gen1) = randomInRange (0, 3 :: Int) gen
    (t, gen2)    = randomInRange (-1, 1) gen1 -- where along that side
    w = halfWidth  + spawnMargin
    h = halfHeight + spawnMargin
    pos = case side of
        0 -> Position (t * w) h    -- top
        1 -> Position (t * w) (-h) -- bottom
        2 -> Position (-w) (t * h) -- left
        _ -> Position w (t * h)    -- right

-- velocity towards the centre of the screen, give or take inwardSpread degrees
randomInwardVelocity :: (Float, Float) -> Position -> Rand Velocity
randomInwardVelocity speedRange pos gen = (velocityFromAngle angle speed, gen2)
  where
    (spread, gen1) = randomInRange (-inwardSpread, inwardSpread) gen
    (speed, gen2)  = randomInRange speedRange gen1
    towardsCentre  = atan2 (negate (py pos)) (negate (px pos))
    angle          = towardsCentre + spread * pi / 180

-- velocity from a direction (radians, counterclockwise from the right) and a speed
velocityFromAngle :: Float -> Float -> Velocity
velocityFromAngle angle speed = Velocity (speed * cos angle) (speed * sin angle)

-- asteroid that starts a wave: outside the screen, flying inwards
spawnAsteroid :: Position -> AsteroidKind -> Rand Asteroid
spawnAsteroid playerPos kind gen = (asteroid, gen3)
  where
    (pos, gen1)   = randomSpawnPosition playerPos gen
    (vel, gen2)   = randomInwardVelocity asteroidSpeedRange pos gen1
    (kind', gen3) = randomizeKind kind gen2
    asteroid = Asteroid
        { asteroidPosition = pos
        , asteroidVelocity = vel
        , asteroidSize     = waveAsteroidSize
        , asteroidKind     = kind'
        }

-- gives exploding asteroids a random radius; the radius passed in is ignored
randomizeKind :: AsteroidKind -> Rand AsteroidKind
randomizeKind Regular gen = (Regular, gen)
randomizeKind (Exploding _) gen = (Exploding radius, gen')
  where
    (radius, gen') = randomInRange explosionRadiusRange gen

-- pieces of a hit asteroid: one size smaller, same kind, flying apart evenly spread out
-- asteroids that are already the smallest size leave no pieces
splitAsteroid :: Asteroid -> Rand [Asteroid]
splitAsteroid a gen
    | newSize < minAsteroidSize = ([], gen)
    | otherwise                 = mapRand piece angles gen1
  where
    newSize          = asteroidSize a - 1
    (rotation, gen1) = randomInRange (0, 2 * pi) gen -- so pieces don't always fly the same way
    angles           = map pieceAngle [0 .. asteroidSplitCount - 1]
    pieceAngle i     = rotation + 2 * pi * fromIntegral i / fromIntegral asteroidSplitCount
    piece angle g    = (a { asteroidVelocity = velocityFromAngle angle speed
                          , asteroidSize     = newSize }, g')
      where
        (speed, g') = randomInRange asteroidSpeedRange g

-- enemy outside the screen, flying inwards; randomly a Chaser or a Shooter
spawnEnemy :: Position -> Rand Enemy
spawnEnemy playerPos gen = (enemy, gen4)
  where
    (pos, gen1)       = randomSpawnPosition playerPos gen
    (vel, gen2)       = randomInwardVelocity enemySpeedRange pos gen1
    (isChaser, gen3)  = randomInRange (False, True) gen2
    (firstShot, gen4) = randomInRange shooterFirstShotRange gen3
    behaviour
        | isChaser  = Chaser
        | otherwise = Shooter firstShot
    enemy = Enemy
        { enemyPosition  = pos
        , enemyVelocity  = vel
        , enemyBehaviour = behaviour
        , enemySize      = enemySpawnSize
        }