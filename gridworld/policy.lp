% COMP.CS.420 Policy for finding the closest dirty cell

% Coordinate values

xcoord(X1..X2) :- xrange(X1,X2).
ycoord(Y1..Y2) :- yrange(Y1,Y2).

% Allowed positions of the robot (fixed obstacles assumed)

pos(X,Y) :- xcoord(X), ycoord(Y), not blocked(X,Y).

% TODO: Place dirt in exactly d (different) cells

#const d=5.
{ dirty(X,Y) : pos(X,Y) } = d.

% TODO: Calculate the minimum distance to a dirty cell based on
% the distances for the neighboring cells
%
% - Dirty cells form a base case
% - Non-dirty cells can be covered by an inductive definition
%
% NOTE: When defining dist(X,Y,D) in the latter case, you should set
% an upper bound on D to avoid infinite loops. A working upper bound
% can be obtained from the dimensions of the grid, please use
% |X2-X1| + |Y2-Y1| as an upper bound for D given xrange(X1,X2)
% and yrange(Y1,Y2).

% Define the upper bound for distance
upper_bound(D) :- xrange(X1, X2), yrange(Y1, Y2), D = |X2 - X1| + |Y2 - Y1|.

% Base case: Distance to a dirty cell is 0
dist_dirty(X, Y, 0) :- dirty(X, Y).

% Inductive case: Distance to a clean cell is 1 + minimum distance of its neighbors
dist_dirty(X, Y, D+1) :- pos(X, Y), not dirty(X, Y), dist_dirty(X-1, Y, D), upper_bound(B), D+1 <= B.
dist_dirty(X, Y, D+1) :- pos(X, Y), not dirty(X, Y), dist_dirty(X+1, Y, D), upper_bound(B), D+1 <= B.
dist_dirty(X, Y, D+1) :- pos(X, Y), not dirty(X, Y), dist_dirty(X, Y-1, D), upper_bound(B), D+1 <= B.
dist_dirty(X, Y, D+1) :- pos(X, Y), not dirty(X, Y), dist_dirty(X, Y+1, D), upper_bound(B), D+1 <= B.
    
% Calculate the minimum distance to a dirty cell
dist(X, Y, D) :- 
    pos(X, Y),  % Valid position in the grid
    D = #min { D1 : dist_dirty(X, Y, D1), pos(X, Y) }.  % Minimum of all distances

% TODO: Choose optimal policy (i.e., a move for each position) based
% on distances. It is possible that several moves are equally good in
% a given position (but might lead to different dirty cells). Please
% see the illustration given in the course material to get an
% intuition of this.

n(X,Y) :- dist(X, Y, D), dist(X, Y+1, D-1), D >=1.
s(X,Y) :- dist(X, Y, D), dist(X, Y-1, D-1), D >=1.
e(X,Y) :- dist(X, Y, D), dist(X+1, Y, D-1), D >=1.
w(X,Y) :- dist(X, Y, D), dist(X-1, Y, D-1), D >=1.

% Filter

#show dirty/2.
#show dist/3.
#show n/2.
#show s/2.
#show e/2.
#show w/2.

