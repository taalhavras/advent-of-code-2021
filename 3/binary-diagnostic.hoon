/*  puzzle-input  %txt  /lib/advent-2021/3/input/txt
=>
|%
++  one  '1'
++  zero  '0'
::  part 1
::
++  calculate-gamma-and-epsilon
  |=  binary=(list tape)
  ^-  [@ud @ud]
  ::  number of digits
  =/  n=@ud  (lent (snag 0 binary))
  ::  threshold for being the most common bit at a position
  ::  for 100 this will be 51. for 101 this will also be 51.
  ::  problem doesn't specify how to deal with ties so I'll
  ::  assume it never happens here.
  =/  thresh=@ud  +((div (lent binary) 2))
  =/  gamma=tape
  ::  store frequency of ones in this map
  =|  freqs=(map @ud @ud)
  |-
  ?~  binary
    =/  i=@ud  (dec n)
    =|  acc=tape
    |-
    =/  cnt=@ud  (~(got by freqs) i)
    =/  new-acc=tape  [?:((gte cnt thresh) one zero) acc]
    ?:  =(i 0)
      new-acc
    $(acc new-acc, i (dec i))
  =/  cur=tape  i.binary
  =|  cur-idx=@ud
  |-
  ?~  cur
    ^$(binary t.binary)
  ?:  =(i.cur one)
    %=  $
      freqs  (~(put by freqs) cur-idx +((~(gut by freqs) cur-idx 0)))
      cur  t.cur
      cur-idx  +(cur-idx)
    ==
  $(cur t.cur, cur-idx +(cur-idx))
  =/  epsilon=tape  (turn gamma |=(c=@t ?:(=(c one) zero one)))
  :-  (scan gamma (bass 2 (star dit)))
  (scan epsilon (bass 2 (star dit)))
::  part 2
::
++  calculate-oxygen-and-co2
  =<
  |=  binary=(list tape)
  ^-  [@ud @ud]
  :-
    %+  scan
      (apply-filter binary 0 choose-most-common)
    to-decimal
  %+  scan
    (apply-filter binary 0 choose-least-common)
  to-decimal
  |%
  ++  is-one  |=(c=@t =(c one))
  ++  is-zero  |=(c=@t =(c zero))
  ++  to-decimal  (bass 2 (star dit))
  ::  choose a if it's the same or larger
  ++  choose-most-common
    |=  [a=wall b=wall]
    ^-  flag
    (gte (lent a) (lent b))
  ::  choose a if it's strictly smaller
  ++  choose-least-common
    |=  [a=wall b=wall]
    ^-  flag
    (lth (lent a) (lent b))
  ++  apply-filter
    |=  [l=wall idx=@ud f=$-([wall wall] flag)]
    ^-  tape
    ?:  =((lent l) 1)
      (snag 0 l)
    =/  [a=wall b=wall]  (split-by-digit l idx)
    $(l ?:((f a b) a b), idx +(idx))
  ::  given a list of tapes, determine if one is
  ::  the most common digit at a given index.
  ::  also returns the tapes with one at that index
  ::  and the tapes without
  ::
  ++  split-by-digit
    |=  [l=wall idx=@ud]
    ^-  [wall wall]
    =|  ones=wall
    =|  zeros=wall
    |-
    ?~  l
      [ones zeros]
    =/  is-one=flag  =(one (snag idx i.l))
    %=  $
      zeros  ?:(is-one zeros [i.l zeros])
      ones  ?:(is-one [i.l ones] ones)
      l  t.l
    ==
  --
--
:-  %say
|=  *
:-  %noun
%-  mul
:: %-  calculate-gamma-and-epsilon
%-  calculate-oxygen-and-co2
%+  turn
  puzzle-input
trip
