{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ImpredicativeTypes #-}
{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE UndecidableInstances #-}

import Prelude ()
import Prelude hiding ((*), (+), head)
import Debug.Trace

-- Cartesian product
(*) xs ys = [(x,y) | x <- xs, y <- ys]

-- Backwards application operator
(\\) :: a -> (a -> b) -> b 
(\\) a b = b a

-- Phrase (can be joined together)
class Phr a where 
  (+) :: a -> a -> a
  with :: (Nom x1) => a -> x1 -> a

-- Nominal (can be an agent or patient)
class (Show a, Phr a) => Nom a where 
  append :: a -> [Relation] -> a
  head :: a -> [Relation]

instance (Nom x0) => Phr (x0 -> S) where
  (+) f0 f1 = 
    (\n -> let (S l0) = f0 n
               (S l1) = f1 n in S (l0 ++ l1))
  with phr np = (\x0 -> let (S l1) = phr x0 in
                        S [With ([a, b]) | (a, b) <- (l1 * (head np))])

--instance (Nom x0) => Phr x0 where
--  (+) x0 x1 = append x0 (head x1)

-- Noun Phrase (cannot be modified further)
data NP = NP [Relation] deriving (Show)
instance Nom NP where
  append (NP a) arr = NP (a ++ arr) 
  head (NP a) = a
instance Phr NP where
  (+) x0 x1 = append x0 (head x1)
  with x0 x1 =  NP [With [Rel (head x0), Rel (head x1)]]


-- Noun (can be modified with adjectives)
data N = N [Relation] deriving (Show)
instance Nom N where
  append (N a) arr = N (a ++ arr) 
  head (N a) = a
instance Phr N where
  (+) x0 x1 = append x0 (head x1)
  with x0 x1 =  N [With [Rel (head x0), Rel (head x1)]]

type VB = (Nom x0, Phr x1) => x0 -> x1 -> S
type DT = N -> NP

-- relation, target, arguments
-- type Relation = (String, [String])
data Relation = Rel [Relation] 
              | With [Relation]
              | Object String
              | Patient Relation
              | Agent Relation
              | Event String
              | Prp S deriving (Show)


-- Sentence with Relations
data S = S [Relation] deriving (Show)

instance Phr S where
  (+) (S l0) (S l1) = S (l0 ++ l1)
  with (S l1) x1 = S [With ([a, b]) | (a, b) <- (l1 * (head x1))]
instance Nom S where
  head (S a) =  [Prp (S a)]
  -- append (S a) arr = trace (show a) (S a)

-- Word Types
-- make verb
verb :: (Nom x0, Nom x1) => String -> x0 -> x1 -> S
verb word x0 x1 = S [Rel ([Event word, Agent a, Patient b])
                    | (a, b) <- (agents * patients)]
  where
    agents = head x0
    patients = head x1

-- make noun
noun :: String -> N
noun word = N [Object word]

-- make determinant
det :: N -> NP
det (N a) = (NP a)

-- make conjunctive
conj :: Phr a => a -> a -> a
conj x0 x1 = x0 + x1

-- make adjective
adj :: String -> N -> N
adj word (N x) = N (map (\r -> Rel [r, Object ("("++word++")")] ) x)

-- Tagged words

-- John like      to         eat pizza with apples
--  N                               N         N
--          (S\NP)/(S\NP/NP)
--            S

--_to :: (Nom x0, Phr x1) => (x0 -> x1) -> x0  
--_to f0 = (\n -> 
--  let p0 = f0 n in 
--    )

_to :: (Phr x0, Nom x1) => x0 -> x1 -> x0
_to p0 x1 = p0 `with` x1

_with :: (Phr x0, Nom x1) => x0 -> x1 -> x0
_with p0 x1 = p0 `with` x1

_and = conj
_but = conj
_the = det
_a = det
_red = adj "red"

_I = det $ noun "I"
_John = det $ noun "John"
_Mary = det $ noun "Mary"
_Steve = det $ noun "Steve"
_Yahoo = det $ noun "Yahoo"
_Microsoft = det $ noun "Microsoft"
_Apple = det $ noun "Apple"
_IBM = det $ noun "IBM"

_apple = noun "apple"
_apples = noun "apples"
_water = noun "water"
_cash = noun "cash"
_pizza = noun "pizza"
_fork = noun "fork"

_drink = verb "drink"
_went = verb "went"
_eat = verb "eat"
_ate = verb "ate"
_like = verb "like"
_hate = verb "hate"
_hates = verb "hates"
_bought = verb "bought"
_sold = verb "sold"
_strapped = verb "strapped"
_said = verb "said"

t0 = ((_John `_eat`) `_and` (_Mary `_eat`)) (_red _apple)
t1 = ((_John `_eat`) `_and` (_Mary `_drink`)) ((_red _apple) `_and` _water)
t2 = ((_I `_like`) `_and` (_Mary `_hates`)) _apples
t3 = (_Yahoo `_bought` _IBM) `_but` (_Microsoft `_sold` _Apple)
t4 = _John `_said` (_Mary `_bought` _apples)
t5 = _John `_said` (_Steve `_said` (_Mary `_bought` _apples))
t6 = _John `_ate` (_pizza `_with` _apples)
t7 =_John \\ ((`_ate` _pizza) `_with` ((_a _fork) `_and` (_a _water)))
t8 = (_John `_ate` _pizza) `_with` (_Mary `_and` _Steve)

--data Nominal = forall a. Nom a => Nom a | NP String
--instance Show NP where 
--  show (NP a) = show a
--  show (Nom a) = show a


