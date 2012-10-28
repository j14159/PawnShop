-module(base62).
-export([base62_list/1, base62_char/1, base62/2]).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

%% @doc generates a list of base 62 values for digit lookup (integer format) for given integer
base62_list(Num) ->
    Count62 = Num div 62, 
    Remaining = Num rem 62,
    case Count62 of
	X when X > 0 ->
	    [Remaining | base62_list(X)];
	_ when Remaining > 0 ->
	    [Remaining | []]; %have to do this or it's not eval'd properly.
	_ ->
	    []
    end.

%% @doc legacy function, looks up the appropriate base 62 character for given value.
base62_char(CharIndex) ->
    Chars = lists:append(lists:append(lists:seq(48, 57), lists:seq(65, 90)), lists:seq(97, 122)),
    lists:nth(CharIndex + 1, Chars).

%% @doc genenerates the sequence [0-9A-Za-z] for representing base 62 values.
base62_char_list() ->
    lists:append(lists:append(lists:seq(48, 57), lists:seq(65, 90)), lists:seq(97, 122)).

%% @doc converts a given number to a base 62 string using a supplied character list.
%% The character list is required so that we don't re-calcultate the list for 
%% every character.
base62(Num, CharList) ->
    Indices = base62_list(Num),
    MapFun = fun(X) -> lists:nth(X + 1, CharList) end, %base62_char(X) end,
    Digits = lists:map(MapFun, Indices),
    lists:reverse(Digits).

-ifdef(TEST).

base62_test() ->
    CharList = base62_char_list(),
    [?_assert(base62(620, CharList) =:= "A0"),
     ?_assert(base62(0, CharList) =:= "0"),
    ?_assert(base62(36, CharList) =:= "a")].

-endif.
