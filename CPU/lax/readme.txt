
this directory contains tests to verify and examine how the RDY line (DMA)
affects the LAX #imm opcode.

in general it appears the timing of the side effects are stable, but the values
are not.

LAX #imm
--------

A = X = ((A | CONST) & IMM)

with N = IMM we get: A = X = (A | ?) & N

A       N           !A   N    
0 | ? & 0 = 0        1 & 0 = 0
1 | ? & 0 = 0        0 & 0 = 0
0 | ? & 1 = ?        1 & 1 = 1
1 | ? & 1 = 1        0 & 1 = 0

so when a bit in A is 0 and in N is 1, the result is unknown/unstable

((A ^ 0xff) & N) returns the affected unstable bits, ie operation is unstable 
if ((A ^ 0xff) & N) != 0

--------------------------------------------------------------------------------

lax.prg:

test lax #imm for side effects connected with the RDY line. 

for some combinations of A and IMM bit0 and/or bit4 (?) will drop off (turn 0?) 
when the RDY line changes state at the beginning of badline DMA (?)

interesting values will appear in the pattern where marked with dark(er) grey

lax-border.prg:

runs the same test in border with sprites, demonstrates the side effects are
there also.

interesting values will appear in the pattern where marked with dark(er) grey

lax-none.prg:

runs the same test in border with no sprites to show there are no more side 
effects.

--------------------------------------------------------------------------------

lax.prg and lax-border.prg are verified on my c64c (gpz)

note that the magic constant is being checked against the desirable properties 
outlined below in the code analysis from real world programs. 

THIS MEANS THE TEST WILL ALSO FAIL ON SOME REAL C64s.

the values after rA: and rX: in the bottom line should always be green (it will 
be green when all stable bits match what we expect them to be)

if the value after CON: is red, then the magic constant does not match the
desirable properties - and the test will fail. this does not actually mean that
ANE does not work as expected, but it means that it behaves in a way that will
make some or all of the analysed real world programs not work correctly.

For Emulation the best compromise between "proper emulation" and "making things
work" seems to be to use a "magic contant" of $EE in regular cycles, and $EE in
the RDY cycle. This will "break" the "Blackmail FLI" program, but "Wizball"
requires it, which seems to be a much more convincing reason.

--------------------------------------------------------------------------------
analysis of some real world programs
--------------------------------------------------------------------------------

Blackmail-FLI
-------------

20be  A6 6F       LDX $6F
20c0  A9 38       LDA #$38       ; $08,$18...$78 are used here
20c2  8D 18 D0    STA $D018
20c5  8E 11 D0    STX $D011
20c8  AB 00       LXA #$00       ; $0-$f is loaded as color
20ca  8F 21 D0    SAX $D021

for the displayer to work with all colors, bit 0,1,2 must be 1 -> constant 
$ef will work

Wizball
-------

The location in Wizball where LXA is executed is at b58b.

b589  A9 00       LDA #$00 
b58b  AB FF       LXA #$FF      ; A = X = (($00 | CONST) & $ff) = $EE
b58d  DF 97 FF    DCP $FF97,X   ; decrement mem (=$85), compare with akku (=$EE)
b590  60          RTS

$85 is used as a delay(?) counter at various places in the game, so $EE really
seems to be the one and only value to make it work correctly.
