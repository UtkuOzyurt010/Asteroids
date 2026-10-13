module AsteroidWaves where

import DataTypes.Types

-- how many of each AsteroidKind we want to include in the wave
data AsteroidKindCount = AsteroidKindCount { -- I don't really like this name tbh
    countedKind :: AsteroidKind,
    asteroidCount :: Int
}

data SpawnMethod = 
        Random  
    |   Alternating
    |   Custom ([AsteroidKindCount] -> [Asteroid]) -- pass any function that takes the counts for each type and creates a list of asteroids


makeAsteroidWave :: SpawnMethod -> [AsteroidKindCount] -> [Asteroid]
makeAsteroidWave (Custom customMethod) = customMethod 
-- makeAsteroidWave Random = 
-- makeAstroidWave Alternating = 
