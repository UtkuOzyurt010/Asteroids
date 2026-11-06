module Assets where

import Graphics.Gloss (loadBMP, Picture(Bitmap, Scale), scale, )
import Graphics.Gloss.Data.Bitmap (bitmapSize)

import Config (asteroidImageScale)

data Assets = Assets {
    playerImage :: Picture,
    asteroidImage :: Picture,          -- regular asteroids
    explodingAsteroidImage :: Picture, -- same size as asteroidImage, so it shares asteroidRadius
    enemyImage :: Picture,             -- chasers
    shooterImage :: Picture,           -- same size as enemyImage, so it shares enemyRadius
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
-- a scaled picture has a scaled radius
getRadiusfromPicture (Scale sx sy pic) = max sx sy * getRadiusfromPicture pic
getRadiusfromPicture _ = 0

loadAssets :: IO Assets 
loadAssets = do 
    playerBmp   <- loadBMP "src/Assets/playerimage.bmp"
    asteroidBmp <- loadBMP "src/Assets/asteroidimage.bmp"
    explodingBmp <- loadBMP "src/Assets/explodingasteroidimage.bmp"
    enemyBmp   <- loadBMP "src/Assets/Ship_1.bmp"
    shooterBmp <- loadBMP "src/Assets/enemyimage.bmp"
    bulletBmp <- loadBMP "src/Assets/bulletimage.bmp"

    let scaleAsteroid = scale asteroidImageScale asteroidImageScale
        scaledAsteroidBmp = scaleAsteroid asteroidBmp

    return Assets
        { playerImage   = playerBmp
        , asteroidImage = scaledAsteroidBmp
        , explodingAsteroidImage = scaleAsteroid explodingBmp
        , enemyImage = enemyBmp
        , shooterImage = shooterBmp
        , bulletImage = bulletBmp
        , playerRadius = getRadiusfromPicture playerBmp
        , asteroidRadius = getRadiusfromPicture scaledAsteroidBmp
        , enemyRadius = getRadiusfromPicture enemyBmp
        , bulletRadius = getRadiusfromPicture bulletBmp
        }


