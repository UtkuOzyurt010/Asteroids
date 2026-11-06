module Explosions
    ( explosionFor
    , updateExplosions
    , explosionProgress
    , currentRadius
    ) where

import Config
import DataTypes.Types

-- the explosion an asteroid causes when hit, if it is an exploding one
-- the radius was chosen randomly at spawn, so no randomness is needed here
explosionFor :: Asteroid -> Maybe Explosion
explosionFor a = case asteroidKind a of
    Exploding r -> Just (Explosion (asteroidPosition a) 0 r)
    Regular     -> Nothing

-- ages all explosions and removes the finished ones
-- driven by time, so the animation speed doesn't depend on the frame rate
updateExplosions :: Float -> [Explosion] -> [Explosion]
updateExplosions dt = filter (not . isFinished) . map (ageBy dt)

ageBy :: Float -> Explosion -> Explosion
ageBy dt e = e { explosionAge = explosionAge e + dt }

isFinished :: Explosion -> Bool
isFinished e = explosionAge e >= explosionDuration

-- runs from 0 when the explosion starts to 1 when it is finished
explosionProgress :: Explosion -> Float
explosionProgress e = min 1 (explosionAge e / explosionDuration)

-- grows from 0 to explosionRadius; used for both drawing and collision,
-- so what the player sees matches what can hit them
currentRadius :: Explosion -> Float
currentRadius e = explosionProgress e * explosionRadius e