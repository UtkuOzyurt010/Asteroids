module Drawing where

import Graphics.Gloss (translate, rotate, Picture)

import DataTypes.Types
import Assets

-- move a picture (drawn around the origin) to a game position.
atPosition :: Position -> Picture -> Picture
atPosition pos = translate (px pos) (py pos)

class Drawable a where
    --atPosition :: Position -> Picture -> Picture
    draw :: Assets -> a -> Picture

instance Drawable Player where
    draw as p =
        atPosition (playerPosition p)
        . rotate (playerFacingDirection p)
        $ playerImage as

instance Drawable Asteroid where
    draw as a =
        atPosition (asteroidPosition a)
        $ asteroidImage as

instance Drawable Enemy where
    draw as e =
        atPosition (enemyPosition e)
        $ enemyImage as

instance Drawable Bullet where
    draw as b =
        atPosition (bulletPosition b)
        $ bulletImage as

-- draw :: Drawable a => Assets -> a ->  Picture
-- draw as obj = draw' as obj
  

