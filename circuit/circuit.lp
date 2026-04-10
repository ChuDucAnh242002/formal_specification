% Base Encoding for the ASP Exercise: Circuit Verification
%
% Some parts of the encoding have been deleted and indicated by
% bogus atoms/constants "todo". You are supposed to fill in the missing
% details on the basis of descriptions given as well as general
% understanding of the problem.
%
% A number of circuit instances are included for testing purposes

% Infer gates from the given structure of the circuit (see instance files)

gate(G) :- inv(I,G).
gate(G) :- buf(I,G).
gate(G) :- and(I1,I2,G).
gate(G) :- or(I1,I2,G).

% Circut A: use the given sturucture as is

circ(a).
circ_inv(a,I,G) :- inv(I,G).
circ_buf(a,I,G) :- buf(I,G).
circ_and(a,I1,I2,G) :- and(I1,I2,G).
circ_or(a,I1,I2,G) :- or(I1,I2,G).

% Circut B: use the given structure by default

circ(b).
circ_inv(b,I,G) :- inv(I,G), circ_inv(a,I,G), not err(G).
% TODO: Add similar rules for other gate types
circ_buf(b,I,G) :- buf(I,G), circ_buf(a,I,G), not err(G).
circ_and(b,I1,I2,G) :- and(I1,I2,G), circ_and(a,I1,I2,G), not err(G).
circ_or(b,I1,I2,G) :- or(I1,I2,G), circ_or(a,I1,I2,G), not err(G).

% Circuit B: the type of the gate G is changed if G is erroneous,
%            i.e., err(G) holds

circ_buf(b,I,G) :- inv(I,G), circ_inv(a,I,G), err(G) .
circ_inv(b,I,G) :- buf(I,G), circ_buf(a,I,G), err(G) .
% TODO: Add similar rules for "and" (replaced by "or") and
%                         for "or" (replaced by "and")
circ_and(b,I1,I2,G) :- or(I1,I2,G), circ_or(a,I1,I2,G), err(G).
circ_or(b,I1,I2,G) :- and(I1,I2,G), circ_and(a,I1,I2,G), err(G).

% Choose values for (joint) inputs (keep as is)

{ one(I) } :- in(I).
one(C,I) :- one(I), circ(C), in(I).

% Evaluate the remaining gates using predicate one/2:
%
% - If one(C,G) is true, then the value of gate G in circuit C is "1"
% - Otherwise (i.e., by default) the value of gate G in circuit is "0"

one(C,G) :- circ_inv(C,I,G), not one(C,I).
one(C,G) :- circ_buf(C,I,G), one(C,I).
% TODO: Add similar rules for "and" and "or"
one(C,G) :- circ_and(C,I1,I2,G), one(C,I1), one(C,I2).
one(C,G) :- circ_or(C,I1,I2,G), one(C,I1), one(C,I2).
one(C,G) :- circ_or(C,I1,I2,G), one(C,I1), not one(C,I2).
one(C,G) :- circ_or(C,I1,I2,G), not one(C,I1), one(C,I2).

% Detect if the outputs gate of circuits 1 and 2 has a different value
% (this is the intuitive reading of atom "diff")

diff :- out(G), one(a,G), not one(b,G).
diff :- out(G), not one(a,G), one(b,G).
% Add rules if needed

% Insist on a difference

:- not diff .

% Filter the counter-example

#show circ_and/4.
#show one/1.
#show one/2.
#show err/1.
#show diff/0.