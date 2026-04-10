% Finding satisfying k-step executions for LTL-formulas using Clingo
%
% (c) Tomi Janhunen, 2019-2021.
%
% You may use this code for the course "Introduction to Formal Specification"
% at Tampere University in Autumn 2021.
%
% Publication and redistribution prohibited.

% YOUR TASK: revise the rules containing bogus atom "todo".
% Please do not modify the encoding otherwise.

% Extract formulas

formula(F) :- satisfy(F).

% Subformulas of any formula represented with function symbols

subf(F) :- formula(F).
subf(F) :- subf(neg(F)).   % Negation
subf(F) :- subf(fut(F)).   % Future
subf(F) :- subf(glb(F)).   % Globally
subf(F) :- subf(nxt(F)).   % Next
subf(F) :- subf(unt(F,_)). % Until
subf(F) :- subf(unt(_,F)). % Until
subf(F) :- subf(and(F,_)). % And
subf(F) :- subf(and(_,F)).
subf(F) :- subf(or(F,_)).  % Or
subf(F) :- subf(or(_,F)).
subf(F) :- subf(imp(F,_)). % Implication
subf(F) :- subf(imp(_,F)).
subf(F) :- subf(eqv(F,_)). % Equivalence
subf(F) :- subf(eqv(_,F)).
subf(F) :- subf(xor(F,_)). % Exclusive or
subf(F) :- subf(xor(_,F)).

% Compound formulas and atoms (in a formula)

compound(neg(F)) :- subf(neg(F)).
compound(fut(F)) :- subf(fut(F)).
compound(glb(F)) :- subf(glb(F)).
compound(nxt(F)) :- subf(nxt(F)).
compound(unt(F1,F2)) :- subf(unt(F1,F2)).
compound(and(F1,F2)) :- subf(and(F1,F2)).
compound(or(F1,F2)) :- subf(or(F1,F2)).
compound(imp(F1,F2)) :- subf(imp(F1,F2)).
compound(eqv(F1,F2)) :- subf(eqv(F1,F2)).
compound(xor(F1,F2)) :- subf(xor(F1,F2)).
atom(A) :- subf(A), not compound(A), A!=true, A!=false.

% Only restricted models are considered (=> unsound wrt standard LTL)
% Steps: 1 -> 2 -> ... -> k -> k (i.e. k is accessible form itself)

step(1..K) :- final(K).

% Choose a truth assignment for formulas to satisfy

{ t(A,S) } :- atom(A), step(S).

% Evaluate the truth values of formulas (bottom up) for each step
% It is sufficient to infer when formulas are true (they are false by default)

t(true,S) :- step(S).
:- t(false,S), step(S).
t(neg(F),S) :- not t(F,S), subf(neg(F)), step(S).
t(and(F1,F2),S) :- t(F1,S), t(F2,S), subf(and(F1,F2)), step(S).
t(or(F1,F2),S) :- t(F1,S), subf(or(F1,F2)), step(S).
t(or(F1,F2),S) :- t(F2,S), subf(or(F1,F2)), step(S).
t(imp(F1,F2),S) :- not t(F1,S), subf(imp(F1,F2)), step(S).
t(imp(F1,F2),S) :- t(F2,S), subf(imp(F1,F2)), step(S).
t(eqv(F1,F2),S) :- t(F1,S), t(F2,S), subf(eqv(F1,F2)), step(S).
t(eqv(F1,F2),S) :- not t(F1,S), not t(F2,S), subf(eqv(F1,F2)), step(S).
t(xor(F1,F2),S) :- t(F1,S), not t(F2,S), subf(xor(F1,F2)), step(S).
t(xor(F1,F2),S) :- not t(F1,S), t(F2,S), subf(xor(F1,F2)), step(S).

%------------------------------------------------------------------------------
% Modal operators are not defined above -- this is your task
% References to subsequent steps S and S+1 should be enough

% fut(F): Future F

% t(fut(F),S) :- t(F,S).
% t(fut(F),S) :- t(fut(F),S+1), step(S), step(S+1).
t(fut(F),S) :- t(F,S), subf(fut(F)), step(S).
% Add similar rules (if needed)
t(fut(F),S) :- t(fut(F),S+1), subf(fut(F)), step(S), step(S+1).

% glb(F): Globally F
% t(glb(F),S) :- t(F,S), t(glb(F),S+1), subf(glb(F)), step(S), step(S+1).
% t(glb(F),S) :- t(F,S), final(S).
t(glb(F),S) :- t(F,S), t(glb(F),S+1), subf(glb(F)), step(S), step(S+1).
% Add similar rules (if needed)
t(glb(F),S) :- t(F,S), subf(glb(F)), final(S).

% nxt(F): Next F
t(nxt(F),S) :- t(F,S+1), subf(nxt(F)), step(S), step(S+1).
% Add similar rules (if needed)
t(nxt(F),S) :- t(F,S), subf(nxt(F)), final(S).

% unt(F1,F2): F1 until F2
t(unt(F1,F2),S) :- t(F2,S), subf(unt(F1,F2)), step(S).
t(unt(F1,F2),S) :- t(F1,S), t(unt(F1,F2),S+1), step(S), step(S+1).
% t(unt(F1,F2),S) :- not t(F1,S), t(F2,S), subf(unt(F1,F2)), step(S).
% Add similar rules (if needed)
t(unt(F1,F2),S) :- t(F2,S), subf(unt(F1,F2)), final(S).

% Enforce satisfaction of formulas F for the first time step

:- not t(F,1), satisfy(F).
% :- todo, satisfy(F).

%-----------------------------------------------------------------------------

#show t/2.
#show final/1.
