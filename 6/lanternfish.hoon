/*  puzzle-input  %txt  /lib/advent-2021/6/input/txt
=>
|%
::  store lanternfish as a map of timers (@ud) to count (@ud)
+$  lanternfish  (map @ud @ud)
::
++  parse-lanternfish
  |=  l=(list @ud)
  ^-  lanternfish
  =|  acc=lanternfish
  |-
  ?~  l
    acc
  $(l t.l, acc (add-to-count acc i.l 1))
::
++  add-to-count
  |=  [l=lanternfish life=@ud incr=@ud]
  ^-  lanternfish
  (~(put by l) life (add incr (~(gut by l) life 0)))
::
++  advance-day
  |=  l=lanternfish
  ^-  lanternfish
  %-  ~(rep by l)
  |=  [[life=@ud num-fish=@ud] acc=lanternfish]
  ^-  lanternfish
  ?:  =(life 0)
    ::  add in num-fish to 6 (resetting) and 8 (newly spawned)
    (add-to-count (add-to-count acc 8 num-fish) 6 num-fish)
  (add-to-count acc (dec life) num-fish)
::
++  advance-n-days
  |=  [n=@ud l=lanternfish]
  ^-  lanternfish
  ?:  =(n 0)
    l
  (advance-n-days (dec n) (advance-day l))
::
++  count-fish
  |=  l=lanternfish
  ^-  @ud
  %-  ~(rep by l)
  |=  [[life=@ud num-fish=@ud] acc=@ud]
  ^-  @ud
  (add acc num-fish)
--
:-  %say
|=  *
:-  %noun
%-  count-fish
%+  advance-n-days
  ::  part 1 is 80 days, part 2 is 256
::  80
  256
::  input is just one comma separated line
?>  =((lent puzzle-input) 1)
(parse-lanternfish (rash (snag 0 puzzle-input) (more com dem)))
