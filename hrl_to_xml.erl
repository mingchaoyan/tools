-module(hrl_to_xml).
-export([s/1]).

s(Args) ->
    [File] = Args,
    io:format("File:~p~n", [File]),

    HrlFile = lists:concat([File, ".hrl"]),
    XmlFile = lists:concat([File, ".xml"]),
    {ok, S} = file:open(HrlFile, read),
    {ok, W} = file:open(XmlFile, write),
    loop(S, W).

loop(S, W) ->
    Con = io:get_line(S, ''),
    case Con =:= eof of
        true ->
            file:close(S),
            file:close(W),
            io:format("convert ok!~n"),
            ok;
        false ->
            [H | T] = string:tokens(Con, ".  )(%,"),
            case H =:= "-define" andalso length(T) =:= 3 of
                true ->
                    [_Type, NumStr, Desc0 | _TT] = T,
                    Desc = string:strip(Desc0, both, $\n),
                    Num = list_to_integer(NumStr),
                    Line = lists:concat(["<item key=\"", Num, "\" text=\"", Desc, "\" />"]),
                    case Desc0 =/= "\n" of
                        true ->
                            io:format(W, "~s~n", [Line]);
                        false ->
                            ok
                    end;
                false ->
                    ok
            end,
            loop(S, W)
    end.
