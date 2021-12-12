/*  puzzle-input  %txt  /lib/advent-2021/12/input/txt
=>
|%
+$  cave  tape
::  our graph is map of cave to the set of all the reachable caves
::  from that cave
+$  graph  (jug cave cave)
::  a route is just a list of caves. routes are "backwards" - ending
::  with "start" and starting with "end". This was done so we could
::  append faster.
+$  route  (list cave)
::  fcn that determines if you can add a cave to a route
+$  validator  $-([route cave] flag)
::
++  is-big
  |=  c=cave
  ^-  flag
  =(c (cuss c))
::  for part one, we can always go to big caves and can never
::  revisit small caves
++  can-add-to-route-part-one
  |=  [r=route c=cave]
  ^-  flag
  ?|  (is-big c)
      !(~(has in (silt r)) c)
  ==
::  for part two we can always go to big caves and can revist ONE small
::  cave exactly once. We can never revisit start or end.
++  can-add-to-route-part-two
  =>
  |%
  ++  count-small-freqs
    |=  r=route
    ^-  (map cave @ud)
    =|  acc=(map cave @ud)
    |-
    ?~  r
      acc
    ?:  (is-big i.r)
      $(r t.r)
    $(r t.r, acc (~(put by acc) i.r +((~(gut by acc) i.r 0))))
  --
  |=  [r=route c=cave]
  ^-  flag
  ?:  =(c "start")
    |
  ?:  (is-big c)
    &
  =/  freqs=(map cave @ud)  (count-small-freqs r)
  ?:  !(~(has by freqs) c)
    ::  haven't visited yet
    &
  ::  we have visited, make sure we haven't been anywhere else twice.
  %-  ~(rep by freqs)
  |=  [[cave freq=@ud] acc=flag]
  ^-  flag
  ::  flag default is true, but make it false if freq >= 2
  &(acc (lth freq 2))
::
++  route-finished
  |=  r=route
  ^-  flag
  ?~  r
    |
  =(i.r "end")
::
++  expand-routes
  |=  [g=graph r=route can-add=validator]
  ^-  (list route)
  =/  candidates=(set cave)  (~(get ju g) (snag 0 r))
  %+  murn
    ~(tap in candidates)
  |=  c=cave
  ^-  (unit route)
  ?:  (can-add r c)
    (some [c r])
  ~
::
++  count-routes
  |=  [g=graph can-add=validator]
  ^-  @ud
  =|  acc=(set route)
  =/  queue=(list route)  ~[~["start"]]
  |-
  ?~  queue
    ~(wyt in acc)
  =/  to-expand=route  i.queue
  ?:  (route-finished to-expand)
    $(acc (~(put in acc) to-expand), queue t.queue)
  =/  expansions=(list route)  (expand-routes g to-expand can-add)
  $(queue (weld expansions t.queue))
::
++  parse-graph
  |=  w=wain
  ^-  graph
  =|  acc=graph
  |-
  ?~  w
    acc
  =/  [a=tape b=tape]  (rash i.w ;~(plug ;~(sfix (plus alf) hep) (plus alf)))
  %=  $
    w  t.w
    acc  (~(put ju (~(put ju acc) a b)) b a)
  ==
--
:-  %say
|=  *
:-  %noun
%+  count-routes
  (parse-graph puzzle-input)
::can-add-to-route-part-one
can-add-to-route-part-two
