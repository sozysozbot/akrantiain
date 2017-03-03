{-# OPTIONS -Wall -fno-warn-unused-do-bind #-}

module Akrantiain.Resolve_definitions
(SemanticError(..)
,candids_to_quotes
) where

import Akrantiain.Structure
-- import qualified Data.Set as S
import qualified Data.Map as M
data SemanticError = E {errNum :: Int, errStr :: String} deriving(Show, Eq, Ord)


 
{-
candids_to_quotes

input:
vowel = "a" | "i"; conson = "b" | "c"; syll = conson vowel | vowel

output:
vowel = "a" | "i"; conson = "b" | "c"; syll = "b" "a" | "c" "a" | "b" "i" | "c" "i" | "a" | "i"

-}






candids_to_quotes :: M.Map Identifier [Candidates] -> Either SemanticError (M.Map Identifier [Quote])
candids_to_quotes old_map = c_to_q2 (old_map, M.empty)

type Temp = (M.Map Identifier [Candidates], M.Map Identifier [Quote]) 
c_to_q2 :: Temp -> Either SemanticError (M.Map Identifier [Quote])
c_to_q2 (cand_map, quot_map) = case M.lookupGE (Id "") cand_map of 
 Nothing -> return quot_map -- Any identifier is greater than (Id ""); if none, the cand_map must be empty
 Just (ident, candids) -> do
  ident_target <- get_target
  let cand_map' = M.delete ident cand_map
  let quot_map' = M.insert ident ident_target quot_map
  c_to_q2 (cand_map', quot_map')
   where 
    get_target :: Either SemanticError [Quote]
    get_target = undefined ident candids cand_map quot_map


  
