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
  {TWindow, Window} = map_count(T),

  Res = min_window(S, Window, TWindow, 0 , dict:size(TWindow), [], {999999,0,0}, 0, 0),
  io:format("~p~n", [Res]),
  ok.

map_count(Str) ->
  Dic = dict:new(),
  map_count(Str, Dic, dict:new()).

map_count([], Dic, DicZeros) ->
  {Dic, DicZeros};
map_count([H|T], Dic, DicZeros) ->
  Dic2 = dict:update([H], fun([X]) -> [X + 1] end, [1], Dic),
  Dic3 = dict:update([H], fun([_]) -> [0] end, [0], DicZeros),
  map_count(T,Dic2,Dic3).


min_window([], Window, TWindow, Have, Needed, Acc, {MinDiff, BegIdxFinal, EndIdxFinal}, BegIdx, EndIdx) ->
  {Acc, MinDiff, BegIdxFinal, EndIdxFinal};

min_window([H|T], Window, TWindow, Have, Have , Acc, {MinDiff, BegIdxFinal, EndIdxFinal}, BegIdx, EndIdx) ->
  timer:sleep(1000),
  io:format("--------------------------~n~p~n~p~n~p~n~p~n~p~n~p~n", [[H] , {T, dict:to_list(Window), dict:to_list(TWindow)}, {Have, Have}, {Acc}, {MinDiff, BegIdxFinal, EndIdxFinal}, { BegIdx, EndIdx}]),


  Last = lists:last(Acc),

  Acc2 = lists:droplast(Acc),
  io:format("~p~n",[Acc2]),
  io:format("---~p~n",[[Last]]),
  MinDiff2 = EndIdx - BegIdx,
  {MinDiff3, BegIdxFinal3, EndIdxFinal3} = case MinDiff2 < MinDiff of
                                   true ->
                                     {MinDiff2, BegIdx, EndIdx};
                                   false ->
                                     {MinDiff, BegIdxFinal, EndIdxFinal}

                                 end,
  io:format("~p~n",[{MinDiff3, BegIdxFinal3, EndIdxFinal3}]),
  io:format("---------------------------------------~n"),
  case dict:is_key([Last], TWindow) of

    true ->
      io:format("~p~n",[{iskey_true, [Last]}]),
      Window2 = dict:update([Last], fun([X]) -> [X + 1] end, [1], Window),
      [WValue] = dict:fetch([Last],Window2),
      [TWValue] = dict:fetch([Last],TWindow),
      Have2 = case WValue =< TWValue of
                true ->
                  Have - 1;
                false ->
                  Have
              end,
      min_window([H|T], Window, TWindow, Have2, Have,Acc2,{MinDiff3, BegIdxFinal3, EndIdxFinal3}, BegIdx+1, EndIdx);
    false ->
      min_window(T, Window, TWindow, Have, Have, [H|Acc2], {MinDiff, BegIdxFinal, EndIdxFinal}, BegIdx+1, EndIdx)

  end;

min_window([H|T], Window, TWindow, Have, Needed, Acc, {MinDiff, BegIdxFinal, EndIdxFinal}, BegIdx, EndIdx) ->
  io:format("--------------------------~n~p~n~p~n~p~n~p~n~p~n~p~n", [[H] , {T, dict:to_list(Window), dict:to_list(TWindow)}, {Have, Needed}, {Acc}, {MinDiff, BegIdxFinal, EndIdxFinal}, { BegIdx, EndIdx}]),
%%  io:format("~p~n", [{[H] , "\n",  T, dict:to_list(Window), dict:to_list(TWindow), "\n", Have, Needed,"\n", Acc, "\n", {MinDiff, BegIdxFinal, EndIdxFinal}, "\n", BegIdx, EndIdx}]),
  case dict:is_key([H], TWindow) of
    true ->
      Window2 = dict:update([H], fun([X]) -> [X + 1] end, [1], Window),
      [WValue] = dict:fetch([H],Window2),
      [TWValue] = dict:fetch([H],TWindow),
      Have2 = case WValue of
                TWValue ->
                  Have +1;
                _ ->
                  Have
              end,
      min_window(T, Window, TWindow, Have2, Needed,[H|Acc], {MinDiff, BegIdxFinal, EndIdxFinal}, BegIdx, EndIdx+1);
    false ->
      min_window(T, Window, TWindow, Have, Needed, [H|Acc], {MinDiff, BegIdxFinal, EndIdxFinal}, BegIdx, EndIdx+1)

  end.



