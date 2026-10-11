module AsteroidWaves where

import DataTypes.Types

-- how many of each asteroidtype we want to include in the wave
data AsteroidTypeCount = AsteroidTypeCount { -- I don't really like this name tbh
    asteroidType :: AsteroidType,
    asteroidCount :: Int
}

data SpawnMethod = 
        Random  
    |   Alternating
    |   Custom ([AsteroidTypeCount] -> [Asteroid]) -- pass any function that takes the counts for each type and creates a list of asteroids

makeAsteroidWave :: [AsteroidTypeCount] -> SpawnMethod -> [Asteroid]
makeAsteroidWave atcs (Custom customMethod) = customMethod atcs 
-- makeAsteroidWave Random = 
-- makeAstroidWave Alternating = 