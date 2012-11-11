-module(id_gen).
-export([generator/2, generator/3, proper_node_id/2]).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

proper_node_id(NodeId, CharList) ->
    ProperId = base62:base62(NodeId, CharList),
    case ProperId of
	[C | []] ->
%% the following 3 didn't work for a NodeId of 10, need to dig more into
%% Erlang string handling.  I may be approaching this all wrong.
%	    string:concat("0", C);
%	    string:chars(48, 1) ++ C;
%	    "0" ++ C;
	    "0" ++ string:chars(C, 1);

	TwoDigits ->
	    TwoDigits
    end.

generator(NodeId, Sequence) ->
    Base62Chars = base62:base62_char_list(),
    generator(proper_node_id(NodeId, Base62Chars), Sequence, Base62Chars).
    
generator(NodeId, Sequence, Base62Chars) ->
    receive
	{next_id, Requester} ->
	    NewSequence = Sequence + 1,
	    SequenceString = base62:base62(NewSequence, Base62Chars),
	    Requester ! string:concat(SequenceString, NodeId),
	    generator(NodeId, NewSequence, Base62Chars);
	_ ->
	    io:format("This should be logging of bad message"),
	    generator(NodeId, Sequence, Base62Chars)
    end.

-ifdef(TEST).

proper_node_id_test() ->
    CharList = base62:base62_char_list(),
    [?assert(string:equal(proper_node_id(10, CharList), "0A")),
    ?assert(string:equal(proper_node_id(620, CharList), "A0")),
    ?assert(string:equal(proper_node_id(0, CharList), "00"))].

-endif.
