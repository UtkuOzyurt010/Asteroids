module Main where

import Controller
import Model
import View
import Config

import Graphics.Gloss.Interface.IO.Game
import System.Random (newStdGen)

main :: IO ()
main = do
    gen <- newStdGen   -- the only place where the random seed is created (IO)
    playIO (InWindow "Asteroids" (screenWidth, screenHeight) (0, 0)) -- Or FullScreen
           black            -- Background color
           60               -- Frames per second
           (initialState gen) -- Initial state
           view             -- View function
           input            -- Event function
           step             -- Step function
