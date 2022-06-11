%%%-------------------------------------------------------------------
%%% @author f023507i
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. Jun 2022 13:52
%%%-------------------------------------------------------------------
-module(min_window_substring).
-author("Zeke Farioli").

%% API
-export([min_window/2]).

min_window(S, T) ->
  TWindow = map_count(T),
  ok.

map_count(Str) ->
  Dic = dict:new(),
  map_count(Str, Dic).

map_count([], Dic) ->
  dict:to_list(Dic);
map_count([H|T], Dic) ->
  Dic2 = dict:update([H], fun([X]) -> [X + 1] end, [1], Dic),
  map_count(T,Dic2).
