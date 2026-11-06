module Hud (drawHud) where

import Graphics.Gloss (Picture, pictures, translate, scale, color, text)

import Config (halfWidth, halfHeight, hudTextScale, hudMargin, hudLineSpacing, hudColor)
import DataTypes.Types

-- all HUD lines, stacked below each other in the top-left corner
drawHud :: GameState -> Picture
drawHud gs =
    translate (hudMargin - halfWidth) (halfHeight - hudMargin - hudLineSpacing)
    . pictures
    $ zipWith drawLine [0 ..] (statLines gs ++ statusLines gs)

-- one line of text, i lines below the first
drawLine :: Int -> String -> Picture
drawLine i = translate 0 (negate (fromIntegral i * hudLineSpacing))
    . scale hudTextScale hudTextScale . color hudColor . text

statLines :: GameState -> [String]
statLines gs =
    [ "Score: " ++ show (score gs)
    , "Lives: " ++ show (playerLives (player gs))
    , "Wave: "  ++ show (wave gs)
    ]

-- extra lines that depend on the game status
statusLines :: GameState -> [String]
statusLines gs = case status gs of
    Playing  -> []
    Paused   -> ["PAUSED - press p"]
    GameOver -> ["GAME OVER", "High scores: " ++ unwords (map show (highScores gs))]
