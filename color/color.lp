% Base Encoding for the ASP Exercise: Graph Coloring
%
% INPUT PREDICATES:
%
% 1. edge(X,Y)     -- There is an edge between nodes X and Y in the graph
%
% OUTPUT PREDICATES:
%
% 1. hascolor(X,C) -- Node X is colored with color C
%
% The bogus atoms/constants "todo" mark parts of the encoding for you
% to complete on the basis of descriptions given as well as general
% understanding of the problem.
%
% A number of graph instances is included for testing purposes.

% Parameters: the number of colors (by default)

#const n=3.

% Define the range of colors from 1 to n

color(1..n).

% Translate directed arcs with weights (used in test instances) into edges

edge(X,Y) :- arc(X,Y,_).

% Extract the nodes of the graph from the edge/2 relation

node(X) :- edge(X,_).
node(Y) :- edge(_,Y).

% Choose a color C for each node X. By default the color can be C as
% long as there are no exceptions, i.e., X is colored by some other color
% than C. Use some auxiliary predicate to encode any such exceptions.

hascolor(X,C) :- node(X), color(C), not othercolor(X,C).
hascolor(X,C) :- node(X), color(C), color(D), D != C, not hascolor(X, D)
% Add rules as needed (todo)
othercolor(X,C) :- color(C), color(D), D != C, hascolor(X,D).

% Check the coloring condition for every edge of the graph:
% X and Y should have different colors.

:- edge(X,Y), hascolor(X,C), hascolor(Y,C).

% Extract solution (the following predicates are used in the evaluation)

#show hascolor/2.
#show edge/2.

