# Asteroids

Asteroids game in Haskell with Gloss for the Functional Programming course 2026/2027, Utrecht University.

## Running the game

dependencies: GHC, cabal, freeglut (for gloss)

```
cabal build
cabal run asteroids
```

run it from the project folder, because the images are loaded from `src/Assets/`

the high scores are saved to `highscores.txt` in the folder you start the game from

## Controls

| key        | action                             |
| ---------- | ---------------------------------- |
| W A S D    | accelerate up, left, down, right   |
| mouse      | aim (the ship faces the cursor)    |
| space      | shoot                              |
| p          | pause and continue                 |
| esc        | close the game                     |

## How to play

- asteroids come in waves, the next wave starts once the field is empty, and every wave is bigger
- shot asteroids split into smaller pieces until they are too small to split
- red-orange asteroids explode when shot, and the explosion costs the player a life if they are inside it
- enemies join in from wave 3
- blue chasers fly at the player
- purple shooters keep their distance and fire bullets at the player
- the player loses a life when they touch an asteroid or enemy, get shot, or are caught in an explosion
- the player starts with 3 lives and at 0 the game is over and their score goes into the top 10 high scores
- score, lives and wave are shown in the top-left corner
