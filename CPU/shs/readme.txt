test programs related to the undocumented opcode $9b (SHS/TAS)
--------------------------------------------------------------------------------

note: this opcode have appeared marked "unstable" on certain lists that
      circulated. this is not entirely true - it seems to be fully predictable,
      it's just a bit more complex than people thought when investigating it.

generally under "stable" conditions, the instruction works like

SP = A & X
addr = SP & M+1

stable conditions are when no character or sprite DMA is going on, traditionally
tests for these conditions (->lorenz) run in the border area with no sprites.

there are two unstable conditions, the first is when a DMA is going on while the
instruction executes (the CPU is halted by the VIC-II) then the & M+1 part drops
off and the instruction becomes

SP = A & X
addr = SP

the other unstable condition is when the addressing/indexing causes a page
boundary crossing, in that case the highbyte of the target address may become
equal to the value stored. this is usually avoided in code by keeping the index
in a suitable range

the exact technical cause of both instabilities is still a bit unclear, and they
can not be fully explained yet

(*) M+1 is the highbyte of the target address + 1, eg when the address is $1234
    then M+1 is $13

--------------------------------------------------------------------------------

shsabsy1.prg

checks the mostly used "stable" behaviour of this opcode

works in x64 and x64sc
--------------------------------------------------------------------------------

shsabsy2.prg

the second tests checks for the correct behaviour of the "unstable" part of
this opcode, in particular the case that the & M+1 drops off and the stored
value becomes A & X. this happens if the instruction is being interupted by
sprite DMA (?: TODO: exact description, accurate timings)

works in x64sc, fails in x64
--------------------------------------------------------------------------------

TODO: test for page boundary crossing bug