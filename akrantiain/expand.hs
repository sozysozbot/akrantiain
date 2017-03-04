--{-# OPTIONS -Wall -fno-warn-unused-do-bind #-}

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
import Data.Maybe(fromJust)

data Conv2 = Conv (Array Orthography') [Phoneme] deriving(Show, Eq, Ord)

-- List required only for $-numbering, which will be numbering [Orthography']
data Orthography' = Neg' [Resolved] | Pos' [Resolved] deriving(Show, Eq, Ord)
-- newtype Resolveds = R(Array Resolved)
-- newtype Candidates = C(Array Candidate) deriving(Show, Eq, Ord)
-- data Sentence = Conversion (Array Orthography) (Array Phoneme) | Define Identifier (Set Candidates) deriving(Show, Eq, Ord)
-- data Orthography = Neg Candidate | Pos Candidate deriving(Show, Eq, Ord)
-- data Phoneme = Dollar Int | Slash String deriving(Show, Eq, Ord)
-- data Candidate = Res Resolved | Ide Identifier deriving(Show, Eq, Ord)
-- data Resolved = Boundary | Quo Quote deriving(Show, Eq, Ord)
-- newtype Identifier = Id String deriving(Show, Eq, Ord)
-- newtype Quote = Quote String deriving(Show, Eq, Ord)

expand :: Set Sentence -> Either SemanticError (Set Conv2)
expand sents = do 
 (orthoset, identmap) <- split sents
 newMap <- candids_to_quotes identmap
 return $ do{
      (phonemes, ortho_arr) <- S.toList orthoset;
      orthos' <- f newMap ortho_arr;
      return $ Conv orthos' phonemes
      }


-- identmap: v --> [R ["a"], R ["o", "e"] ]
-- ortho_arr : [Pos "i", Pos v, Neg "r"]
-- result : [ [Pos' ["i"], Pos' ["a"], Neg' ["r"]], [Pos' ["i"], Pos' ["o", "e"], Neg' ["r"]] ]
f :: M.Map Identifier (Set Resolveds) -> Array Orthography -> Set (Array Orthography')
f identmap ortho_arr = sequence $ map g ortho_arr where
  g (Neg c) = map (Neg' . unR) $ h c
  g (Pos c) = map (Pos' . unR) $ h c
  h (Res reso) = [ R[reso] ]
  h (Ide ident) = fromJust $ M.lookup ident identmap
-- g: 
-- Pos "i" -> [ Pos' ["i"] ]
-- Neg v -> [ Neg' ["a"] , Neg' ["o", "e"] ]
--
-- map g ortho_arr:
-- [
--     [ Pos' ["i"] ],
--     [ Pos' ["a"] , Pos' ["o", "e"] ],
--     [ Neg' ["r"] ]
-- ]
-- 


split :: Set Sentence -> Either SemanticError (S.Set(Array Phoneme, Array Orthography),M.Map Identifier (Set Candidates))
split [] = Right (S.empty, M.empty)
split (Conversion orthos phonemes : xs) = do 
  (s,m) <- split xs 
  return (S.insert (phonemes, orthos) s , m) -- duplicate is detected later
split (Define ident@(Id i) cands : xs) = do 
  (s,m) <- split xs 
  if ident `M.member` m 
   then Left $ E{errNum = 0, errStr = "duplicate definition of identifier {"++ i ++ "}"} 
   else Right (s, M.insert ident cands m)

