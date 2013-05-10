dma delay tests
---------------

for the basic theory refer to vic article "3.14.6. DMA DELAY"

test1 and test2 implements the first method, which is initializing YSCROLL to non
zero before line $30 so there is no badline condition in line $30. then mid-line
set YSCROLL to zero and back to non zero some cycles later. test1 will do the
later using inc/dec and test2 uses stx/sty.

test3 implements the second method, which is initializing YSCROLL to zero and
clearing DEN before line $30, so there would be a badline condition, but the
badline will not start unless DEN was set for at least one cycle in line $30 -
which is then done after the variable delay.

each test shows a hex pattern in the first two screen rows ($0400-$044f). you
should see "89ABCDEF0123456789ABCDEF0123456789ABCDEF" in the top row and
"0123456789ABCDEF" in the bottom right corner of the screen when the test starts
up. some color bars are shown behind to demonstrate that the timing is stable.

the two white numbers show the following:

- the delay before first initialization of $d011 (if it is initialized too late,
the effect will not work. in test3 at a certain point the screen will switch off)
this delay can be changed by pressing "1" and "2"

- the delay before forcing the badline to start, adding one cycle to the default
scrolls the screen by one character (this is the delay you would usually alter 
to make actual use of dma delay). this can be changed by pressing "A" and "S"

--------------------------------------------------------------------------------

the skeleton for these tests was shamelessly copied from this example at
codebase64: 

http://codebase64.org/doku.php?id=base:horizontal_screen_positioning_hsp