module DataTypes.Types where

-- split if this file becomes too large
-- DataTypes folder can be removed otherwise

data Position = Position {
    px :: Float, -- access using e.g. "px pos" where "pos :: Position" 
    py :: Float
}

data Velocity = Velocity {
    vx :: Float, -- access using e.g. "vx vel" where "vel :: Velocity" 
    vy :: Float
}

data GameState = GameState { -- each element of GameState needs to exist
    player :: Player,
    playingField :: PlayingField,
    score :: Int,
    gameOver :: Bool
}

data Player = Player {
    playerPosition :: Position,
    -- speed :: Float                   -- likely redundant state
    -- movementDirection :: Position(?) -- likely redundant state
    playerVelocity :: Velocity,         -- velocity is a function of speed and movementDirection
    playerFacingDirection :: Float      -- facing direction separate from velocity -- 'angle' might be a better name
}

data PlayingField = PlayingField {
    asteroids :: [Asteroid],            -- maybe make Asteroid Constructor for Enemy type?
    enemies :: [Enemy],      
    bullets :: [Bullet]      
}

data AsteroidType -- used in e.g. AsteroidWaves.hs for spawning based on type, the constructors for the Asteroid data types are not usable for this
    = Regular
    | Exploding
    deriving (Show, Eq)

data Asteroid
    = RegularAsteroid {
        asteroidPosition :: Position,
        asteroidVelocity :: Velocity,
        asteroidSize :: Int, -- Shrinks on hit, e.g. size 4 splits to 2 asteroids of size 3 -- also use for graphical representation
        asteroidSplitsOnHit :: Bool
    }
    | ExplodingAsteroid {
        asteroidPosition :: Position,
        asteroidVelocity :: Velocity,
        asteroidSize :: Int,
        asteroidSplitsOnHit :: Bool,
        -- detectionRadius :: Float, -- could use explosionRadius for simplicity
        asteroidExplosionRadius :: Float -- from center, not from edge -- should be at least equivalent to size+1? -- could thus also be derived from size
    }

-- might be obsolete, we could rename Asteroid to Enemy and let it have both Asteroid and Enemy spaceship constructors
-- but regular enemies might need 'smarter' movement/aiming mechanics
-- but differing mechanics can also be handled with type pattern-matching under the same Enemy type
-- so the question is should we have 1 unified Enemy type with 1 [Enemy] list or keep them separate?
data Enemy = Enemy { 
    enemyPosition :: Position,
    enemyVelocity :: Velocity,
    enemyHasGun :: Bool,
    enemySize :: Int -- use for graphical representation
}

data Bullet = Bullet {
    bulletPosition :: Position,
    bulletVelocity :: Velocity,
    bulletSize :: Int
    -- damagePoints :: Int 
}

