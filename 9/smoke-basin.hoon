/*  puzzle-input  %txt  /lib/advent-2021/9/input/txt
=>
|%
++  find-low-points
  |=  grid=(list (list @ud))
  ^-  (list [@ud @ud])
  =/  num-rows=@ud  (lent grid)
  =/  num-cols=@ud  (lent (snag 0 grid))
  =|  low-points=(list [@ud @ud])
  =|  row=@ud
  =|  col=@ud
  |-
  ?:  =(row num-rows)
    low-points
  ?:  =(col num-cols)
    $(col 0, row +(row))
  =/  cur-elt=@ud  (snag col (snag row grid))
  =/  cur-is-low=flag
    %+  levy
      (get-neighbors [num-rows num-cols] row col)
    |=  [r=@ud c=@ud]
    ^-  flag
    (lth cur-elt (snag c (snag r grid)))
  ?:  cur-is-low
    $(low-points [[row col] low-points], col +(col))
  $(col +(col))
::
++  get-neighbors
  |=  [[nrows=@ud ncols=@ud] row=@ud col=@ud]
  ^-  (list [@ud @ud])
  =/  up=(unit [@ud @ud])
    ?:  =(row 0)
      ~
    `[(dec row) col]
  =/  down=(unit [@ud @ud])
    ?:  =(+(row) nrows)
      ~
    `[+(row) col]
  =/  left=(unit [@ud @ud])
    ?:  =(col 0)
      ~
    `[row (dec col)]
  =/  right=(unit [@ud @ud])
    ?:  =(+(col) ncols)
      ~
    `[row +(col)]
  %+  reel
    `(list (unit [@ud @ud]))`~[up down left right]
  |=  [elt=(unit [@ud @ud]) acc=(list [@ud @ud])]
  ^-  (list [@ud @ud])
  ?~  elt
    acc
  [u.elt acc]
::
++  part-one
  |=  grid=(list (list @ud))
  ^-  @ud
  %+  reel
    (find-low-points grid)
  |=  [[r=@ud c=@ud] acc=@ud]
  ^-  @ud
  ::  Increment cur due to how risk level is calculated.
  (add +((snag c (snag r grid))) acc)
::  basins are areas of the grid divided by 9s. we can find them
::  by finding all the low points and then for each one doing
::  flood-fill out until we see 9s.
::
++  split-into-basins
  |=  grid=(list (list @ud))
  ^-  (list (set [@ud @ud]))
  %+  turn
    (find-low-points grid)
  (cury flood-fill grid)
::
++  flood-fill
  =<
  |=  [grid=(list (list @ud)) row=@ud col=@ud]
  ^-  (set [@ud @ud])
  =/  nrows=@ud  (lent grid)
  =/  ncols=@ud  (lent (snag 0 grid))
  (helper grid nrows ncols row col ~)
  |%
  ++  helper
    |=  [grid=(list (list @ud)) nrows=@ud ncols=@ud row=@ud col=@ud acc=(set [@ud @ud])]
    ^-  (set [@ud @ud])
    ?:  (~(has in acc) [row col])
      acc
    ?:  =((snag col (snag row grid)) 9)
      acc
    =/  new-acc=(set [@ud @ud])  (~(put in acc) [row col])
    =/  neighbors=(list [@ud @ud])  (get-neighbors [nrows ncols] row col)
    |-
    ?~  neighbors
      new-acc
    $(neighbors t.neighbors, new-acc (helper grid nrows ncols -.i.neighbors +.i.neighbors new-acc))
  --
::
++  part-two
  |=  grid=(list (list @ud))
  ^-  @ud
  =/  sorted-basin-sizes=(list @ud)
    %+  sort
      %+  turn
        (split-into-basins grid)
      |=  a=(set [@ud @ud])
      ^-  @ud
      ~(wyt in a)
    gth
  ;:  mul
    (snag 0 sorted-basin-sizes)
    (snag 1 sorted-basin-sizes)
    (snag 2 sorted-basin-sizes)
  ==
--
:-  %say
|=  *
:-  %noun
::%-  part-one
%-  part-two
%+  turn
  puzzle-input
|=(l=@t (rash l (plus dit)))
