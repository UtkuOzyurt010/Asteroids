module Drawing where

import Graphics.Gloss (translate, rotate, scale, Picture, color, circleSolid, withAlpha, orange)

import DataTypes.Types
import Assets
import Explosions (explosionProgress, currentRadius)
import Movement (velocityAngle)

-- move a picture (drawn around the origin) to a game position.
atPosition :: Position -> Picture -> Picture
atPosition pos = translate (px pos) (py pos)

class Drawable a where
    draw :: Assets -> a -> Picture

instance Drawable Player where
    draw as p =
        atPosition (playerPosition p)
        . rotate (playerFacingDirection p)
        $ playerImage as

instance Drawable Asteroid where
    draw as a =
        atPosition (asteroidPosition a)
        $ scale aScale aScale (image (asteroidKind a))
        where aScale = asteroidScale a
              image Regular       = asteroidImage as
              image (Exploding _) = explodingAsteroidImage as

instance Drawable Enemy where
    draw as e =
        atPosition (enemyPosition e)
        . rotate (enemyFacingDirection e)
        $ image (enemyBehaviour e)
        where image Chaser      = enemyImage as
              image (Shooter _) = shooterImage as

instance Drawable Bullet where
    draw as b =
        atPosition (bulletPosition b)
        . rotate (velocityAngle (bulletVelocity b)) -- points the way it flies
        $ bulletImage as

-- explosions have no bitmap: an orange disc that grows and fades out
instance Drawable Explosion where
    draw _ e =
        atPosition (explosionPosition e)
        . color (withAlpha (1 - explosionProgress e) orange)
        $ circleSolid (currentRadius e)

