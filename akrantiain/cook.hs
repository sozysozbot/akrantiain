{-# OPTIONS -Wall -fno-warn-unused-do-bind #-}

module Akrantiain.Cook
(cookBy
,Input
,Output
,Fixme3(..)
,RuntimeError(..)
) where
import Akrantiain.Expand
data RuntimeError = RE {errNo :: Int, errMsg :: String} deriving(Eq, Ord)
instance Show RuntimeError where
 show RE{errNo = n, errMsg = str} = "Runtime error (error code #" ++ show n ++ ")\n" ++ str 

data Fixme3 = Fixme3 
type Input = String
type Output = Either RuntimeError String
cookBy :: Fixme3 -> Either SemanticError( Input -> Output )
cookBy foobar = undefined
-- cookBy foobar = Right func -- ***FIXME***
 -- where 
  -- func x
   -- | x == "wa" = Right "わ"
   -- | x == "wu" = Left $ RE{errNo = 1030, errMsg = "wu is not good"}
   -- | otherwise = Right x
