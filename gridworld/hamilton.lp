% COMP.CS.420 Hamiltonian path in the cleaning robot's world

% Coordinate values

xcoord(X1..X2) :- xrange(X1,X2).
ycoord(Y1..Y2) :- yrange(Y1,Y2).

% Allowed positions of the robot (fixed obstacles assumed)

pos(X,Y) :- xcoord(X), ycoord(Y), not blocked(X,Y).

% Choose a unique start cell

start(X,Y) :- pos(X,Y), X2>=X: pos(X2,Y2); Y2>=Y: pos(X,Y2).

% TODO: Choose a policy for the robot
%
% - expressed with predicates n(X,Y), s(X,Y), e(X,Y), w(X,Y)
%   where X,Y is any (allowed) position for the robot

1 { n(X,Y); s(X,Y); e(X,Y); w(X,Y) } 1 :- pos(X,Y).

% TODO: Verify that the chosen policy forms a Hamiltonian path
% in the grid world
%
% - express reachability using the predicate reach/2,
% - you may utilize the start cell selected above,
% - ensure that all cells can be reached by following the path.

reach(X,Y) :- start(X,Y).

% Propagate reachability through valid moves
reach(X, Y+1) :- reach(X, Y), n(X, Y), pos(X, Y+1).
reach(X, Y-1) :- reach(X, Y), s(X, Y), pos(X, Y-1).
reach(X+1, Y) :- reach(X, Y), e(X, Y), pos(X+1, Y).
reach(X-1, Y) :- reach(X, Y), w(X, Y), pos(X-1, Y).
% Ensure every position is reachable
:- pos(X, Y), not reach(X, Y).

% Define moves that return to the starting cell
returns_to_start(X, Y) :- n(X, Y-1).
returns_to_start(X, Y) :- s(X, Y+1).
returns_to_start(X, Y) :- e(X-1, Y).
returns_to_start(X, Y) :- w(X+1, Y).

% Ensure a move returns to the start
:- start(X, Y), not returns_to_start(X, Y).

% Extract solution (as will be done in the evaluation)

#show n/2.
#show s/2.
#show e/2.
#show w/2.
#show start/2.
#show reach/2.
