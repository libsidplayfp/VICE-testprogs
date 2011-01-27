
cia-timer
=========

- four tests using timers of CIA1 and check IRC near the timer underrun
- tests visible on the left side use timer A, tests on the right use timer B
- for upper tests IRQ is disabled, only the IRC is read and displayed
- lower tests enable the timer interrupt and IRC is checked even inside the IRQ handler


Results for real boxes
======================

C64C Rubi (2x6526A):

.......@abcdefgh    .......@abcdefgh
@@@@@@@@aaaaaaa@    @@@@@@@@bbbbbbb@
aaaaaaaaa@@@@@@@    bbbbbbbbb@@@@@@@

.......@abcdefgh    .......@abcdefgh
@@@@@@@@@@@@@@@@    @@@@@@@@@@@@@@@@
@@@@AAAAA@@@@@@@    @@@@BBBBB@@@@@@@
AAAA@@@@ AAAA       BBBB@@@@ BBBB   
kkkkgggg bbbb       kkkkgggg bbbb


