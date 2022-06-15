%%%-------------------------------------------------------------------
%%% @author f023507i
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Jun 2022 22:23
%%%-------------------------------------------------------------------
-module(array2).
-author("f023507i").

%% API
-export([to_array/1,get_f_arr/1,get_f_arr/2]).
-export([test/0]).

test() ->
  Arr = to_array("abdsdk"),
  iterate(Arr).

to_array(List) ->
  to_array(List, 0, dict:new()).

to_array([], _, Dict) ->
  Dict;
to_array([H|T], C, Dict) ->
  Dict1 = dict:append(C,H, Dict),
  to_array(T, C+1, Dict1).

get_f_arr(Arr) ->
  dict:to_list(Arr).

get_f_arr(Idx, Arr) ->
  dict:fetch(Idx,Arr).

iterate(Dict)->
  Size = dict:size(Dict),
  iterate(Dict,0, Size).

iterate(Dict,C, C) ->
  ok;
iterate(Dict,C, Size) ->
  get_f_arr(C, Dict),
  iterate(Dict,C+1, Size).