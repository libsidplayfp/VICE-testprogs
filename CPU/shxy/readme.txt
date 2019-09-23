test programs related to the undocumented opcodes $9c and $9e (SHX/SHY)
--------------------------------------------------------------------------------

note: these opcodes have appeared marked "unstable" on certain lists that
      circulated. this is not entirely true - it seems to be fully predictable,
      it's just a bit more complex than people thought when investigating it.

generally under "stable" conditions, the instruction works like

*addr = V & (H+1), where V is the register being stored, and H is the high byte of the address

stable conditions are when no character or sprite DMA is going on, traditionally
tests for these conditions (->lorenz) run in the border area with no sprites.


there are two conditions that lead to somewhat surprising behaviour.

the first is when the addressing/indexing causes a page boundary crossing.
in that case the high byte of the target address is ANDed with the value stored.

the second is when a DMA begins between the third and fourth cycle (the CPU is halted by
the VIC-II) then the & H+1 part drops off and the instruction becomes

*addr = V

Note that the DMA condition does not affect the address calculation;
effective upper address byte = (L+I<256) ? H : (H+1) & V
regardless of whether the value written is V or V & (H+1)

(where I is the index register, V the register being stored, and L the low
byte of the address operand)



the exact technical cause of both instabilities is still a bit unclear, and they
can not be fully explained yet

(*) H+1 is the highbyte of the target address + 1, eg when the address is $1234
    then H+1 is $13

--------------------------------------------------------------------------------

shxy1.prg shyx1.prg

checks the mostly used "stable" behaviour of these opcodes

works in x64 and x64sc

verified on:
- C64(old) with 6510 (gpz)
- C64C(new) with 8500 (gpz)
--------------------------------------------------------------------------------

shxy2.prg shyx2.prg

the second tests checks for the correct behaviour of the "unstable" part of
these opcodes, in particular the case that the & H+1 drops off and the value
becomes X/Y. this happens if the instruction is being interupted by sprite
DMA

works in x64sc, fails in x64

verified on:
- C64(old) with 6510 (gpz)
- C64C(new) with 8500 (gpz)
--------------------------------------------------------------------------------

shxy3.prg shyx3.prg

checks the timing of the above tested behaviour

the top dump is the reference data, the bottom shows the measured values

works in x64sc, fails in x64

verified on:
- C64(old) with 6510 (gpz)
- C64C(new) with 8500 (gpz)
--------------------------------------------------------------------------------

shxy4.prg shyx4.prg

checks the timing of the &H+1 drop-off when page boundary is crossed

works in x64sc (r30092), fails in x64

verified on:
- C64C(new) with 8500 (gpz)
--------------------------------------------------------------------------------

shx-test.prg

another test by ninja/the dreams. combination of &H+1 drop-off and page-boundary
crossing.

--------------------------------------------------------------------------------

shx-t2.prg

another test by ninja/the dreams. this tests the &H+1 drop-off caused by RDY.

1  enables the sprite -> DMA/RDY -> SHX puts 14 (light blue) into border
<- disables the sprite -> no DMA/RDY -> SHX writes elsewhere (black border)

--------------------------------------------------------------------------------

shxy5.prg shyx5.prg

checks the timing of the &(H+1) drop off relative to cycle stealing,
for both sprite and character DMA, when a page crossing is executed.

Each column is one cycle later execution of SHX/SHY
top two rows are
- value written to memory, 
- non-stolen cycles taken to execute

the next two rows are the reference data

The first '4' is when the instruction steals a cycle from a sprite DMA, the
second '4' is when it steals a cycle from charactor DMA.  In each case, one
cycle later, and it doesn't perform the &(H+1) on the written value

The ANDing of the value to be stored with (H+1) is dropped off iff the
instruction is executed one cycle later than it would need to execute in order
to steal a cycle from a sprite or character DMA, i.e. if it the instruction is
paused between the third and fourth cycles.

The address written to always has its high byte replaced with I & (H+1),
(where I is the register whose storage has been requested)
regardless of whether the &(H+1) is dropped from the computation of the value
to be stored.  In this instance, the destination address is always $0614.


works in x64sc (r37007)

verified on:
- C64(old) with 6510 (shrydar)
- C64C(new) with 8500 (gpz)
--------------------------------------------------------------------------------

TODO: try finding a machine where page boundary crossing behaviour is
anything other than the behaviour documented above.

