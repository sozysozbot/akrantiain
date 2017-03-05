{-# OPTIONS -Wall -fno-warn-unused-do-bind #-}

module Akrantiain.Cook
(cookBy
,Input
,Output
,cookBy
,Fixme3(..)
) where
import Akrantiain.Expand
import Akrantiain.Structure

data Fixme3 = Fixme3 
type Input = String
type Output = String
cookBy :: Fixme3 -> Either SemanticError( Input -> Output )
cookBy foobar = Right id -- ***FIXME***
