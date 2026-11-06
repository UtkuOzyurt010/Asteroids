-- enemy "intelligence": chasers fly into the player, shooters keep their distance and shoot
module Enemies
    ( updateEnemies
    ) where

import Data.Maybe (catMaybes)

import Config
import DataTypes.Types
import Movement

-- steers every enemy and collects the bullets fired this frame
-- the position is the player's; moving the enemies is left to 'move' in update
updateEnemies :: Float -> Position -> [Enemy] -> ([Enemy], [Bullet])
updateEnemies dt target es = (es', catMaybes shots)
  where
    (es', shots) = unzip (map (updateEnemy dt target . faceTowards target) es)

-- turns the enemy to face the target
faceTowards :: Position -> Enemy -> Enemy
faceTowards target e = e { enemyFacingDirection = angleTowards (enemyPosition e) target }

updateEnemy :: Float -> Position -> Enemy -> (Enemy, Maybe Bullet)
updateEnemy dt target e = case enemyBehaviour e of
    Chaser    -> (steerTowards dt target chaserAcceleration chaserMaxSpeed e, Nothing)
    Shooter t -> updateShooter dt target t e

-- approaches until within shooterRange, then brakes; fires whenever its timer runs out
updateShooter :: Float -> Position -> Float -> Enemy -> (Enemy, Maybe Bullet)
updateShooter dt target t e
    | t' > 0    = (moved { enemyBehaviour = Shooter t' }, Nothing)
    | otherwise = (moved { enemyBehaviour = Shooter shooterFireInterval }, Just (aimedBullet target e))
  where
    t' = t - dt
    moved
        | distance (enemyPosition e) target > shooterRange =
            steerTowards dt target shooterAcceleration shooterMaxSpeed e
        | otherwise = drag dt e

-- accelerates towards the target; because of its momentum it overshoots and has to turn back
steerTowards :: Float -> Position -> Float -> Float -> Enemy -> Enemy
steerTowards dt target acc maxSpeed e = limitSpeed maxSpeed (accelerate dt towards e)
  where
    (dx, dy) = directionTo (enemyPosition e) target
    towards  = Acceleration (acc * dx) (acc * dy)

-- bullet from the enemy straight at the target
aimedBullet :: Position -> Enemy -> Bullet
aimedBullet target e = Bullet
    { bulletPosition = enemyPosition e
    , bulletVelocity = Velocity (enemyBulletSpeed * dx) (enemyBulletSpeed * dy)
    , bulletSize     = enemyBulletSize
    , bulletOwner    = FromEnemy
    }
  where
    (dx, dy) = directionTo (enemyPosition e) target

-- unit vector from one position to another; (0, 0) if they are the same
directionTo :: Position -> Position -> (Float, Float)
directionTo from to
    | d == 0    = (0, 0)
    | otherwise = ((px to - px from) / d, (py to - py from) / d)
  where
    d = distance from to