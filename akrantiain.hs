--{-# OPTIONS -Wall -fno-warn-unused-do-bind #-}
import Akrantiain.Lexer
import Text.Parsec
import System.Environment
import System.IO

main :: IO ()
main = do
 args <- getArgs
 case args of
  []    -> putStrLn "mi'e .akrantiain."
  (fname:_) -> do
   handle <- openFile fname ReadMode 
   hSetEncoding handle utf8
   input <- hGetContents handle
   case runParser sentences () fname input of
    Left err -> hPutStrLn stderr $ show err
    Right a -> print a



