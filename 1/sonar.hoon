/*  puzzle-input  %txt  /lib/advent-2021/1/input/txt
=>
|%
++  num-increases
  =<
  |=  l=(list @ud)
  ^-  @ud
  (helper 0 ~ l)
  |%
  ++  helper
    |=  [acc=@ud cur=(unit @ud) l=(list @ud)]
    ^-  @ud
    ?~  l
      acc
    ?~  cur
      (helper acc (some i.l) t.l)
    %^    helper
        ?:((gth i.l u.cur) +(acc) acc)
      (some i.l)
    t.l
  --
::
++  sliding-window
  =<
  |=  l=(list @ud)
  ^-  @ud
  ?~  l
    0
  ?~  t.l
    0
  ?~  t.t.l
    0
  (helper 0 [i.l i.t.l i.t.t.l] t.t.t.l)
  |%
  ++  helper
    |=  [acc=@ud [a=@ud b=@ud c=@ud] l=(list @ud)]
    ^-  @ud
    ?~  l
      acc
    =/  old-total=@ud  ;:(add a b c)
    =/  new-total=@ud  (add i.l (sub old-total a))
    =/  new-acc=@ud  ?:((gth new-total old-total) +(acc) acc)
    (helper new-acc [b c i.l] t.l)
  --
--
:-  %say
|=  *
:-  %noun
:: %-  num-increases
%-  sliding-window
%+  turn
  puzzle-input
(curr rash dem)
