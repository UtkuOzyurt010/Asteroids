-- gameplay constants so the game logic has no magic numbers
module Config where

-- window size in pixels
screenWidth, screenHeight :: Int
screenWidth  = 800
screenHeight = 600

-- half the screen size where (0, 0) is the centre of the screen
halfWidth, halfHeight :: Float
halfWidth  = fromIntegral screenWidth  / 2
halfHeight = fromIntegral screenHeight / 2

-- SPAWNING

-- how far outside the visible screen new objects appear
spawnMargin :: Float
spawnMargin = 40

-- new objects never appear closer than this to the player..
minSpawnDistance :: Float
minSpawnDistance = 250

-- ...unless no valid spot was found after this many tries
maxSpawnAttempts :: Int
maxSpawnAttempts = 10

-- asteroids fly towards the centre of the screen, give or take this many degrees
inwardSpread :: Float
inwardSpread = 30

-- ASTEROIDS

asteroidSpeedRange :: (Float, Float)
asteroidSpeedRange = (30, 90)

-- size of the asteroids that start a wave
waveAsteroidSize :: Int
waveAsteroidSize = 4

-- WAVES

-- regular asteroids in wave n: baseAsteroidsPerWave + n
baseAsteroidsPerWave :: Int
baseAsteroidsPerWave = 2
