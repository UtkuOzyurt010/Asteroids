module Assets where

import Graphics.Gloss (loadBMP, Picture, scale)

data Assets = Assets {
    playerImage :: Picture,
    asteroidImage :: Picture,
    enemyImage :: Picture,
    bulletImage :: Picture
}

loadAssets :: IO Assets 
loadAssets = do 
    playerBmp   <- loadBMP "src/Assets/playerimage.bmp"
    asteroidBmp <- loadBMP "src/Assets/asteroidimage.bmp"
    enemyBmp   <- loadBMP "src/Assets/enemyimage.bmp"
    bulletBmp <- loadBMP "src/Assets/bulletimage.bmp"

    let scaledAsteroidBmp = scale 0.2 0.2 asteroidBmp

    return Assets
        { playerImage   = playerBmp
        , asteroidImage = scaledAsteroidBmp
        , enemyImage = enemyBmp
        , bulletImage = bulletBmp
        }

