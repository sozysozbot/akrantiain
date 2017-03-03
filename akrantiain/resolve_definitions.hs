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
vowel = "a" | "i"; conson = "b" | ^ "c"; syll = conson vowel | vowel

output:
vowel = "a" | "i"; conson = "b" | ^ "c"; syll = "b" "a" | ^ "c" "a" | "b" "i" | ^ "c" "i" | "a" | "i"


-}

type Stack = [Identifier]
type Temp = (M.Map Identifier [Candidates], M.Map Identifier [Resolveds], Stack) 

-- move identifier from cand_map to quot_map
reduce_1 :: Identifier -> Temp -> Either SemanticError Temp
reduce_1 ident@(Id i) (cand_map, quot_map, stack) = case M.lookup ident cand_map of
 Nothing -> Left $ E{errNum = 1, errStr = "unresolved identifier {" ++ i ++ "}"}
 Just candids_list -> if ident `elem` stack 
  then Left $ E{errNum = 2, errStr = "recursive definition regarding identifier {" ++ i ++ "}"} 
  else do
   let ide_list = [ ide | C candids <- candids_list, Ide ide <- candids]
   case ide_list of 
    [] -> do
     let resos_list = [ R[res | Res res <- candids] | C candids <- candids_list]
     return (M.delete ident cand_map, M.insert ident resos_list quot_map, stack)
    (x:xs) -> undefined


candids_to_quotes = undefined 
{-
candids_to_quotes :: M.Map Identifier [Candidates] -> Either SemanticError (M.Map Identifier [Resolveds])
candids_to_quotes old_map = c_to_q2 (old_map, M.empty)


c_to_q2 :: Temp -> Either SemanticError (M.Map Identifier [Resolveds])
c_to_q2 (cand_map, quot_map) = case M.lookupGE (Id "") cand_map of 
 Nothing -> return quot_map -- Any identifier is greater than (Id ""); if none, the cand_map must be empty
 Just (ident, candids) -> do
  ident_target <- get_target
  let cand_map' = M.delete ident cand_map
  let quot_map' = M.insert ident ident_target quot_map
  c_to_q2 (cand_map', quot_map')
   where 
    get_target :: Either SemanticError [Resolveds]
    get_target = undefined ident candids cand_map quot_map

-}
  
