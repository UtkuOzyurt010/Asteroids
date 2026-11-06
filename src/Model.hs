module Model where

import System.Random (StdGen)

import Config (startingLives)
import DataTypes.Types

-- The state the game starts in. The random generator is created in 'Main'
-- (an IO action) and passed in, so this function stays pure.
-- The field starts empty, so the first update spawns wave 1.
initialState :: StdGen -> [Int] -> GameState
initialState gen scores = GameState
    { status = Playing
    , player = initialPlayer
    , playingField = PlayingField
        { asteroids  = []
        , incomingAsteroids = []
        , enemies    = []
        , bullets    = []
        , explosions = []
        }
    , score = 0
    , highScores = scores
    , wave = 0
    , rng = gen
    }

initialPlayer :: Player
initialPlayer = Player
    { playerPosition        = Position 0 0
    , playerVelocity        = Velocity 0 0
    , playerAcceleration    = Acceleration 0 0
    , playerFacingDirection = 0   -- degrees, 0 = pointing up
    , playerLives           = startingLives
    , playerFireCooldown    = 0
    }