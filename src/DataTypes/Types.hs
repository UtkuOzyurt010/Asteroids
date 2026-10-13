module DataTypes.Types where

import System.Random (StdGen)

-- split if this file becomes too large
-- DataTypes folder can be removed otherwise

data Position = Position {
    px :: Float, -- access using e.g. "x pos" where "pos :: Position" 
    py :: Float
} deriving (Show, Eq)

data Velocity = Velocity {
    vx :: Float, -- access using e.g. "x vel" where "vel :: Velocity" 
    vy :: Floatdata Position = Position {
    px :: Float, -- access using e.g. "px pos" where "pos :: Position"
    py :: Float
} deriving (Show, Eq)

data Velocity = Velocity {
    vx :: Float, -- access using e.g. "vx vel" where "vel :: Velocity"
    vy :: Float
} deriving (Show, Eq)

-- whether the game is running, paused or finished.
-- replaces the old 'gameOver :: Bool'; 'step' only updates the world while 'Playing'.
data GameStatus = Playing | Paused | GameOver
    deriving (Show, Eq)

-- no 'deriving' here on purpose: whether 'StdGen' has Eq/Show depends on the 'random' version.
data GameState = GameState { -- each element of GameState needs to exist
    status       :: GameStatus,
    player       :: Player,
    playingField :: PlayingField,
    score        :: Int,
    highScores   :: [Int],  -- loaded from / saved to a file (IO requirement)
    rng          :: StdGen  -- random generator, threaded through the pure game logic
}

data Player = Player {
    playerPosition :: Position,
    -- speed and movement direction are not stored separately: they would be
    -- redundant state, since velocity is a function of both
    playerVelocity :: Velocity,
    playerFacingDirection :: Float, -- facing direction separate from velocity -- 'angle' might be a better name
    playerLives :: Int,
    playerFireCooldown :: Float     -- seconds until the player may shoot again
} deriving (Show, Eq)

data PlayingField = PlayingField {
    asteroids  :: [Asteroid],
    enemies    :: [Enemy],
    bullets    :: [Bullet],
    explosions :: [Explosion]  -- short-lived animations (animation requirement)
} deriving (Show, Eq)

data AsteroidType -- used in e.g. AsteroidWaves.hs for spawning based on type, the constructors for the Asteroid data types are not usable for this
    = Regular
    | Exploding Float -- explosion radius, from center, not from edge
    deriving (Show, Eq)

-- one record for all asteroids; what makes them differ lives in 'asteroidKind'.
-- whether an asteroid splits on hit is derived from its kind and size, not stored.
data Asteroid = Asteroid {
    asteroidPosition :: Position,
    asteroidVelocity :: Velocity,
    asteroidSize :: Int, -- shrinks on hit, e.g. size 4 splits to 2 asteroids of size 3 -- also use for graphical representation
    asteroidKind :: AsteroidKind
} deriving (Show, Eq)

-- how an enemy behaves, i.e. their "intelligence".
data EnemyBehaviour
    = Chaser          -- flies towards the player
    | Shooter Float   -- keeps its distance and shoots; seconds until its next shot
    deriving (Show, Eq)

-- asteroids and enemies stay separate types: they behave differently (enemies aim and shoot).
data Enemy = Enemy {
    enemyPosition :: Position,
    enemyVelocity :: Velocity,
    enemyBehaviour :: EnemyBehaviour,
    enemySize :: Int -- use for graphical representation
} deriving (Show, Eq)

-- who fired a bullet, so that bullets only hurt the other side.
data Owner = FromPlayer | FromEnemy
    deriving (Show, Eq)

data Bullet = Bullet {
    bulletPosition :: Position,
    bulletVelocity :: Velocity,
    bulletSize :: Int,
    bulletOwner :: Owner
    -- damagePoints :: Int
} deriving (Show, Eq)

-- an explosion animation: it grows/fades with its age and is removed after a fixed duration.
data Explosion = Explosion {
    explosionPosition :: Position,
    explosionAge :: Float -- seconds since it started
} deriving (Show, Eq)
