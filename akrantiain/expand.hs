{-# OPTIONS -Wall -fno-warn-unused-do-bind #-}

module Akrantiain.Expand
(
) where

import Akrantiain.Structure
import qualified Data.Set as S
import qualified Data.Map as M

data Conv2 = Conv [Orthography'] [Phoneme] deriving(Show, Eq, Ord)
data Orthography' = Boundary' | Neg' Quote | Pos' Quote deriving(Show, Eq, Ord)

expand :: [Sentence] -> [Conv2]
expand = undefined . split

split :: [Sentence] -> (S.Set([Orthography],[Phoneme]),M.Map Identifier [Candidates])
split [] = (S.empty, M.empty)
split (Conversion orthos phonemes : xs) = (S.insert (orthos, phonemes) s , m)
 where (s,m) = split xs 
split (Define ident cands : xs) = let (s,m) = split xs in 
 if ident `M.member` m then undefined else (s, M.insert ident cands m)

