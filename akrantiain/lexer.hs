--{-# OPTIONS -Wall -fno-warn-unused-do-bind #-}

module Akrantiain.Lexer
(parseTest
,dollar_int
,quoted_string
,slash_string
,conversion
,define
,sentences
) where

import Text.Parsec 

import Control.Applicative ((<$>),(*>),(<*),pure)
import Data.Char (ord, isSpace)
import Text.Parsec (char, oneOf, (<|>), parseTest)
import Text.Parsec.String (Parser)
import Data.Maybe (catMaybes)
import Control.Monad(void)
-- import Prelude hiding (undefined)

sample :: String
sample = "\"a\" -> /A/;\"b\" -> /B/\n\"c\" -> /C/;\n\"o\" -> /O/\n\"oo\" -> /8/"

type Candidates = [Candidate]
data Sentence = Conversion [Orthography] [Phoneme] | Define Identifier [Candidates] deriving(Show, Eq, Ord)
data Orthography = Boundary | Neg Candidate | Pos Candidate deriving(Show, Eq, Ord)
data Phoneme = Dollar Int | Slash String deriving(Show, Eq, Ord)
type Candidate = Either Quote Identifier
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

spaces' :: Parser ()
spaces' = skipMany $ satisfy (\a -> isSpace a && a /= '\n')



sentences :: Parser [Sentence]
sentences = do
 sents <- many (try(comment >> return Nothing) <|> try(fmap Just sentence))
 eof
 return $ catMaybes sents

comment :: Parser ()
comment = void(try $ spaces' >> oneOf ";\n") <|> (char '#' >> skipMany (noneOf "\n") >> (eof <|> void(char '\n')))

-- consonant = "a" | "b" "d" | cons2 | co "c" co 
define :: Parser Sentence
define = do
  ident <- try $ do
   spaces'
   ident' <- identifier
   spaces'
   char '='
   return ident'
  spaces'
  let candidates = try $ many(try $ try candidate <* spaces')
  cands_arr <- try candidates `sepBy` try(char '|' >> spaces') 
  sent_terminate
  return $ Define ident cands_arr

sent_terminate :: Parser ()
sent_terminate = eof <|> comment
  

candidate :: Parser Candidate
candidate = try(fmap Left quoted_string) <|> try(fmap Right identifier)
  

conversion :: Parser Sentence
conversion = do 
  orthos <- try $ do
   spaces'
   let ortho = boundary <|> fmap Pos candidate <|> try(fmap Neg $ char '!' >> candidate)
   orthos' <- many(try$ortho <* spaces')
   string "->"
   return orthos'
  spaces'
  let phoneme = dollar_int <|> slash_string
  phonemes <- many(try$phoneme <* spaces')
  sent_terminate
  return $ Conversion orthos phonemes


sentence :: Parser Sentence
sentence = conversion <|> define 






boundary :: Parser Orthography
boundary = do
  char '^'
  return Boundary

-- FIXME: Escape sequence not yet implemented
slash_string :: Parser Phoneme
slash_string = try $ do
  char '/'
  str <- many(noneOf "/\n")
  char '/'
  return $ Slash str

-- FIXME: Escape sequence not yet implemented
quoted_string :: Parser Quote
quoted_string = do
  char '"'
  str <- many(noneOf "\"\n")
  char '"'
  return $ Quote str

dollar_int :: Parser Phoneme
dollar_int = try $ do
  char '$'
  num <- many digit
  return $ Dollar(read num)

parser :: Parser [Sentence]
parser = do 
  result <- many sentence
  eof
  return result
  
identifier :: Parser Identifier
identifier = fmap Id $ (:) <$> letter <*> many (alphaNum <|> char '_')

