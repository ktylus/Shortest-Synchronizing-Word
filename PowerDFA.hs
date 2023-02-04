module PowerDFA (createPowerDFA, PowerDFA) where

import ParseInput(DFA)

type PowerDFA = ([String], [Char], String -> Char -> String, String, String -> Bool)

createPowerDFA :: DFA -> PowerDFA
createPowerDFA (q, sigma, delta, q0, f) = (powerQ, sigma, powerDelta, [q0], powerF) 
    where
    powerQ = createPowerDFAStates q
    -- in summary, this transitions to a state, which consists of unique (we ignore the duplicates)
    -- states being the result of transitions from the original delta of all the states in the subset, and the same inputChar
    -- the result is sorted, because then we don't have to worry about the same states being different strings
    powerDelta state inputChar = quicksort (foldr (\x acc -> if delta x inputChar `elem` acc then acc else delta x inputChar : acc) "" state)
    -- it doesn't matter for our task, but in the power DFA a state is accepting if it contains an accepting state
    -- from the original DFA
    powerF = any f
    
-- function returning all the subsets of the DFA state set (except the empty set)
-- for example when input is ['A', 'B', 'C'], then the result is:
-- ["ABC", "AB", "AC", "A", "BC", "B", "C"]
createPowerDFAStates :: [Char] -> [String]
-- init is there to eliminate the empty set
createPowerDFAStates states = init (helperCreatePowerDFAStates states)
    where
    helperCreatePowerDFAStates :: [Char] -> [String]
    helperCreatePowerDFAStates [x] = [[x], ""]
    helperCreatePowerDFAStates (x:xs) = map ([x] ++) (helperCreatePowerDFAStates xs) ++ helperCreatePowerDFAStates xs

quicksort :: Ord a => [a] -> [a]
quicksort [] = []
quicksort (x:xs) = quicksort [y | y <- xs, y <= x] ++ [x] ++ quicksort [y | y <- xs, y > x]
