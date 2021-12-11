/*  puzzle-input  %txt  /lib/advent-2021/10/input/txt
=>
|%
++  is-opening-char
  |=  c=char
  ^-  flag
  ?|  =(c '(')
      =(c '[')
      =(c '{')
      =(c '<')
  ==
++  get-closing-char
  =>
  |%
  ++  closing-chars
    %-  malt
    :~  ['[' ']']
        ['{' '}']
        ['(' ')']
        ['<' '>']
    ==
  --
  |=  c=char
  ^-  char
  (~(got by closing-chars) c)
::  tests if a line is corrupt or incomplete.
::  If it's corrupt, returns the unit of the first
::  illegal character. If it's incomplete, the list
::  returned is the current stack of open characters.
++  parse-line
  |=  l=tape
  ^-  [(unit char) (list char)]
  =|  stack=(list char)
  |-
  ?~  l
    [~ stack]
  ?:  (is-opening-char i.l)
    $(l t.l, stack [i.l stack])
  ::  now we have a closing char
  ?~  stack
    ::  based on spec it's unclear if this can happen (having a closing
    ::  char before any opening chars) but might as well handle it.
    [(some i.l) stack]
  ?:  =(i.l (get-closing-char i.stack))
    $(l t.l, stack t.stack)
  [(some i.l) stack]
::
++  part-one
  =>
  |%
  ++  score-char
    |=  c=char
    ^-  @ud
    ?:  =(c ')')
      3
    ?:  =(c ']')
      57
    ?:  =(c '}')
      1.197
    ?:  =(c '>')
      25.137
    !!
  --
  |=  lines=wall
  ^-  @ud
  %+  reel
    %+  murn
      lines
    |=(l=tape (head (parse-line l)))
  |=([c=char acc=@ud] (add acc (score-char c)))
::  for part 2 we want to deal with incomplete lines
++  part-two
  =>
  |%
  ++  score-char
    |=  c=char
    ?:  =(c ')')
      1
    ?:  =(c ']')
      2
    ?:  =(c '}')
      3
    ?:  =(c '>')
      4
    !!
  --
  |=  lines=wall
  ^-  @ud
  =/  scores=(list @ud)
    %+  turn
      %+  murn
        lines
      |=  l=tape
      ^-  (unit (list char))
      =/  res  (parse-line l)
      ::  we only want non-empty lists when
      ::  the head is unit (line isn't corrupt)
      ?~  -.res
        ?~  +.res
          ~
        (some +.res)
      ~
    |=  s=(list char)
    ^-  @ud
    (roll s |=([cur=char acc=@ud] (add (mul 5 acc) (score-char (get-closing-char cur)))))
  %+  snag
    :: always an odd number of scores so this will always be the
    :: middle element
    (div (lent scores) 2)
  %+  sort
    scores
  gth
--
:-  %say
|=  *
:-  %noun
::%-  part-one
%-  part-two
%+  turn
  puzzle-input
trip
