module Highscores where

import Config (maxHighScores)
import System.IO (readFile')

import Data.Maybe (mapMaybe)
import Text.Read (readMaybe)
import System.Directory (doesFileExist)

parseHighScores :: String -> [Int] -- text to scores, ignores invalid lines
parseHighScores = mapMaybe readMaybe . lines
showHighScores :: [Int] -> String -- scores to text, one per line
showHighScores = unlines . map show 
insertScore :: Int -> [Int] -> [Int] -- adds a score, keeps the best maxHighScores
insertScore score highScores = insertScore' score highScores
    where
        highScoresCount = length highScores
        insertScore' s [] = [s]
        insertScore' s (x:xs) -- prefer old highscore when equal
            | s > x && highScoresCount == maxHighScores = init (s:x:xs) -- max 10 highscores, so remove last is there's already 10
            | s > x                                     = (s:x:xs)      -- simply 
            | otherwise                                 = x : insertScore' s xs

loadHighScores :: FilePath -> IO [Int]
loadHighScores path = do
    exists <- doesFileExist path
    if exists
        then parseHighScores <$> readFile' path
        else return [] -- first run: no file yet

saveHighScores :: FilePath -> [Int] -> IO ()
saveHighScores path = writeFile path . showHighScores