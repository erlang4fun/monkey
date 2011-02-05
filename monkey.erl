-module(monkey).
-include_lib("eunit/include/eunit.hrl").
-compile(export_all).

%% function
fun1() ->
    Fun = fun() -> io:format("hello, world~n") end,
    Fun().
fun2() -> (fun() -> io:format("hello2 ~n") end)().
fun3() -> fun() -> io:format("hello3 ~n") end().

%% atom
module_dot() -> .io:format("put a dot before module name~n").

atom_test() ->
    .my_atom,
    no_dot = .no_dot,
    .no_dot = no_dot,
    io:format("atom: ~p~n", ['without_a_dot']),
    io:format("atom: ~p~n", [.with_a_dot]),
    io:format("atom: ~p~n", ['.with_a_dot']),
    ok.

%% current fun
current_fun() ->	     
    erlang:display(process_info(self(),current_function)).

%% redirect io    
redirect_print() ->
    %% how to redirect io:format to some other stream in EUnit?
    io:fwrite(standard_io, "hello, my name is ~s~n", ["monkey"]).

redirect_io_format() ->
    OriginalGroupLeader = group_leader(),
    Filename = "tmp_file_for_io",
    {ok, File} = file:open(Filename, [write]),
    io:format("usually you can see this~n"),
    group_leader(File, self()),
    io:format("now you can't see this in shell~n"),
    io:format("all io format redirected to file ~s~n", [Filename]),
    file:close(File),
    group_leader(OriginalGroupLeader, self()),
    io:format("io format again~n"),
    ok.

%% emacs bug
emacs_sucks() ->
    String = "some quotes \" end",
    re:run(String, "end$") =/= nomatch. % " emacs sucks

%% EUnit match    
match() ->
    ?assertMatch(_X, 5),
    Z = 331,
    ?assertMatch(Z, 331),
    ?assertMatch(Z, 224), %% exception because Z already bound to 331
    ok.

%% @doc this is some spec
%% @spec test(integer()) -> bool()
%% @end
test(A) when A > 0 ->
    true;
test(_) ->
    false.
