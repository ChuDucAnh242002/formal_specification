% COMP.CS.420
% Base Encoding for the ASP Exercise: Sorting Network Verification
%
% Some parts of the encoding have been deleted and indicated by bogus
% atoms/constants "todo". You are supposed to fill in the missing details
% on the basis of descriptions given as well as general understanding of
% the problem.

% Extract the domains for levels and wire indices (leave as is)

level(D) :- original_comparator(_, _, D).
wire(I) :- original_comparator(I, _, _).
wire(J) :- original_comparator(_, J, _).

% Define predicate input/1 for all wires with the following intuition:
% - input(I) is true iff the input for I is 1 (for any wire I)

{ input(I) } :- wire(I).

% Pick K comparators for removal using a choice rule:
%
% Do this by defining removed_comparator/3 for K original comparators
% (I, J, D).  Even without this definition, your encoding should work
% on instances with no removals

{ removed_comparator(I,J,D) : original_comparator(I,J,D) } = K :- removals(K).

% Identify remaining comparators

comparator(I, J, D) :- original_comparator(I, J, D),
                       not removed_comparator(I, J, D).

% Define initial wire values (below 0 gives the level)

value(I, 0) :- input(I).

% Define comparator outputs based on preceding values
% - value(I, D) is true iff the value of wire I at depth D is 1

value(I, D) :- comparator(I, J, D), value(I, D-1), value(J, D-1).
value(J, D) :- comparator(I, J, D), value(J, D-1), not value(I, D-1).
value(J, D) :- comparator(I, J, D), value(J, D-1), value(I, D-1).

% Identify passthrough wire (which simply copy their value)

used_wire(I, D) :- comparator(I, _, D).
used_wire(J, D) :- comparator(_, J, D).
passthrough(I, D) :- not used_wire(I, D), wire(I), level(D). % If not just go through

% Define passthrough outputs based on preceding values

value(I, D) :- passthrough(I, D), value(I, D-1).

% Extract final outputs

depth(D) :- level(D), not level(D + 1).
output(I) :- value(I, D), depth(D).

% Require there to be a pair of consecutive outputs in the wrong order

wrong :- wire(I), wire(J), output(I), not output(J), I < J.
:- not wrong.

% Extract solution (the following predicates are used in the evaluation)

% #show comparator/3.
% #show removed_comparator/3.
#show value/2.
% #show depth/1.
#show output/1.
