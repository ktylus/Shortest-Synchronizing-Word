module ParseInput (readDFA, DFA) where

-- DFA is: (set of states, alphabet (sigma), transition function (delta), start state, end states in form of a function)
type DFA = ([Char], [Char], Char -> Char -> Char, Char, Char -> Bool)
-- Transition is: (current state, char that is read, state being the result of the transition)
type Transition = (Char, Char, Char)

-- defines the DFA used to construct the power DFA
readDFA :: String -> String -> String -> String -> String -> DFA
readDFA states alphabet transitions startState endStates = (q, sigma, delta, q0, f)
    where
    q = getChars states
    sigma = getChars alphabet
    -- transitions are of type (Char, Char, Char), here we return the third value, which is the state after transition
    -- we filter the transition, that matches the current state and read char (there is only one such transition)
    delta state inputChar = third (head (filter (\(s1, c, s2) -> s1 == state && c == inputChar) parsedTransitions))
    q0 = head startState
    f state = state `elem` parsedEndStates
    parsedTransitions = parseTransitions transitions
    parsedEndStates = getChars endStates

-- input string is always "<char> <char> <char>\n" repeated
parseTransitions :: String -> [Transition]
parseTransitions input = map (\x -> (head x, x !! 2, last x)) (lines input)

-- needed to extract the set of states from the line in the file
getChars :: String -> [Char]
getChars str = map head (words str)

third :: Transition -> Char
third (_, _, c) = c