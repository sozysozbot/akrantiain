{-# OPTIONS -Wall -fno-warn-unused-do-bind #-}

module Akrantiain.Cook
(cookBy
) where
import Akrantiain.Expand
import Akrantiain.Structure

type Input = String
type Output = String
cookBy :: Set Conv2 -> Input -> Either SemanticError Output
cookBy conv_arr = undefined
