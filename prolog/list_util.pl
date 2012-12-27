:- module(list_util,
    [ split/3
    , take/3
    ]).
/** <module> Utilities for lists

A collection of predicates for working with lists.

@author Michael Hendricks <michael@ndrix.org>
@license BSD
*/

%%  split(?Combined:list, ?Separator, ?Separated:list(list)) is det.
%
%	True if lists in Separated joined together with Separator form
%	Combined.  Can be used to split a list into sublists
%	or combine several sublists into a single list.
%
%	For example,
%	==
%	?- portray_text(true).
%
%	?- split("one,two,three", 0',, Parts).
%	Parts = ["one", "two", "three"].
%
%	?- split(Codes, 0',, ["alpha", "beta"]).
%	Codes = "alpha,beta".
%	==
split([], _, [[]]) :-
    !.  % optimization
split([Div|T], Div, [[]|Rest]) :-
    split(T, Div, Rest),  % implies: dif(Rest, [])
    !.  % optimization
split([H|T], Div, [[H|First]|Rest]) :-
    dif(H, Div),
    split(T, Div, [First|Rest]).


:- begin_tests(split).
test(forward_zero) :-
    split("", 10, [""]).
test(forward_one) :-
    split("hello", 10, ["hello"]).
test(forward_two) :-
    split("hello\naravis", 10, ["hello", "aravis"]).
test(forward_three) :-
    split("hello\naravis\njericho", 10, ["hello","aravis","jericho"]).

test(backward_zero) :-
    split(Codes, 10, [[]]),
    Codes = [].
test(backward_one) :-
    split(Codes, 10, ["hello"]),
    Codes = "hello".
test(backward_two) :-
    [Comma] = ",",
    split(Codes, Comma, ["alpha", "beta"]),
    Codes = "alpha,beta".
test(backward_three) :-
    [Comma] = ",",
    split(Codes, Comma, ["alpha","beta","gamma"]),
    Codes = "alpha,beta,gamma".

test(find_separator) :-
    split("alpha,beta", Div, ["alpha","beta"]),
    [Div] = ",".

test(forward_trailing_zero) :-
    split("\n", 10, ["",""]).
test(forward_trailing_one) :-
    split("hello\n", 10, ["hello",""]).
test(forward_trailing_two) :-
    split("hello\ngoodbye\n", 10, ["hello", "goodbye", ""]).
:- end_tests(split).

%%	take(?List:list, +N:nonneg, ?Front:list) is det.
%
%	True if Front contains the first N elements of List.
%	If N is larger than List's length, =|List=Front|=.
%
%	For example,
%	==
%	?- take([1,2,3,4], 2, L).
%	L = [1, 2].
%
%	?- take([1], 2, L).
%	L = [1].
%
%	?- take(L, 2, [a,b]).
%	L = [a, b|_G1055].
%	==
take([], N, []) :-
    N > 0,
    !.  % optimization
take(_, 0, []) :-
    !.  % optimization
take([H|T], N1, [H|Rest]) :-
    N1 > 0,
    succ(N0, N1),
    take(T, N0, Rest).

:- begin_tests(take).
test(n_huge) :-
    take([a,b], 100, [a,b]).
test(n_huge_empty) :-
    take([], 100, []).
test(n_small) :-
    take([a,b,c,d], 2, [a,b]).
test(none) :-
    take([a,b,c], 0, []).
test(none_empty) :-
    take([], 0, []).

test(backward) :-
    take(L, 3, [a,b,c]),
    L = [a,b,c|T],
    var(T).
test(backward_huge) :-
    take(L, 300, [a,b]),
    L = [a,b].
:- end_tests(take).
