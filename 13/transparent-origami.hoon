/*  puzzle-input  %txt  /lib/advent-2021/13/input/txt
=>
|%
+$  coord  [x=@ud y=@ud]
+$  fold-instruction  [is-x=flag dim=@ud]
::
++  fold-over
  =<
  |=  [coords=(set coord) inst=fold-instruction]
  ^-  (set coord)
  ::  For a given coord [x, y] folding over d is defined as follows:
  ::  wlog we can say we're folding over dimension x.
  ::  if d > x then coord is unchanged.
  ::  if d < x then the coord becomes [x - 2(d - x), y]
  ::  d will never be equal to x.
  %-  ~(run in coords)
  |=  c=coord
  ^-  coord
  ?:  is-x.inst
    [(fold-dim x.c dim.inst) y.c]
  [x.c (fold-dim y.c dim.inst)]
  |%
  ++  fold-dim
    |=  [orig=@ud fold=@ud]
    ^-  @ud
    ?:  (lth orig fold)
      orig
    (sub orig (mul 2 (sub orig fold)))
  --
::
++  parse-coord
  |=  t=@t
  ^-  coord
  (rash t ;~(plug ;~(sfix dem com) dem))
::
++  parse-instruction
  |=  t=@t
  ^-  fold-instruction
  %+  rash
    t
  ;~  plug
    ;~  pfix
      (jest 'fold along ')
      (cook |=(c=char =(c 'x')) ;~(pose (jest 'x') (jest 'y')))
    ==
    ;~  pfix
      tis
      dem
    ==
  ==
::
++  parse-input
  |=  lines=wain
  ^-  [(set coord) (list fold-instruction)]
  :: split on blank line
  =/  split=@ud  (need (find ~['\00'] lines))
  :-  (silt (turn (scag split lines) parse-coord))
  (turn (slag +(split) lines) parse-instruction)
::
++  part-one
  |=  [coords=(set coord) instructions=(list fold-instruction)]
  ^-  @ud
  ~(wyt in (fold-over coords (snag 0 instructions)))
::
++  render-coords
  |=  coords=(set coord)
  ^-  wall
  =/  max-x=@ud  +((~(rep in coords) |=([c=coord acc=@ud] (max acc x.c))))
  =/  max-y=@ud  +((~(rep in coords) |=([c=coord acc=@ud] (max acc y.c))))
  =|  acc=wall
  =|  cur-x=@ud
  =|  cur-y=@ud
  |-
  ?:  =(max-x cur-x)
    (flop acc)
  =|  cur-line=tape
  |-
  ?:  =(max-y cur-y)
    ^$(acc [(flop cur-line) acc], cur-x +(cur-x), cur-y 0)
  =/  to-add=@t
    ?:  (~(has in coords) [cur-x cur-y])
      'X'
    ' '
  $(cur-y +(cur-y), cur-line [to-add cur-line])
::
++  part-two
  |=  [coords=(set coord) instructions=(list fold-instruction)]
  ^-  wall
  ~&  instructions
  |-
  ?~  instructions
    (render-coords coords)
  $(coords (fold-over coords i.instructions), instructions t.instructions)
--
:-  %say
|=  *
:-  %noun
::%-  part-one
%-  part-two
(parse-input puzzle-input)
