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

min_window(S,T) ->
  S1 = binary_to_list(S),
  T1 = binary_to_list(T),
  min_window_sub(S1, T1).



min_window_sub(S,S) ->
  list_to_binary( S);

min_window_sub(S,[One]) ->
  case lists:member(One, S) of
    true->
      list_to_binary([One]);
    false ->
      <<"">>
  end;

min_window_sub(S, T) ->
  SLength = length(S),
  TLength = length(T),
  case TLength of
    SLength ->
      S1 =lists:sort(S),
      T1 = lists:sort(T),
      case S1 of
        T1 ->
          list_to_binary(S);
        _ ->
          <<"">>
      end;
    _ ->
      case TLength > SLength of
        true ->
          <<"">>;
        false ->
          list_to_binary(min_window_sub2(S, T))
      end
  end.



min_window_sub2(S, T) ->
  {TWindow, Window} = string_to_dict_count(T),
  Array = to_map_like_array(S), % index key - value letter
  Size = dict:size(Window),

  {_MinDiff, Right,Left} = min_window_sub2(S,Window,TWindow, 0, 0, {999999, 0, 0},  0, Size,S, Array),
  sub_s(S, Left+1, Right).


min_window_sub2([],Window,TWindow, Left,Right,  {MinDiff, BegIdx, EndIdx}, Have, Have,OrigStr, Arr)->
  NewDiff = Right - Left,
  {MinDiff2, BegIdx2, EndIdx2} = case NewDiff < MinDiff of
                                   true ->
                                     {NewDiff, Right, Left};
                                   false ->
                                     {MinDiff, BegIdx, EndIdx}
                                 end,
  Letter = [get_from_map_type_array(Left, Arr)],
  case dict:is_key(Letter,TWindow) of
    true ->
      NewWindow = dict:update(Letter, fun([X]) -> [X + -1] end,[0] , Window),
      NWFetch = dict:fetch(Letter, NewWindow),
      OldFetch = dict:fetch(Letter, TWindow),
      NewHave = case NWFetch < OldFetch of
                  true ->
                    Have - 1;
                  false ->
                    Have
                end,
      min_window_sub2([],NewWindow,TWindow, Left+1,Right,  {MinDiff2, BegIdx2, EndIdx2}, NewHave, Have,OrigStr,Arr);
    false ->
      min_window_sub2([],Window,TWindow, Left+1,Right,  {MinDiff2, BegIdx2, EndIdx2}, Have, Have,OrigStr,Arr)

  end;

min_window_sub2([],_Window,_TWindow, Left,Right,  {MinDiff, BegIdx, EndIdx}, Have, Needed,_OrigStr,  _Arr)  ->
  case Have >= Needed of
    true ->
      NewDiff = Right - Left,
      {MinDiff2, BegIdx2, EndIdx2} = case NewDiff < MinDiff of
                                       true ->
                                         {NewDiff, Right, Left};
                                       false ->
                                         {MinDiff, BegIdx, EndIdx}
                                     end,
      {MinDiff2, BegIdx2, EndIdx2};
    false ->
      {MinDiff, BegIdx, EndIdx}

  end;


min_window_sub2([H|T],Window,TWindow, Left,Right,  {MinDiff, BegIdx, EndIdx}, Have, Have, OrigStr, Arr) ->
  NewDiff = Right - Left,
  {MinDiff2, BegIdx2, EndIdx2} = case NewDiff < MinDiff of
                                   true ->
                                     {NewDiff, Right, Left};
                                   false ->
                                     {MinDiff, BegIdx, EndIdx}
                                 end,
  Letter = [get_from_map_type_array(Left, Arr)],
  case dict:is_key(Letter,TWindow) of
    true ->
      NewWindow = dict:update(Letter, fun([X]) -> [X + -1] end,[0] , Window),
      NWFetch = dict:fetch(Letter, NewWindow),
      OldFetch = dict:fetch(Letter, TWindow),
      NewHave = case NWFetch < OldFetch of
                  true ->
                    Have - 1;
                  false ->
                    Have
                end,
      min_window_sub2([H|T],NewWindow,TWindow, Left+1,Right,  {MinDiff2, BegIdx2, EndIdx2}, NewHave, Have,OrigStr, Arr);
    false ->
      min_window_sub2([H|T],Window,TWindow, Left+1,Right,  {MinDiff2, BegIdx2, EndIdx2}, Have, Have,OrigStr, Arr)

  end;

min_window_sub2([H|T],Window,TWindow, Left,Right,  {MinDiff, BegIdx, EndIdx}, Have, Needed,OrigStr, Arr) ->
  case dict:is_key([H],TWindow) of
    true ->
      NewWindow = dict:update([H], fun([X]) -> [X + 1] end,[0] , Window),
      NWFetch = dict:fetch([H], NewWindow),
      OldFetch = dict:fetch([H], TWindow),
      NewHave = case NWFetch of
                  OldFetch ->
                    Have+1;
                  _ ->
                    Have
                end,
      min_window_sub2(T,NewWindow,TWindow, Left,Right+1,  {MinDiff, BegIdx, EndIdx}, NewHave, Needed,OrigStr, Arr);
    false ->
      min_window_sub2(T,Window,TWindow, Left,Right+1,  {MinDiff, BegIdx, EndIdx}, Have, Needed,OrigStr, Arr)


  end.

string_to_dict_count(Str) ->
  Dict = dict:new(),
  Dict2 = dict:new(),
  string_to_dict_count(Str, Dict, Dict2).

string_to_dict_count([], Dict, Dict2) ->
  {Dict, Dict2};
string_to_dict_count([H|T], Dict, Dict2) ->
  NewDict = dict:update([H], fun([X]) -> [X + 1] end, [1], Dict),
  NewDict2 = dict:update([H], fun([_X]) -> [0] end, [0], Dict2),
  string_to_dict_count(T,NewDict,NewDict2).

sub_s(Str, B, E) ->
  sub_s(Str,B,E,0,[]).

sub_s([],_B,_E,_C,Acc) ->
  lists:reverse(Acc);
sub_s([_H|_T],_B,E,E,Acc) ->
  lists:reverse(Acc);
sub_s([H|T],B,E, C, Acc) ->
  case (C+1)>=B of
    true ->
      sub_s(T,B, E, C+1,[H|Acc]);
    false ->
      sub_s(T,B, E, C+1,Acc)
  end.

to_map_like_array(Str) ->
  Size = length(Str),
  to_map_like_array(Str, maps:new(),0, Size).

to_map_like_array([], Map, _C, _Size) ->
  Map;
to_map_like_array([H|T], Map, C, Size) ->
  Map2 = maps:put(C,H, Map),
  to_map_like_array(T, Map2,C+1, Size).

get_from_map_type_array(K,Map) ->
  maps:get(K, Map).