{-# OPTIONS -Wall -fno-warn-unused-do-bind #-}
import Akrantiain.Lexer
import Text.Parsec
import System.Environment
import System.IO
import Akrantiain.Expand
import Akrantiain.Cook
import Akrantiain.Normalize
import Akrantiain.Structure

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
    getFunc sents >>>= \func -> interact func
    

(>>>=) :: (Show a) => Either a b -> ( b -> IO ()) -> IO ()
Left  a >>>= _  = hPutStrLn stderr $ show a
Right b >>>= f  = f b


getFunc :: Set Sentence -> (Either SemanticError (Input -> Output))
getFunc sents = do
 conv2_arr <- expand sents
 foobar <- mysterious conv2_arr
 cookBy foobar

mysterious :: [Conv2] -> Either SemanticError Fixme3
mysterious cccccccc = Right Fixme3





