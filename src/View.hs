module View where

import Graphics.Gloss
    ( Picture, Color, pictures, color, translate, rotate
    , polygon, circle, circleSolid, white, red, yellow )

import DataTypes.Types

-- Drawing constants (no magic numbers in the drawing code below)

-- | Pixels of radius per unit of 'asteroidSize' / 'enemySize' / 'bulletSize'.
sizeUnit :: Float
sizeUnit = 8

-- | Outline of the player's ship, pointing up.
shipShape :: [(Float, Float)]
shipShape = [(0, 15), (-10, -10), (10, -10)]

-- | Entry point for Gloss: the rendering itself is pure, only the type is IO.
view :: GameState -> IO Picture
view = return . render

-- | Turn the whole game state into a picture.
render :: GameState -> Picture
render gs = pictures $
    drawPlayer (player gs)
    : map drawAsteroid (asteroids field)
    ++ map drawEnemy (enemies field)
    ++ map drawBullet (bullets field)
  where
    field = playingField gs

-- | Move a picture (drawn around the origin) to a game position.
atPosition :: Position -> Picture -> Picture
atPosition pos = translate (px pos) (py pos)

-- | Gloss rotates clockwise in degrees; 0 means pointing up.
drawPlayer :: Player -> Picture
drawPlayer p =
    atPosition (playerPosition p)
    . rotate (playerFacingDirection p)
    . color white
    $ polygon shipShape

drawAsteroid :: Asteroid -> Picture
drawAsteroid a =
    atPosition (asteroidPosition a)
    . color white
    $ circle (fromIntegral (asteroidSize a) * sizeUnit)

drawEnemy :: Enemy -> Picture
drawEnemy e =
    atPosition (enemyPosition e)
    . color red
    $ circleSolid (fromIntegral (enemySize e) * sizeUnit)

drawBullet :: Bullet -> Picture
drawBullet b =
    atPosition (bulletPosition b)
    . color bulletColor
    $ circleSolid (fromIntegral (bulletSize b) * sizeUnit)
  where
    bulletColor :: Color
    bulletColor = yellow
