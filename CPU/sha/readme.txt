test programs related to the undocumented opcodes $93 and $9f (SHA/AHX)
--------------------------------------------------------------------------------

note: these opcodes have appeared marked "unstable" on certain lists that
      circulated. this is not entirely true - it seems to be fully predictable,
      it's just a bit more complex than people thought when investigating it.

generally under "stable" conditions, the instruction works like

addr = A & X & M+1

stable conditions are when no character or sprite DMA is going on, traditionally
tests for these conditions (->lorenz) run in the border area with no sprites.

there are two unstable conditions, the first is when a DMA is going on while the
instruction executes (the CPU is halted by the VIC-II) then the & M+1 part drops
off and the instruction becomes

addr = A & X

the other unstable condition is when the addressing/indexing causes a page
boundary crossing, in that case the highbyte of the target address may become
equal to the value stored. this is usually avoided in code by keeping the index
in a suitable range

the exact technical cause of both instabilities is still a bit unclear, and they
can not be fully explained yet

(*) M+1 is the highbyte of the target address + 1, eg when the address is $1234
    then M+1 is $13

--------------------------------------------------------------------------------

shaabsy1.prg shazpy1.prg

checks the mostly used "stable" behaviour of these opcodes

works in x64 and x64sc

verified on:
- C64(old) with 6510 (gpz)
- C64C(new) with 8500 (gpz)
--------------------------------------------------------------------------------

shaabsy2.prg shazpy2.prg

the second tests checks for the correct behaviour of the "unstable" part of
these opcodes, in particular the case that the & M+1 drops off and the value
becomes A & X. this happens if the instruction is being interupted by sprite
DMA (?: TODO: exact description, accurate timings)

works in x64sc, fails in x64

verified on:
- C64(old) with 6510 (gpz)
- C64C(new) with 8500 (gpz)
--------------------------------------------------------------------------------

shaabsy3.prg shazpy3.prg

checks the timing of the above tested behaviour

the top dump is the reference data, the bottom shows the measured values

works in x64sc (r30092), fails in x64

verified on:
- C64(old) with 6510 (gpz)
- C64C(new) with 8500 (gpz)
--------------------------------------------------------------------------------

shaabsy4.prg shazpy4.prg

checks the timing of the &(H+1) drop off relative to cycle stealing,
for both sprite and character DMA

Each column is one cycle later execution of SHA
top two rows are
- value written to memory, 
- non-stolen cycles taken to execute
next two rows are the reference data

The first '4' is when it steals a cycle from a sprite DMA, the second '4' is
when it steals a cycle from char DMA.  In each case, one cycle later, and it
doesn't perform the &(H+1) on the written value

The ANDing of the value to be stored with (H+1) is dropped off if the
instruction is executed one cycle later than it would need to execute in order
to steal a cycle from a sprite or character DMA, i.e. if it is paused
between the third last and second last cycles.


works in x64sc (r37007)

verified on:
- C64(old) with 6510 (shrydar)
- C64C(new) with 8500 (gpz)
--------------------------------------------------------------------------------

shaabsy5.prg shazpy5.prg

checks the timing of the &(H+1) drop off relative to cycle stealing,
for both sprite and character DMA, when a page crossing is executed.

Also tests that the destination address has it's high byte ANDed with
A&X regardles of when/whether the instruction is interrupted.

Each column is one cycle later execution of SHA
top two rows are
- value written to memory, 
- non-stolen cycles taken to execute
next two rows are the reference data

The first '4' is when it steals a cycle from a sprite DMA, the second '4' is
when it steals a cycle from char DMA.  In each case, one cycle later, and it
doesn't perform the &(H+1) on the written value

The ANDing of the value to be stored with (H+1) is dropped off if the
instruction is executed one cycle later than it would need to execute in order
to steal a cycle from a sprite or character DMA, i.e. if it is paused
between the third last and second last cycles.

The address written to always has its high byte replaced with A & X & (H+1),
regardless of whether the & (H+1) is dropped from the computation of the value
to be stored.  In this instance, the destination address is always $0614.


works in x64sc (r37007)

verified on:
- C64(old) with 6510 (shrydar)
- C64C(new) with 8500 (gpz)
--------------------------------------------------------------------------------
