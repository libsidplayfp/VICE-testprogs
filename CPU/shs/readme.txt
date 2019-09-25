test programs related to the undocumented opcode $9b (SHS/TAS)
--------------------------------------------------------------------------------

note: this opcode have appeared marked "unstable" on certain lists that
      circulated. this is not entirely true - it seems to be fully predictable,
      it's just a bit more complex than people thought when investigating it.

generally under "stable" conditions, the instruction works like

SP = A & X
addr = SP & (H+1)  (*)

stable conditions are when no character or sprite DMA is going on, traditionally
tests for these conditions (->lorenz) run in the border area with no sprites.

there are two conditions that lead to somewhat surprising behaviour. the first
is when a DMA is going on while the instruction executes (the CPU is halted by
the VIC-II) then the & H+1 part drops off and the instruction becomes

SP = A & X
addr = SP

the other condition that was once deemed to lead to unstable behavior is when the
addressing/indexing causes a page boundary crossing, in that case the highbyte
of the target address is ANDed with the value to be stored (cf test 5).

this can be avoided in code by keeping the index in a suitable range.

note that the target address is not affected by the DMA condition; even if the
& (H+1) is dropped from computation of the value to be stored, it is still
preformed in the computation of the high byte of the the target address.


the exact technical cause of both behaviours is still a bit unclear, and they
can not be fully explained yet

(*) H+1 is the highbyte of the target address + 1, eg when the address is $1234
    then H+1 is $13

--------------------------------------------------------------------------------

shsabsy1.prg

checks the mostly used "stable" behaviour of this opcode

works in x64 and x64sc

verified on:
- C64(old) with 6510 (gpz)
- C64C(new) with 8500 (gpz)
--------------------------------------------------------------------------------

shsabsy2.prg

the second tests checks for the correct behaviour of the "unstable" part of
this opcode, in particular the case that the & (H+1) drops off and the stored
value becomes A & X. this happens if the instruction is being interupted by
sprite DMA

works in x64sc, fails in x64

verified on:
- C64(old) with 6510 (gpz)
- C64C(new) with 8500 (gpz)
--------------------------------------------------------------------------------

shsabsy3.prg

checks the timing of the above tested behaviour

the top dump is the reference data, in the middle are the measured values (what
is stored to memory) and the bottom shows the stack pointer

works in x64sc (r30092), fails in x64

verified on:
- C64(old) with 6510 (gpz)
- C64C(new) with 8500 (gpz)
--------------------------------------------------------------------------------

shsabsy4.prg

checks the timing of the above tested behaviour relative to cycle stealing,
for both sprite and character DMA

Each column is one cycle later execution of SHS
top three rows are
- value of SP after instruction,
- value written to memory, 
- non-stolen cycles taken to execute
next three rows are the reference data

The first '4' is when it steals a cycle from a sprite DMA, the second '4' is
when it steals a cycle from char DMA.  In each case, one cycle later, and it
doesn't perform the & (H+1) on the written value

The ANDing of the value to be stored with (H+1) is dropped off if the
instruction is executed one cycle later than it would need to execute in order
to steal a cycle from a sprite or character DMA, i.e. if it is paused
between the third and fourth cycles.


works in x64sc (r37007)

verified on:
- C64(old) with 6510 (shrydar)
- C64C(new) with 8500 (gpz)
--------------------------------------------------------------------------------

shsabsy5.prg

checks the timing of the above tested behaviour relative to cycle stealing,
for both sprite and character DMA, when a page crossing is executed

Each column is one cycle later execution of SHS
top three rows are
- value of SP after instruction,
- value written to memory, 
- non-stolen cycles taken to execute
next three rows are the reference data

The first '4' is when it steals a cycle from a sprite DMA, the second '4' is
when it steals a cycle from char DMA.  In each case, one cycle later, and it
doesn't perform the &(H+1) on the written value

The ANDing of the value to be stored with (H+1) is dropped off if the
instruction is executed one cycle later than it would need to execute in order
to steal a cycle from a sprite or character DMA, i.e. if it is paused
between the third and fourth cycles.

The address written to always has its high byte replaced with A & X & (H+1),
regardless of whether the & (H+1) is dropped from the computation of the value
to be stored.  In this instance, the destination address is always $0614.


works in x64sc (r37007)

verified on:
- C64(old) with 6510 (shrydar)
- C64C(new) with 8500 (gpz)
--------------------------------------------------------------------------------
