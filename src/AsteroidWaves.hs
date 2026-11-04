-- asteroid waves: what a wave contains, in which order the kinds spawn, and when the next wave starts
module AsteroidWaves
    ( AsteroidKindCount (..)
    , SpawnMethod (..)
    , makeAsteroidWave
    , waveCounts
    , spawnMethodFor
    , spawnWaveIfCleared
    , releaseIncoming
    ) where

import Data.Bifunctor (first)
import Data.List (partition, transpose)

import Config
import DataTypes.Types
import Randomness
import Spawning (spawnAsteroid, spawnEnemy)

-- how many of each AsteroidKind we want to include in the wave
data AsteroidKindCount = AsteroidKindCount { -- I don't really like this name tbh
    countedKind :: AsteroidKind,
    asteroidCount :: Int
}

data SpawnMethod =
        Random      -- kinds in a random order
    |   Alternating -- one of each kind in turn
    |   Custom ([AsteroidKindCount] -> Rand [Asteroid]) -- pass any function that takes the counts for each type and creates a list of asteroids

-- the position is the player's, so asteroids don't spawn on top of them
makeAsteroidWave :: SpawnMethod -> Position -> [AsteroidKindCount] -> Rand [Asteroid]
makeAsteroidWave (Custom customMethod) _ counts gen = customMethod counts gen
makeAsteroidWave Random playerPos counts gen = mapRand (spawnAsteroid playerPos) kinds gen'
  where
    (kinds, gen') = shuffle (concatMap kindList counts) gen
makeAsteroidWave Alternating playerPos counts gen = mapRand (spawnAsteroid playerPos) kinds gen
  where
    kinds = concat (transpose (map kindList counts)) -- e.g. [R, R, R] and [E] become [R, E, R, R]

-- the kind repeated by its count, e.g. [R, R, R]
kindList :: AsteroidKindCount -> [AsteroidKind]
kindList c = replicate (asteroidCount c) (countedKind c)

-- what wave n contains: more regular asteroids every wave, exploding ones from wave 2
-- the explosion radius is chosen by spawnAsteroid, so 0 is just a placeholder
waveCounts :: Int -> [AsteroidKindCount]
waveCounts n =
    [ AsteroidKindCount Regular       (baseAsteroidsPerWave + n)
    , AsteroidKindCount (Exploding 0) (n `div` wavesPerExplodingAsteroid)
    ]

-- odd waves are random, even waves alternate
spawnMethodFor :: Int -> SpawnMethod
spawnMethodFor n
    | even n    = Alternating
    | otherwise = Random

-- starts the next wave once all asteroids and enemies are gone
-- the field starts empty, so this also spawns wave 1
-- the asteroids enter one by one in the order of the spawn method, enemies right away
spawnWaveIfCleared :: GameState -> GameState
spawnWaveIfCleared gs
    | cleared   = gs { wave = n
                     , playingField = field { incomingAsteroids = zip delays newAsteroids
                                            , enemies = newEnemies }
                     , rng = gen2
                     }
    | otherwise = gs
  where
    field     = playingField gs
    cleared   = null (asteroids field) && null (incomingAsteroids field) && null (enemies field)
    n         = wave gs + 1
    playerPos = playerPosition (player gs)
    delays    = iterate (+ asteroidSpawnInterval) 0 -- 0, 0.4, 0.8, ...
    (newAsteroids, gen1) = makeAsteroidWave (spawnMethodFor n) playerPos (waveCounts n) (rng gs)
    (newEnemies, gen2)   = replicateRand (n `div` wavesPerEnemy) (spawnEnemy playerPos) gen1

-- counts down the incoming asteroids and moves the ones that are due onto the field
releaseIncoming :: Float -> PlayingField -> PlayingField
releaseIncoming dt field = field { asteroids = map snd due ++ asteroids field
                                 , incomingAsteroids = waiting }
  where
    (due, waiting) = partition ((<= 0) . fst) (map (first (subtract dt)) (incomingAsteroids field))