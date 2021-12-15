/*  puzzle-input  %txt  /lib/advent-2021/14/input/txt
=>
|%
+$  polymer  [a=char b=char]
::  map polymers to frequencies
+$  polymer-template  (map polymer @ud)
::  given polymer [a b] mapped to char r, produce [a r] and [r b]
+$  polymer-rules  (map polymer char)
::
++  add-to-count
  |=  [template=polymer-template p=polymer cnt=@ud]
  ^-  polymer-template
  (~(put by template) p (add cnt (~(gut by template) p 0)))
::
++  run-polymerization
  |=  [template=polymer-template rules=polymer-rules]
  ^-  polymer-template
  %-  ~(rep by template)
  |=  [[p=polymer cnt=@ud] acc=polymer-template]
  ^-  polymer-template
  =/  split=(unit char)  (~(get by rules) p)
  ?~  split
    ::  In this case we're not splitting these pairs -
    ::  increase whatever's in acc by this amount.
    (add-to-count acc p cnt)
  (add-to-count (add-to-count acc [a.p u.split] cnt) [u.split b.p] cnt)
::
++  run-n-iterations
  |=  [n=@ud template=polymer-template rules=polymer-rules]
  ^-  polymer-template
  |-
  ?:  =(n 0)
    template
  $(n (dec n), template (run-polymerization template rules))
::  find diff between largest and smallest ELEMENT counts
::  we need to pass the first and last characters to properly account
::  for duplicates.
++  diff
  |=  [first=char last=char template=polymer-template]
  ^-  @ud
  ::  since we're interested in the element counts we must account for
  ::  double counting here. Imagine having AB -> 2 and BA -> 2.
  ::  naively we'd say we have 4 A and 4 B, yet the sequence is just
  ::  ABABA - 3 As and 2 Bs! It could also be BABAB based soley on
  ::  these freqs. We take advantage of the fact that the first and last
  ::  characters don't change though, so we can bump the counts for
  ::  those by one. At this point every freq should be exactly double
  ::  counted, so we can divide by 2 when taking the min/max.
  =/  freqs=(map char @ud)
    %-  ~(rep by template)
    |=  [[p=polymer cnt=@ud] acc=(map char @ud)]
    ^-  (map char @ud)
    =/  new=(map char @ud)  (~(put by acc) a.p (add cnt (~(gut by acc) a.p 0)))
    (~(put by new) b.p (add cnt (~(gut by new) b.p 0)))
  =.  freqs  (~(put by freqs) first +((~(got by freqs) first)))
  =.  freqs  (~(put by freqs) last +((~(got by freqs) last)))
  =/  [smallest=@ud largest=@ud]
    %-  ~(rep by freqs)
    |=  [[char cnt=@ud] acc=[s=$~(1.000.000.000.000.000.000 @ud) l=@ud]]
    ^-  [@ud @ud]
    =/  half  (div cnt 2)
    [(min s.acc half) (max l.acc half)]
  (sub largest smallest)
::
++  solve
  |=  [orig=tape template=polymer-template rules=polymer-rules n=@ud]
  ^-  @ud
  (diff (snag 0 orig) (snag (dec (lent orig)) orig) (run-n-iterations n template rules))
::
++  parse-rules
  |=  l=(list @t)
  ^-  polymer-rules
  %-  malt
  %+  turn
    l
  |=  t=@t
  ^-  [polymer char]
  %+  rash
    t
  ;~  plug
    ;~  plug
      alf
      alf
    ==
    ;~  pfix
      (jest ' -> ')
      alf
    ==
  ==
::
++  parse-template
  |=  t=@t
  ^-  polymer-template
  =/  tap=tape  (trip t)
  =|  acc=polymer-template
  ?~  tap
    !!
  =/  cur=char  i.tap
  =/  tap=tape  t.tap
  |-
  ?~  tap
    acc
  =/  p=polymer  [cur i.tap]
  $(acc (~(put by acc) p +((~(gut by acc) p 0))), tap t.tap, cur i.tap)
--
:-  %say
|=  *
:-  %noun
=/  orig=tape  (trip (snag 0 puzzle-input))
=/  template=polymer-template  (parse-template (snag 0 puzzle-input))
=/  rules=polymer-rules  (parse-rules (slag 2 puzzle-input))
%:  solve
  orig
  template
  rules
  ::  part 1 is 10, part 2 is 40
  ::  10
  40
==
