The program finds the shortest synchronizing word for a DFA given in the file.
The information about the input format is in the "input_format.txt" file.

The algorithm I used is as follows:

First, for a given DFA, we construct its' power automaton, which
has as states all possible subsets of states set (with the exception of the empty set)
and has the transition function powerDelta, such that the state subset A (effectively a state in power DFA)
given char c, transitions to a largest subset B which satisfies the condition, that for each state b in B
there is a state a in A, where (original) delta(a, c) = b

Next, given the power automaton, we try to find the path (with BFS) from the state representing the original automaton's
state set to any singleton state.
We also continously update the path (the word the automaton needs to read to go from the full state to current state),
while trying to find the singleton state, so when the task is done, the path is the shortest synchronizing word.
It is easy to see that this solves the given problem, because if the original automaton reads the word that is the result
of the algorithm, then all of the states transition to the same state that is represented by the singleton state.
If any state in the states set would transition to the other state, then the end state in the power automaton would consist
of more than 1 state.

If the automaton is not synchronizing, then the path will not be found. Eventually, all the states in the power DFA
will be visited by BFS, and the algorithm will return a message (instead of the shortest synchronizing word)
informing that the automaton is not synchronizing.

The time and memory complexity of the algorithm is exponential,
in particular, memory complexity is O(2^n), where n is the number of states,
because we construct power DFA states as all possible subsets of DFA state set.
In practice, not all the states are being held in memory, because of haskell's laziness.


I divided the project into 3 files:

- ParseInput.hs
  which contains all the functionality that constructs the DFA given in the file.

- PowerDFA.hs
  which construct the power DFA, based on the DFA that was previously read.

- SynchronizingWords.hs
  which is the main file (containing the main function), and it contains the implementation
  of the algorithm, and also a small section, where the data is read from file.
