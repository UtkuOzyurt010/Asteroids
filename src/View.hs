module View where

import DataTypes.Types

import Graphics.Gloss (Picture, pictures)

import Assets
import Drawing
import Hud (drawHud)

-- entry point for Gloss: the rendering itself is pure, only the type is IO.
view :: Assets -> GameState -> IO Picture
view as = return . render as

-- turn the whole game state into a picture.
-- gloss draws in list order, so explosions go over the asteroids, then the player, then the HUD.
render :: Assets -> GameState -> Picture
render as gs = pictures $
    map (draw as) (asteroids field)
    ++ map (draw as) (enemies field)
    ++ map (draw as) (bullets field)
    ++ map (draw as) (explosions field)
    ++ [draw as (player gs), drawHud gs]
  where
    field = playingField gs
