-module(back_fam_contri).
-export([s/1]).

s(Args) ->
    io:format("Args:~p~n", [Args]),
    [File] = Args,
    NodeStr = lists:concat(["mczxn_4399_", File, "@118.26.238.5"]),
    Node = list_to_atom(NodeStr),
    io:format("Node:~p~n", [Node]),
    io:format("File:~p~n", [File]),
    {ok, L} = file:consult(File),

    io:format("L:~p~n", [L]),
    PingResult = net_adm:ping(Node),
    io:format("PingResult:~p~n", [PingResult]),
    Fun = fun(E) ->
            io:format("E:~p~n", [E]),
            {PlayerId, TotalContri, UseableContri} = E,
            rpc:call(Node, lib_family_upgrade,set_contribution,[PlayerId, UseableContri, TotalContri]),
            io:format("ok~n")

    end,

    lists:foreach(Fun, L).


