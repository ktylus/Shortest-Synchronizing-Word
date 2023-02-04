# Shortest Synchronizing Word

The program takes a DFA as an input and returns the shortest synchronizing word
for this automaton, or informs that it cannot be synchronized.

It is written in Haskell as a project for the Functional Programming course
at Jagiellonian University.

The algorithm used is based on constructing a power automaton, and finding a path
from the state representing a whole set of states to any singleton.

Information about the problem can be found here:
https://en.wikipedia.org/wiki/Synchronizing_word