--{-# OPTIONS -Wall -fno-warn-unused-do-bind #-}

module Akrantiain.Lexer
(
) where

import Text.Parsec 

import Control.Applicative ((<$>),(*>),(<*),pure)
import Data.Char (ord)
import Text.Parsec (char, oneOf, (<|>), parseTest)
import Text.Parsec.String (Parser)
-- import Prelude hiding (undefined)

sample :: String
sample = "\"a\" -> /A/;\"b\" -> /B/\n\"c\" -> /C/;\n\"o\" -> /O/\n\"oo\" -> /8/"

type Candidates = [Candidate]
data Sentence = Convert [Orthography] [Phoneme] | Define Identifier [Candidates] deriving(Show, Eq, Ord)
data Orthography = Boundary | Neg Candidate | Pos Candidate deriving(Show, Eq, Ord)
data Phoneme = Dollar Int | Slash String deriving(Show, Eq, Ord)
type Candidate = Either String Identifier
newtype Identifier = Id String deriving(Show, Eq, Ord)
{-
Sentence(Convert) : "a" consonant ^ "b" -> /a/ $2 $3 /v/
Sentence(Define) : consonant = "a" | "b" "d" | cons2 | co "c" co 
Orthography(Boundary) : ^
Orthography(Neg Candidate) : !"a"   or   !cons
Orthography(Pos Candidate) : "a"   or   cons
Phoneme(Dollar Int) : $2
Phoneme(Slash String): /v/
-}
