-- | Initial state of the game. The data types themselves live in DataTypes.Types.
module Model where

import DataTypes.Types

-- | The state the game starts in.
-- For now this contains one demo asteroid so that we can see something move.
initialState :: GameState
initialState = GameState
    { player = initialPlayer
    , playingField = PlayingField
        { asteroids = [demoAsteroid]
        , enemies   = []
        , bullets   = []
        }
    , score = 0
    , gameOver = False
    }

initialPlayer :: Player
initialPlayer = Player
    { playerPosition        = Position 0 0
    , playerVelocity        = Velocity 0 0
    , playerFacingDirection = 0   -- degrees, 0 = pointing up (see View.drawPlayer)
    }

-- | Temporary asteroid, to be replaced by the wave spawner.
demoAsteroid :: Asteroid
demoAsteroid = RegularAsteroid
    { asteroidPosition    = Position (-200) 100
    , asteroidVelocity    = Velocity 30 (-10)
    , asteroidSize        = 4
    , asteroidSplitsOnHit = True
    }
