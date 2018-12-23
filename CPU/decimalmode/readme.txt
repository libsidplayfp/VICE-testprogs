scanner.prg:

this program executes various instructions both with D=0 and D=1 and compares
the result. results in the first page of the screen, green means the instruction
has no decimal mode, red means there was a difference and the instruction has
a decimal mode.

when all supported instructions have been tested the result is compared against
a reference, green border means success.

--------------------------------------------------------------------------------

adc00.prg adc01.prg adc02.prg adc10.prg adc11.prg adc12.prg:
sbc00.prg sbc01.prg sbc02.prg sbc10.prg sbc11.prg sbc12.prg:
sbcEB00.prg sbcEB01.prg sbcEB02.prg sbcEB10.prg sbcEB11.prg sbcEB12.prg:
arr00.prg arr01.prg arr02.prg arr10.prg arr11.prg arr12.prg:
isc00.prg isc01.prg isc02.prg isc03.prg isc10.prg isc11.prg isc12.prg isc13.prg:
rra00.prg rra01.prg rra02.prg rra03.prg rra10.prg rra11.prg rra12.prg rra13.prg:

various programs which test the full range of all input parameters for all
instructions that have a decimal mode. green border means success.

decimalmode.c contains the code to generate the reference data
