module View where

import DataTypes.Types

import Graphics.Gloss (Picture, pictures)

import Assets
import Drawing

-- entry point for Gloss: the rendering itself is pure, only the type is IO.
view :: Assets -> GameState -> IO Picture
view as = return . render as

-- turn the whole game state into a picture.
render :: Assets -> GameState -> Picture
render as gs = pictures $
    (draw as) (player gs)
    : map (draw as) (asteroids field)
    ++ map (draw as) (enemies field)
    ++ map (draw as) (bullets field)
  where
    field = playingField gs

-- -- move a picture (drawn around the origin) to a game position.
-- atPosition :: Position -> Picture -> Picture
-- atPosition pos = translate (px pos) (py pos)

-- -- gloss rotates clockwise in degrees; 0 means pointing up.
-- drawPlayer :: Assets -> Player -> Picture
-- drawPlayer as p =
--     atPosition (playerPosition p)
--     . rotate (playerFacingDirection p)
--     -- . color white
--     $ playerImage as

-- drawAsteroid :: Assets -> Asteroid -> Picture
-- drawAsteroid as a =
--     atPosition (asteroidPosition a)
--     -- . color (asteroidColor (asteroidKind a))
--     $ asteroidImage as

-- asteroidColor :: AsteroidKind -> Color
-- asteroidColor Regular       = white
-- asteroidColor (Exploding _) = orange

-- drawEnemy :: Assets -> Enemy -> Picture
-- drawEnemy as e =
--     atPosition (enemyPosition e)
--     -- . color red
--     $ enemyImage as

-- drawBullet :: Assets -> Bullet -> Picture
-- drawBullet as b =
--     atPosition (bulletPosition b)
--     -- . color (bulletColor (bulletOwner b))
--     $ bulletImage as

-- bulletColor :: Owner -> Color
-- bulletColor FromPlayer = yellow
-- bulletColor FromEnemy  = red
