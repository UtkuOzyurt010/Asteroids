module Main where

import DataTypes.Types
import AsteroidWaves
import Movement

main :: IO ()
main = do
    let asteroid = RegularAsteroid
            { asteroidPosition = Position 10 20
            , asteroidVelocity = Velocity 5 3
            , asteroidSize = 4
            , asteroidSplitsOnHit = True
            }

    let movedAsteroid = move asteroid 0.5

    putStrLn "Original position:"
    printPosition (getPosition asteroid)

    putStrLn "Position after moving 0.5 seconds:"
    printPosition (getPosition movedAsteroid)

printPosition :: Position -> IO ()
printPosition pos =
    putStrLn ("(" ++ show (px pos) ++ ", " ++ show (py pos) ++ ")")