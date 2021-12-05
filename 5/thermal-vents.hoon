/*  puzzle-input  %txt  /lib/advent-2021/5/input/txt
=>
|%
+$  point  [x=@ud y=@ud]
+$  line-segment  [start=point end=point]
::  map coordinate pairs to # of times that coord has
::  been touched by a line
+$  grid  (map [@ud @ud] @ud)
::
++  add-to-grid
  |=  [g=grid p=point]
  ^-  grid
  (~(put by g) p +((~(gut by g) p 0)))
::
++  parse-line-segment
  =<
  |=  l=@t
  ^-  line-segment
  %+  rash
    l
  ;~(plug parse-point ;~(pfix (jest ' -> ') parse-point))
  |%
  ++  parse-point
    %+  cook
      |=  [x=@ud @t y=@ud]
      ^-  point
      [x y]
    ;~(plug dem com dem)
  --
::  count # of squares that have an overlap of 2 or more lines
++  count-overlaps
  |=  g=grid
  ^-  @ud
  %-  ~(rep by g)
  |=  [[[@ud @ud] cnt=@ud] acc=@ud]
  ^-  @ud
  ?:((gte cnt 2) +(acc) acc)
::
++  build-grid
  |=  lines=(list line-segment)
  ^-  grid
  =|  g=grid
  |-
  ?~  lines
    g
  =/  cur=line-segment  i.lines
  $(lines t.lines, g (fill-single-line g i.lines))
::
++  fill-single-line
  =<
  |=  [g=grid l=line-segment]
  ^-  grid
  =/  x-adjust=$-(@ud @ud)  (determine-adjust x.start.l x.end.l)
  =/  y-adjust=$-(@ud @ud)  (determine-adjust y.start.l y.end.l)
  |-
  =/  new-g=grid  (add-to-grid g start.l)
  ?:  =(start.l end.l)
    new-g
  %=  $
    g  new-g
    start.l  [(x-adjust x.start.l) (y-adjust y.start.l)]
  ==
  |%
  ++  determine-adjust
    |=  [a=@ud b=@ud]
    ^-  $-(@ud @ud)
    ?:  =(a b)
      (bake same @ud)
    ?:  (gth a b)
      dec
    (bake (curr add 1) @ud)
  --
::
++  is-diagonal
  |=  l=line-segment
  ^-  flag
  &(!=(x.start.l x.end.l) !=(y.start.l y.end.l))
--
:-  %say
|=  *
:-  %noun
%-  count-overlaps
%-  build-grid
::  for part 1 filter out diagonal lines
::  %-  |=(l=(list line-segment) (skip l is-diagonal))
%+  turn
  puzzle-input
parse-line-segment

