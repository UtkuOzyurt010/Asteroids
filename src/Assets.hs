module Assets where

import Graphics.Gloss (loadBMP, Picture(Bitmap, Scale), scale, )
import Graphics.Gloss.Data.Bitmap (bitmapSize)

import Config (asteroidImageScale, waveAsteroidSize)
import DataTypes.Types (Asteroid, asteroidSize)

data Assets = Assets {
    playerImage :: Picture,
    asteroidImage :: Picture,          -- regular asteroids
    explodingAsteroidImage :: Picture, -- same size as asteroidImage, so it shares asteroidRadius
    enemyImage :: Picture,             -- chasers
    shooterImage :: Picture,           -- same size as enemyImage, so it shares enemyRadius
    bulletImage :: Picture
}

data AssetsRadii = AssetsRadii {
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

-- an asteroid's image and radius relative to a full-size one, used for both drawing and collision
asteroidScale :: Asteroid -> Float
asteroidScale a = fromIntegral (asteroidSize a) / fromIntegral waveAsteroidSize

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
        }

loadAssetsRadii :: Assets -> IO AssetsRadii
loadAssetsRadii assets = return AssetsRadii {
        playerRadius = getRadiusfromPicture (playerImage assets)
        , asteroidRadius = getRadiusfromPicture (asteroidImage assets)
        , enemyRadius = getRadiusfromPicture (enemyImage assets)
        , bulletRadius = getRadiusfromPicture (bulletImage assets)
    }


