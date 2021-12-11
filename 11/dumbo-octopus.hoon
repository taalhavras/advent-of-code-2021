/*  puzzle-input  %txt  /lib/advent-2021/11/input/txt
=>
|%
+$  coord  [row=@ud col=@ud]
::  map 2d coordinates to energy levels
+$  board  (map [@ud @ud] @ud)
::
+$  modification  ?(%inc %dec %same)
::  maximum row or column value
++  dim  9
::
++  render-board
  |=  b=board
  ^-  wall
  =|  row=@ud
  =|  col=@ud
  =|  acc=wall
  =|  cur=tape
  |-
  ?:  =(row dim)
    acc
  |-
  ?:  =(col dim)
    ^$(row +(row), col 0, acc (snoc acc cur), cur "")
  =/  value=@ud  (~(got by b) [row col])
  $(col +(col), cur (weld cur ?:((gth value 9) "F" <value>)))
::
++  get-mod-fcn
  |=  m=modification
  ^-  $-(@ud @ud)
  ?-  m
    %inc  |=(a=@ud +(a))
    %dec  |=(a=@ud (dec a))
    %same  |=(a=@ud a)
  ==
::  neighbors, including diagonals
++  get-neighbors
  |=  =coord
  ^-  (list ^coord)
  =/  inc  |=(a=@ud +(a))
  =/  s  (bake same @ud)
  =/  mods
    ^-  (list [modification modification])
    :~  [%dec %dec]
        [%dec %same]
        [%dec %inc]
        [%same %dec]
        [%same %inc]
        [%inc %dec]
        [%inc %same]
        [%inc %inc]
    ==
  %+  murn
    mods
  |=  [r=modification c=modification]
  ^-  (unit ^coord)
  ?:  &(=(row.coord 0) =(r %dec))
    ~
  ?:  &(=(col.coord 0) =(c %dec))
    ~
  ?:  &(=(row.coord dim) =(r %inc))
    ~
  ?:  &(=(col.coord dim) =(c %inc))
    ~
  %-  some
  :-  ((get-mod-fcn r) row.coord)
  ((get-mod-fcn c) col.coord)
::
++  parse-board
  |=  l=(list (list @ud))
  ^-  board
  =|  row=@ud
  =|  col=@ud
  =|  b=board
  |-
  ?~  l
    b
  |-
  ?~  i.l
    ^$(l t.l, row +(row), col 0)
  $(i.l t.i.l, col +(col), b (~(put by b) [row col] i.i.l))
::  run a single step of the board, returning the new board
::  and the count of the # of octopi that flashed.
++  run-single-step
  =<
  |=  b=board
  ^-  [@ud board]
  =|  flash-cnt=@ud
  =|  flashed=(set coord)
  =.  b  (increment-all b)
  |-
::  %-  (slog leaf+"BOARD IS" ~)
::  %-  (slog (turn (render-board b) |=(t=tape `tank`[%leaf t])))
  ::  compute the octopi flashing now who haven't previously flashed
  =/  flashing-now=(set coord)  (~(dif in (will-flash b)) flashed)
  =/  n=@ud  ~(wyt in flashing-now)
  ?:  =(n 0)
    ::  produce flash count and zero everything that flashed
    :-  flash-cnt
    (~(gas by b) (turn ~(tap in flashed) |=(c=coord [c 0])))
  ::  some new octopi are flashing!
  =/  flashed-neighbors=(list coord)
    %-  zing
    (turn ~(tap in flashing-now) get-neighbors)
  %=  $
    b  (increment-chosen b flashed-neighbors)
    flashed  (~(uni in flashed) flashing-now)
    flash-cnt  (add n flash-cnt)
  ==
  |%
  ++  increment-all
    |=  b=board
    ^-  board
    (~(run by b) |=(a=@ud +(a)))
  ::  we intentionally take a list here since duplicates are permitted.
  ++  increment-chosen
    |=  [b=board l=(list coord)]
    ^-  board
    ?~  l
      b
    %=  $
      b  (~(put by b) i.l (add (~(got by b) i.l) 1))
      l  t.l
    ==
  ::
  ++  will-flash
    |=  b=board
    ^-  (set coord)
    %-  silt
    %+  murn
      ~(tap by b)
    |=  [c=coord val=@ud]
    ^-  (unit coord)
    ::  flashes with energy strictly greater than 9
    ?:  (gth val 9)
      (some c)
    ~
  --
::
++  run-n-steps
  |=  [b=board n=@ud]
  ^-  [@ud board]
  =|  acc=@ud
  |-
  ?:  =(n 0)
    [acc b]
  =/  [flashed=@ud new-board=board]  (run-single-step b)
  $(b new-board, acc (add flashed acc), n (dec n))
::
++  part-one
  |=  b=board
  ^-  @ud
  %-  head
  (run-n-steps b 100)
::  find first step where everything flashes
++  part-two
  |=  b=board
  ^-  @ud
  =|  step=@ud
  |-
  =/  res  (run-single-step b)
  ?:  =(-.res 100)
    +(step)
  $(step +(step), b +.res)
--
:-  %say
|=  *
:-  %noun
%-  part-two
::%-  part-one
%-  parse-board
%+  turn
  puzzle-input
|=(l=@t (rash l (plus dit)))
