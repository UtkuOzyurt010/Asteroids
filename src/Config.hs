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

-- asteroids smaller than this are destroyed instead of split
minAsteroidSize :: Int
minAsteroidSize = 1

-- number of pieces a hit asteroid splits into
asteroidSplitCount :: Int
asteroidSplitCount = 2

-- explosion radius of exploding asteroids, chosen when they spawn
explosionRadiusRange :: (Float, Float)
explosionRadiusRange = (60, 120)

-- ENEMIES

enemySpeedRange :: (Float, Float)
enemySpeedRange = (40, 80)

-- size of newly spawned enemies
enemySpawnSize :: Int
enemySpawnSize = 3

-- seconds until a new shooter fires its first shot
shooterFirstShotRange :: (Float, Float)
shooterFirstShotRange = (1, 3)

-- chasers accelerate towards the player, up to a maximum speed
chaserAcceleration, chaserMaxSpeed :: Float
chaserAcceleration = 120
chaserMaxSpeed     = 110

-- shooters approach more slowly...
shooterAcceleration, shooterMaxSpeed :: Float
shooterAcceleration = 80
shooterMaxSpeed     = 70

-- ...and brake once they are this close to the player
shooterRange :: Float
shooterRange = 220

-- seconds between two shots of a shooter
shooterFireInterval :: Float
shooterFireInterval = 2

-- bullets fired by enemies
enemyBulletSpeed :: Float
enemyBulletSpeed = 200

enemyBulletSize :: Int
enemyBulletSize = 1

-- WAVES

-- regular asteroids in wave n: baseAsteroidsPerWave + n
baseAsteroidsPerWave :: Int
baseAsteroidsPerWave = 2

-- seconds between the asteroids of a wave entering the field
asteroidSpawnInterval :: Float
asteroidSpawnInterval = 0.4

-- one more exploding asteroid every this many waves
wavesPerExplodingAsteroid :: Int
wavesPerExplodingAsteroid = 2

-- one more enemy every this many waves
wavesPerEnemy :: Int
wavesPerEnemy = 3

-- VIEW
