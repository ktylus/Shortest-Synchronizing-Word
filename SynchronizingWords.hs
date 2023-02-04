module Main where

import System.IO ()
import ParseInput (readDFA)
import PowerDFA (createPowerDFA, PowerDFA)

main :: IO ()
main = do
    -- reading everything, but the transitions line by line
    states <- getLine
    alphabet <- getLine 
    startState <- getLine 
    endStates <- getLine
    -- the transitions are read as a whole, and parsed separately
    transitions <- getContents
    let dfa = readDFA states alphabet transitions startState endStates
    let powerdfa = createPowerDFA dfa
    print (findShortestSynchronizingWord powerdfa)

-- the algorithm implementation
findShortestSynchronizingWord :: PowerDFA -> String
findShortestSynchronizingWord dfa = helperFindSSW dfa [s] [(s, "")]
    where 
    s = getFullState dfa
    -- the second argument is the visited nodes (states) list used in BFS
    -- the third argument is the queue, also used in BFS, containing pairs
    -- where the first element is the state and the second is the word needed to be read in order to get to this state
    -- from the full state
    helperFindSSW :: PowerDFA -> [String] -> [(String, String)] -> String
    helperFindSSW (q, sigma, delta, q0, f) visited queue
        -- this means the BFS has ended without finding the path
        | null queue = "automaton is not synchronizing"
        -- this condition represents finding the singleton state
        | length (fst (head queue)) == 1 = snd (head queue)
        | otherwise = do
            let state = fst (head queue)
            let path = snd (head queue)
            -- these are states possible to transition into by reading a character from the alphabet, that haven't been
            -- visited yet. these are representing in (state, word) pairs mentioned earlier
            let validNeighbors = filter (\(st, p) -> st `notElem` visited) [(delta state c, path ++ [c]) | c <- sigma]
            helperFindSSW dfa (map fst validNeighbors ++ visited) (tail queue ++ validNeighbors)

-- full state is the power automaton state representing the whole states set of the original DFA
-- my implementation is such that this state is always the first element of the states list, thus "head states"
getFullState :: PowerDFA -> String
getFullState (states, _, _, _, _) = head states
