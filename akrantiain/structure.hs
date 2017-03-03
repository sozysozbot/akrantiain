--{-# OPTIONS -Wall -fno-warn-unused-do-bind #-}

module Akrantiain.Structure
(Candidates(..)
,Sentence(..)
,Orthography(..)
,Phoneme(..)
,Candidate(..)
,Resolved(..)
,Identifier(..)
,Quote(..)
,Resolveds(..)
) where

newtype Resolveds = R [Resolved]
newtype Candidates = C [Candidate] deriving(Show, Eq, Ord)
data Sentence = Conversion [Orthography] [Phoneme] | Define Identifier [Candidates] deriving(Show, Eq, Ord)
data Orthography = Neg Candidate | Pos Candidate deriving(Show, Eq, Ord)
data Phoneme = Dollar Int | Slash String deriving(Show, Eq, Ord)
data Candidate = Res Resolved | Ide Identifier deriving(Show, Eq, Ord)
data Resolved = Boundary | Quo Quote deriving(Show, Eq, Ord)
newtype Identifier = Id String deriving(Show, Eq, Ord)
newtype Quote = Quote String deriving(Show, Eq, Ord)
{-
Sentence(Conversion) : "a" consonant ^ "b" -> /a/ $2 $3 /v/
Sentence(Define) : consonant = "a" | "b" "d" | cons2 | co "c" co 
Orthography(Boundary) : ^
Orthography(Neg Candidate) : !"a"   or   !cons
Orthography(Pos Candidate) : "a"   or   cons
Phoneme(Dollar Int) : $2
Phoneme(Slash String): /v/
-}
{-
Sentence(Conversion) : "a" consonant ^ "b" -> /a/ $2 $3 /v/
Sentence(Define) : consonant = "a" | "b" "d" | cons2 | co "c" co 
-}
