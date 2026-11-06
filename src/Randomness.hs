module Randomness
    ( Rand
    , randomInRange
    , mapRand
    , replicateRand
    , shuffle
    ) where

import Data.List (mapAccumL, sortOn)
import System.Random (Random, StdGen, randomR)

-- takes a generator, returns a random value and the next generator
type Rand a = StdGen -> (a, StdGen)

-- random value between the bounds, e.g. for Float, Int or Bool
randomInRange :: Random a => (a, a) -> Rand a
randomInRange = randomR

-- applies a random function to each element, passing the generator along
mapRand :: (a -> Rand b) -> [a] -> Rand [b]
mapRand f xs gen = (ys, gen')
  where
    (gen', ys) = mapAccumL step gen xs
    step g x = let (y, g') = f x g in (g', y) -- mapAccumL wants (state, result)

-- runs a random computation n times, e.g. to spawn n enemies
replicateRand :: Int -> Rand a -> Rand [a]
replicateRand n r = mapRand (const r) (replicate n ())

-- random order: give each element a random key and sort by it
shuffle :: [a] -> Rand [a]
shuffle xs gen = (map snd (sortOn fst keyed), gen')
  where
    (keyed, gen') = mapRand withKey xs gen
    withKey x g   = let (k, g') = randomInRange (0, 1 :: Float) g
                    in ((k, x), g')