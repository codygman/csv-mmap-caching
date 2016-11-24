{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}
module Main where

import GHC.Generics
import Data.Csv
import qualified Data.Vector as V
import qualified Data.Vector.Generic as GV
import qualified Data.Vector.Storable as SV
import qualified Data.ByteString.Lazy as LBS
import Foreign.Storable.Generic
import Data.Packed.Vector.MMap

-- 266, 909, 159625, 159627, 2635, 20000827.0117590018, 1239029, 1341, -26.399744, 1228, 0.56000537, 48
data Star = Star { a :: Int -- 266
                 , b :: Int -- 909
                 , c :: Int -- 159625
                 , d :: Int -- 159625
                 , e :: Int -- 2635
                 , f :: Double -- 20000827.0117590018
                 , g :: Int -- 1239029
                 , h :: Int -- 1341
                 , i :: Double -- -26.399744
                 , j :: Int -- 1228
                 , k :: Double -- 0.56000537
                 , l :: Int -- 48
                 } deriving (Show,Read,Generic)

instance GStorable Star
instance FromRecord Star
instance ToRecord Star

main :: IO ()
main = do

  -- bs <- LBS.readFile "star.csv"
  bs <- LBS.readFile "star2000.csv"
  -- bs <- LBS.readFile "star2000-double.csv"
  -- bs <- LBS.readFile "star2002-full.csv"
  case (decode NoHeader bs :: Either String (V.Vector Star)) of
    Right stars -> do
      putStrLn "START writing mmap"
      writeVector "star2000.mmap" (GV.convert stars)
      putStrLn "DONE writing mmap"
      -- putStrLn $ "There are " ++ (show . SV.length $ stars) ++ " stars"
    Left e -> print $ "error: " ++ e

  -- read from mmap
  stars <- GV.convert <$> (unsafeMMapVector "star2000.mmap" Nothing :: IO (SV.Vector Star))
  putStrLn $ "There are " ++ (show . V.length $ stars) ++ " stars"

