% Base Encoding for the Programming Exercise: Evacuation Planning
%
% INPUT PREDICATES:
%
% 1. partof(R,X,Y) -- Square at coordinates (X,Y) is part of room R
%
% OUTPUT PREDICATES:
%
% 1. exit(R)       -- Room R has an exit
% 2. evac(R1,R2)   -- According to the evacuation plan R1 is evacuated via R2
%
% The bogus atoms "todo" mark parts of the encoding for you to complete.

% Parameters

#const ne=2. % Number of exits

% Basic domains for the encoding (fixed)

room(R) :- partof(R,_,_).
square(X,Y) :- partof(_,X,Y).
xdim(M) :- M = #max{ X: square(X,Y) }.
ydim(M) :- M = #max{ Y: square(X,Y) }.

% Choose which rooms have exits (there must be exactly ne exits)
{ exit(R): room(R) } = ne.  % This is a choice with cardinality

% Exits must be located next to outer walls
boundary_touch(R) :- partof(R, X, Y), xdim(MX), ydim(MY), X=1, Y = 1..MY.
boundary_touch(R) :- partof(R, X, Y), xdim(MX), ydim(MY), X=MX, Y = 1..MY.
boundary_touch(R) :- partof(R, X, Y), xdim(MX), ydim(MY), X=1..MX, Y = MY.
boundary_touch(R) :- partof(R, X, Y), xdim(MX), ydim(MY), Y=MY, X = 1..MX.

:- exit(R), room(R), not boundary_touch(R).

% Determine which rooms are adjacent to each other; you need
% not worry about doors nor their locations. You may assume that
% a door can be placed between adjacent rooms whenever needed.
adj(R1, R2) :- partof(R1,X1,Y1), partof(R2,X2,Y2), R1 != R2, X1 = X2, Y1 - Y2 = 1.
adj(R1, R2) :- partof(R1,X1,Y1), partof(R2,X2,Y2), R1 != R2, Y1 = Y2, X1 - X2 = 1.

% Evacuation between adjacent rooms is potential in either direction
% - either from R1 to R2,
% - or from R2 to R1.
pot(R1,R2) :- adj(R1,R2). % Add rules as needed
pot(R1,R2) :- adj(R2,R1). % Add rules as needed

% Choose an evacuation plan for rooms having no exit: by default
% R1 can be evacuated to R2 unless R1 is evacuated elsewhere
evac(R1,R2) :- room(R1), not exit(R1), room(R2), R1 != R2, pot(R1,R2), not evac_else(R1,R2).
evac_else(R1,R2) :- room(R1), room(R2), room(R3), R1 != R3, R2 != R3, R1 != R2, pot(R1,R3), evac(R1,R3). % Complete the condition

% For safety reasons, we must deny loops in the evacuation plan

reach(R1,R2) :- evac(R1,R2). % Base case
reach(R1,R2) :- reach(R1,R3), evac(R3,R2).        % Recursive case ("induction step")

:- reach(R,R). % Deny loops

% An exit must be reachable from every room following the evacuation plan
rex(R) :- reach(R,Exit), exit(Exit).                % If some exit can be reached from R
:- room(R), not exit(R), not rex(R). % The required constraint

% Extract solution

% #show partof/3.
% #show exit/1.
% #show evac/2.
% #show evac_else/2.