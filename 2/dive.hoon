/*  puzzle-input  %txt  /lib/advent-2021/2/input/txt
=>
|%
+$  instruction
  $:  $?(%forward %down %up)
      n=@ud
  ==
::  part 1
++  get-final-position
  |=  l=(list instruction)
  ^-  [@ud @ud]
  =|  horiz=@ud
  =|  depth=@ud
  |-
  ?~  l
    [horiz depth]
  ?:  ?=([%forward *] i.l)
    $(l t.l, horiz (add n.i.l horiz))
  ?:  ?=([%down *] i.l)
    $(l t.l, depth (add n.i.l depth))
  ?:  ?=([%up *] i.l)
    $(l t.l, depth (sub depth n.i.l))
  !!
::  part 2
++  get-final-position-with-aim
  |=  l=(list instruction)
  ^-  [@ud @ud]
  =|  horiz=@ud
  =|  depth=@ud
  =|  aim=@ud
  |-
  ?~  l
    [horiz depth]
  ?:  ?=([%forward *] i.l)
    $(l t.l, horiz (add n.i.l horiz), depth (add depth (mul aim n.i.l)))
  ?:  ?=([%down *] i.l)
    $(l t.l, aim (add n.i.l aim))
  ?:  ?=([%up *] i.l)
    $(l t.l, aim (sub aim n.i.l))
  !!
::
++  parse-instruction
  |=  line=@t
  ^-  instruction
  %+  rash
    line
  ;~  (glue ace)
    ;~  pose
      (cold %forward (jest 'forward'))
      (cold %down (jest 'down'))
      (cold %up (jest 'up'))
    ==
    (cook @ud dem)
  ==
--
:-  %say
|=  *
:-  %noun
%-  mul
:: %-  get-final-position
%-  get-final-position-with-aim
%+  turn
  puzzle-input
parse-instruction
