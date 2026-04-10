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

:- exit(R), room(R), todo.

% Determine which rooms are adjacent to each other; you need
% not worry about doors nor their locations. You may assume that
% a door can be placed between adjacent rooms whenever needed.

adj(R1,R2) :- todo. % Add rules as needed

% Evacuation between adjacent rooms is potential in either direction
% - either from R1 to R2,
% - or from R2 to R1.

pot(R1,R2) :- todo. % Add rules as needed

% Choose an evacuation plan for rooms having no exit: by default
% R1 can be evacuated to R2 unless R1 is evacuated elsewhere

evac(R1,R2) :- room(R1), not exit(R1), pot(R1,R2), room(R2),
	       not evac_else(R1,R2).

eval_else(R1,R2) :- todo. % Complete the condition

% For safety reasons, we must deny loops in the evacuation plan

reach(R1,R2) :- evac(R1,R2). % Base case
reach(R1,R2) :- todo.        % Recursive case ("induction step")

:- todo. % Deny loops

% An exit must be reachable from every room following the evacuation plan

rex(R) :- todo.                % If some exit can be reached from R
:- room(R), not exit(R), todo. % The required constraint

% Extract solution

#show partof/3.
#show exit/1.
#show evac/2.

