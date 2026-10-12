-- Initial state of the game. The data types themselves live in DataTypes.Types.
module Model where

import System.Random (StdGen)

import DataTypes.Types

-- Number of lives the player starts with.
startingLives :: Int
startingLives = 3

-- The state the game starts in. The random generator is created in 'Main'
-- (an IO action) and passed in, so this function stays pure.
-- For now this contains one demo asteroid so that we can see something move.
initialState :: StdGen -> GameState
initialState gen = GameState
    { status = Playing
    , player = initialPlayer
    , playingField = PlayingField
        { asteroids  = [demoAsteroid]
        , enemies    = []
        , bullets    = []
        , explosions = []
        }
    , score = 0
    , highScores = []
    , rng = gen
    }

initialPlayer :: Player
initialPlayer = Player
    { playerPosition        = Position 0 0
    , playerVelocity        = Velocity 0 0
    , playerFacingDirection = 0   -- degrees, 0 = pointing up (see View.drawPlayer)
    , playerLives           = startingLives
    , playerFireCooldown    = 0
    }

-- Temporary asteroid, to be replaced by the wave spawner.
demoAsteroid :: Asteroid
demoAsteroid = Asteroid
    { asteroidPosition = Position (-200) 100
    , asteroidVelocity = Velocity 30 (-10)
    , asteroidSize     = 4
    , asteroidKind     = Regular
    }
