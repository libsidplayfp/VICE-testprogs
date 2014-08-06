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
--------------------------------------------------------------------------------

shaabsy2.prg shazpy2.prg

the second tests checks for the correct behaviour of the "unstable" part of
these opcodes, in particular the case that the & M+1 drops off and the value
becomes A & X. this happens if the instruction is being interupted by sprite
DMA (?: TODO: exact description, accurate timings)

works in x64sc, fails in x64
--------------------------------------------------------------------------------

shaabsy3.prg shazpy3.prg

checks the timing of the above tested behaviour

the top dump is the reference data, the bottom shows the measured values

fails in x64sc, fails in x64
--------------------------------------------------------------------------------

TODO: test for page boundary crossing bug
