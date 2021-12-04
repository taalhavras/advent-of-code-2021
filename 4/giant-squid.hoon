/*  puzzle-input  %txt  /lib/advent-2021/4/input/txt
=>
|%
::  flag represents if the value is selected
+$  board  (map [@ud @ud] [flag @ud])
::  boards are 5x5 so dim is the largest idx
++  dim  4
++  generate-coords
  |=  [idx=@ud row=flag]
  ^-  (list [@ud @ud])
  %+  turn
    (gulf 0 dim)
  |=  elt=@ud
  ^-  [@ud @ud]
  ?:  row
    [idx elt]
  [elt idx]
++  all-coords
  ^-  (list (list [@ud @ud]))
  =|  acc=(list (list [@ud @ud]))
  =|  cur=@ud
  |-
  ?:  (gth cur dim)
    acc
  $(acc [(generate-coords cur |) (generate-coords cur &) acc], cur +(cur))
++  board-is-done
  |=  b=board
  ^-  flag
  %+  lien
    all-coords
  |=  l=(list [@ud @ud])
  ^-  flag
  %+  levy
    l
  |=  c=[@ud @ud]
  ^-  flag
  -:(~(got by b) c)
++  calculate-score
  |=  [b=board last=@ud]
  ^-  @ud
  %+  mul
    last
  %-  ~(rep by b)
  |=  [[[@ud @ud] f=flag v=@ud] acc=@ud]
  ^-  @ud
  (add acc ?:(f 0 v))
::
++  parse-board
  =<
  |=  l=(list @t)
  ^-  board
  ~&  [%parsing-lines l]
  =/  lines=(list (list @ud))  (turn l parse-line)
  =|  b=board
  =|  cur-row=@ud
  |-
  ?~  lines
    b
  =|  cur-col=@ud
  |-
  ?~  i.lines
    ^$(lines t.lines, cur-row +(cur-row))
  $(b (~(put by b) [cur-row cur-col] [| i.i.lines]), i.lines t.i.lines, cur-col +(cur-col))
  |%
  ++  parse-line
    |=  l=@t
    ^-  (list @ud)
    ::  discard leading spaces, gaps between elts are
    ::  1 or more space.
    (rash l ;~(pfix (star ace) (more (plus ace) dem)))
  --
::
++  apply-to-board
  |=  [b=board square=@ud]
  ^-  board
  %-  ~(run by b)
  |=  [status=flag val=@ud]
  ^-  [flag @ud]
  :_  val
  ?:(=(val square) & status)
::  returns completed board and last number called
::  this is part 1, so returns the FIRST game to win.
++  run-bingo-game
  |=  [vals=(list @ud) boards=(list board)]
  ^-  [board @ud]
  |-
  ?~  vals
    !!
  =/  new-boards=(list board)  (turn boards (curr apply-to-board i.vals))
  =/  done=(list board)  (skim new-boards board-is-done)
  ?~  done
    $(boards new-boards, vals t.vals)
  ?>  =((lent done) 1)
  [i.done i.vals]
::  part 2, gets the last bingo game to win
::
++  run-bingo-game-get-last
  |=  [vals=(list @ud) boards=(list board)]
  ^-  [board @ud]
  |-
  ?~  vals
    !!
  =/  new-boards=(list board)  (turn boards (curr apply-to-board i.vals))
  =/  [done=(list board) left=(list board)]  (skid new-boards board-is-done)
  ?~  left
    :: If there are no boards left the last board just finished.
    ?>  =((lent done) 1)
    [(snag 0 done) i.vals]
  ::  Otherwise discard any that are done
  $(boards left, vals t.vals)
::
++  split-board-lines
  |=  lines=(list @t)
  ^-  (list (list @t))
  =|  acc=(list (list @t))
  =|  cur=(list @t)
  |-
  ?~  lines
    ::  Notably the input doesn't end in a newline/blank so
    ::  the first case should not happen but might as well be
    ::  safe about it.
    ?~  cur
      acc
    [cur acc]
  =/  current-line=@t  i.lines
  ::  If the line is just a blank, skip it and consider
  ::  the current batch done.
  ?:  =(current-line '')
    $(lines t.lines, cur ~, acc [cur acc])
  $(lines t.lines, cur [i.lines cur])
--
:-  %say
|=  *
:-  %noun
=/  squares-chosen=(list @ud)  (rash (snag 0 puzzle-input) (more com dem))
=/  board-lines=(list @t)  (slag 2 puzzle-input)
=/  boards=(list board)  (turn (split-board-lines board-lines) parse-board)
%-  calculate-score
::%+  run-bingo-game
%+  run-bingo-game-get-last
  squares-chosen
boards
