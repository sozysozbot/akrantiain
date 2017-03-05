{-# OPTIONS -Wall -fno-warn-unused-do-bind #-}
import Akrantiain.Lexer
import Text.Parsec
import System.Environment
import System.IO
import Akrantiain.Expand
import Akrantiain.Cook
import Akrantiain.Normalize

main :: IO ()
main = do
 args <- getArgs
 case args of
  []    -> putStrLn "mi'e .akrantiain."
  (fname:_) -> do
   handle <- openFile fname ReadMode 
   hSetEncoding handle utf8
   input <- hGetContents handle
   runParser sentences () fname input >>>= \sents ->
    expand sents >>>= \conv2_arr -> 
    part2 conv2_arr
    

(>>>=) :: (Show a) => Either a b -> ( b -> IO ()) -> IO ()
Left  a >>>= _  = hPutStrLn stderr $ show a
Right b >>>= f  = f b

part2 :: [Conv2] -> IO ()
part2 conv2_arr = do
 print conv2_arr
