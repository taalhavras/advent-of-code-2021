/*  puzzle-input  %txt  /lib/advent-2021/8/input/txt
=>
|%
::  parse into all 10 numbers and then the 4 digit output
++  parse-single-input
  |=  l=@t
  ^-  [wall wall]
  %+  rash
    l
  ;~  plug
    (more ace (plus alf))
    ;~(pfix ;~(plug ace bar ace) (more ace (plus alf)))
  ==
::  only need to count the # of 1, 4, 7, 8 in the output
++  part-one
  |=  l=(list [wall wall])
  ^-  @ud
  %+  roll
    l
  |=  [[wall output=wall] acc=@ud]
  ^-  @ud
  %+  add
    acc
  %-  lent
  %+  skim
    output
  |=  elt=tape
  ^-  flag
  =/  n  (lent elt)
  ?|  =(n 2) :: digit 1
      =(n 4) :: digit 4
      =(n 3) :: digit 7
      =(n 7) :: digit 8
  ==
::  part 2 here - need full decoding
++  part-two
  |=  l=(list [wall wall])
  ^-  @ud
  (reel (turn l fully-decode) add)
++  fully-decode
  =<
  |=  [all-digits=wall output=wall]
  ^-  @ud
  =/  mapping=(map (set char) @ud)  (build-mapping (turn all-digits silt))
  %+  roll
    output
  |=  [cur=tape acc=@ud]
  ^-  @ud
  %+  add
    (mul 10 acc)
  (~(got by mapping) (silt cur))
  |%
  ::  build mapping between the scrambled inputs and the real numbers
  ++  build-mapping
    |=  digits=(list (set char))
    ^-  (map (set char) @ud)
    ::  to start we can only identify 1, 4, 7, 8
    ::  I can then calculate 4 - "acf" (or acf) to get "bd"
    ::  with "bd" I can identify 5 - it's the only 5 digit that
    ::  contains "bd".
    ::  now we can identify 1, 4, 5, 7, 8
    ::  2 and 3 are the remaining 5 digit numbers. only 3 contains
    ::  "acf" though, so we can identify via that.
    ::  we can now identify 1, 2, 3, 4, 5, 7, 8 - only 6, 9, and 0 remain.
    ::  0 does NOT contain 5 - "abdfg" while 6 and 9 do. thus we
    ::  can identify it.
    ::  between 6 and 9, only 9 contains 7 ("acf") so use that.
    ::  and we're done!
    ::
    ::  Since the inputs are scrambled we must not write any string
    ::  literals in the body of this function.
    =/  one=(set char)  (find-first digits (size-is 2))
    =/  four=(set char)  (find-first digits (size-is 4))
    =/  seven=(set char)  (find-first digits (size-is 3))
    =/  eight=(set char)  (find-first digits (size-is 7))
    =/  bd=(set char)  (~(dif in four) one)
    =/  five=(set char)
      (find-first digits |=(a=(set char) &((contains-all a bd) =(~(wyt in a) 5))))
    =/  three=(set char)
      %+  find-first
        digits
      |=  a=(set char)
      ^-  flag
      &(=(~(wyt in a) 5) (contains-all a seven))
    =/  two=(set char)
      %+  find-first
        digits
      |=  a=(set char)
      ^-  flag
      &(=(~(wyt in a) 5) !(contains-all a seven) !=(a five))
    =/  zero=(set char)
      %+  find-first
        digits
      |=  a=(set char)
      ^-  flag
      &(=(~(wyt in a) 6) !(contains-all a five))
    =/  six=(set char)
      %+  find-first
        digits
      |=  a=(set char)
      ^-  flag
      &(=(~(wyt in a) 6) (contains-all a five) !(contains-all a seven))
    =/  nine=(set char)
      %+  find-first
        digits
      |=  a=(set char)
      ^-  flag
      &(=(~(wyt in a) 6) (contains-all a five) (contains-all a seven))
    %-  malt
    ^-  (list [(set char) @ud])
    :~  [one 1]
        [two 2]
        [three 3]
        [four 4]
        [five 5]
        [six 6]
        [seven 7]
        [eight 8]
        [nine 9]
        [zero 0]
    ==
  ::  manual curry because why not
  ++  size-is
    |=  b=@ud
    ^-  $-((set char) flag)
    |=  a=(set char)
    ^-  flag
    =(b ~(wyt in a))
  ::
  ++  contains-all
    |=  [a=(set char) targets=(set char)]
    ^-  flag
    =(targets (~(int in a) targets))
  ::
  ++  find-first
    |=  [digits=(list (set char)) f=$-((set char) flag)]
    ^-  (set char)
    ?~  digits
      !!
    ?:  (f i.digits)
      i.digits
    $(digits t.digits)
  --
--
:-  %say
|=  *
:-  %noun
::%-  part-one
%-  part-two
%+  turn
  puzzle-input
parse-single-input
