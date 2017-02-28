--{-# OPTIONS -Wall -fno-warn-unused-do-bind #-}
import Akrantiain.Lexer
main :: IO ()
main = do
  parseTest conversion "\"a\" consonant ^ \"b\" -> /a/ $2 $3 /v/"
  parseTest define "consonant = \"a\" | c d | \"b\" \"d\" | cons2 | co \"c\" co" 
