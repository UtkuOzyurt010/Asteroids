module Assets where

import Graphics.Gloss (loadBMP, Picture(Bitmap), scale, )
import Graphics.Gloss.Data.Bitmap (bitmapSize)

data Assets = Assets {
    playerImage :: Picture,
    asteroidImage :: Picture,
    enemyImage :: Picture,
    bulletImage :: Picture,

    playerRadius :: Float,
    asteroidRadius :: Float,
    enemyRadius :: Float,
    bulletRadius :: Float
}

getRadiusfromPicture :: Picture -> Float
getRadiusfromPicture (Bitmap bmp) = 
    let (w, h) = bitmapSize bmp
    in fromIntegral (max w h) / 2 -- w and h have type Int

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
        , playerRadius = getRadiusfromPicture playerBmp
        , asteroidRadius = getRadiusfromPicture scaledAsteroidBmp
        , enemyRadius = getRadiusfromPicture enemyBmp
        , bulletRadius = getRadiusfromPicture bulletBmp
        }


