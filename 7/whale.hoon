/*  puzzle-input  %txt  /lib/advent-2021/7/input/txt
=>
|%
::  map horizontal position to # of crabs there, also track lowest
::  and highest horizontal positions
::  1M was chosen as larger than all values in my input.
+$  crabs  [freqs=(map @ud @ud) low=$~(1.000.000 @ud) high=@ud]
::
++  parse-crabs
  |=  l=(list @ud)
  ^-  crabs
  =|  acc=crabs
  |-
  ?~  l
    acc
  %=  $
    l  t.l
    acc  (add-to-count acc i.l 1)
  ==
::
++  add-to-count
  |=  [c=crabs horiz=@ud incr=@ud]
  ^-  crabs
  %=  c
    freqs  (~(put by freqs.c) horiz (add incr (~(gut by freqs.c) horiz 0)))
    high  (max horiz high.c)
    low  (min horiz low.c)
  ==
::  part 1
++  calculate-fuel-cost-part-1
  |=  [c=crabs idx=@ud]
  ^-  @ud
  ?>  (lte idx high.c)
  ?>  (gte idx low.c)
  %-  ~(rep by freqs.c)
  |=  [[horiz=@ud cnt=@ud] acc=@ud]
  ^-  @ud
  %+  add
    acc
  (mul cnt ?:((gte horiz idx) (sub horiz idx) (sub idx horiz)))
::  part 2
++  calculate-fuel-cost-part-2
  |=  [c=crabs idx=@ud]
  ^-  @ud
  ?>  (lte idx high.c)
  ?>  (gte idx low.c)
  %-  ~(rep by freqs.c)
  |=  [[horiz=@ud cnt=@ud] acc=@ud]
  ^-  @ud
  %+  add
    acc
  ::  now things cost 1, then 2, then 3 etc etc depending on how
  ::  many units we're moving. thus moving i units costs i(i+1)/2
  ::  it's the triangular numbers.
  =/  diff=@ud  ?:((gte horiz idx) (sub horiz idx) (sub idx horiz))
  (mul cnt (div (mul diff +(diff)) 2))
::
++  find-min
  |=  l=(list @ud)
  ^-  @ud
  =|  acc=(unit @ud)
  |-
  ?~  l
    (need acc)
  ?~  acc
    $(acc (some i.l), l t.l)
  $(acc (some (min u.acc i.l)), l t.l)
--
:-  %say
|=  *
:-  %noun
?>  =((lent puzzle-input) 1)
=/  c=crabs  (parse-crabs (rash (snag 0 puzzle-input) (more com dem)))
%-  find-min
%+  turn
  (gulf low.c high.c)
(cury calculate-fuel-cost-part-2 c)
::(cury calculate-fuel-cost-part-1 c)
