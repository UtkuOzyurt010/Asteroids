-- gameplay constants so the game logic has no magic numbers
module Config where

import Graphics.Gloss (Color, white)

-- window size in pixels
screenWidth, screenHeight :: Int
screenWidth  = 800
screenHeight = 600

-- half the screen size where (0, 0) is the centre of the screen
halfWidth, halfHeight :: Float
halfWidth  = fromIntegral screenWidth  / 2
halfHeight = fromIntegral screenHeight / 2

-- IO / Highscores
highScoreFile :: FilePath
highScoreFile = "highscores.txt"
maxHighScores :: Int
maxHighScores = 10

-- PLAYER

-- number of lives the player starts with
startingLives :: Int
startingLives = 3

dragStrength :: Float
dragStrength = 60
accStrength :: Float
accStrength = 150

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

-- seconds an explosion lasts, growing from radius 0 to its full radius while fading out
explosionDuration :: Float
explosionDuration = 0.6

-- ENEMIES

enemySpeedRange :: (Float, Float)
enemySpeedRange = (40, 80)

-- size of newly spawned enemies
enemySpawnSize :: Int
enemySpawnSize = 3

-- seconds until a new shooter fires its first shot
shooterFirstShotRange :: (Float, Float)
shooterFirstShotRange = (1, 3)

-- chasers accelerate towards the player, up to a maximum speed (px/s^2, px/s)
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

-- scale of the HUD text (gloss text is about 100 px tall, so about 15 px)
hudTextScale :: Float
hudTextScale = 0.15

-- distance from the screen edge to the HUD text
hudMargin :: Float
hudMargin = 20

-- vertical distance between two lines of HUD text
hudLineSpacing :: Float
hudLineSpacing = 25

-- colour of the HUD text
hudColor :: Color
hudColor = white

-- the asteroid bitmaps are 160 px wide so this scales a full-size asteroid down to 32 px
asteroidImageScale :: Float
asteroidImageScale = 0.2
