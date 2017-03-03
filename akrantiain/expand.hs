{-# OPTIONS -Wall -fno-warn-unused-do-bind #-}

module Akrantiain.Expand
(SemanticError(..)
,expand
,Conv2(..)
,Orthography'
) where

import Akrantiain.Structure
import Akrantiain.Resolve_definitions
import qualified Data.Set as S
import qualified Data.Map as M
import Akrantiain.Resolve_definitions
data Conv2 = Conv [Orthography'] [Phoneme] deriving(Show, Eq, Ord)
data Orthography' = Boundary' | Neg' Quote | Pos' Quote deriving(Show, Eq, Ord)


expand :: [Sentence] -> Either SemanticError [Conv2]
expand sents = do 
 (orthoset, identmap) <- split sents
 newMap <- candids_to_quotes identmap
 undefined newMap orthoset


split :: [Sentence] -> Either SemanticError (S.Set([Orthography],[Phoneme]),M.Map Identifier [Candidates])
split [] = Right (S.empty, M.empty)
split (Conversion orthos phonemes : xs) = do 
  (s,m) <- split xs 
  return (S.insert (orthos, phonemes) s , m) -- duplicate is detected later
split (Define ident@(Id i) cands : xs) = do 
  (s,m) <- split xs 
  if ident `M.member` m 
   then Left $ E{errNum = 0, errStr = "duplicate definition of identifier {"++ i ++ "}"} 
   else Right (s, M.insert ident cands m)

