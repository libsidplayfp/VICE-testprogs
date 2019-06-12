
this directory contains tests to verify and examine how the RDY line (DMA)
affects the ANE #imm opcode.

in general it appears the timing of the side effects are stable, but the values
are not.

ANE #imm
--------

A = ((A | CONST) & X & IMM)
 
with N = X & IMM we get: A = (A | ?) & N

A       N           !A   N    
0 | ? & 0 = 0        1 & 0 = 0
1 | ? & 0 = 0        0 & 0 = 0
0 | ? & 1 = ?        1 & 1 = 1
1 | ? & 1 = 1        0 & 1 = 0

so when a bit in A is 0 and in N is 1, the result is unknown/unstable

((A ^ 0xff) & N) returns the affected unstable bits, ie operation is unstable 
if ((A ^ 0xff) & N) != 0

--------------------------------------------------------------------------------

ane.prg:

test ane #imm for side effects connected with the RDY line. 

for some combinations of A and IMM bit0 and/or bit4 (?) will drop off (turn 0?) 
when the RDY line changes state at the beginning of badline DMA (?)

interesting values will appear in the pattern where marked with dark(er) grey

ane-border.prg:

runs the same test in border with sprites, demonstrates the side effects are
there also.

interesting values will appear in the pattern where marked with dark(er) grey

ane-none.prg:

runs the same test in border with no sprites to show there are no more side 
effects.

--------------------------------------------------------------------------------

ane.prg and ane-border.prg are verified on my c64c (gpz) 

note that the magic constant is being checked against the desirable properties 
outlined below in the code analysis from real world programs. 

THIS MEANS THE TEST WILL ALSO FAIL ON SOME REAL C64s.

the value after RES: in the bottom line should always be green (it will be green
when all stable bits match what we expect them to be)

if the value after CON: is red, then the magic constant does not match the
desirable properties - and the test will fail. this does not actually mean that
ANE does not work as expected, but it means that it behaves in a way that will
make some or all of the analysed real world programs not work correctly.

For Emulation the best compromise between "proper emulation" and "making things
work" seems to be to use a "magic contant" of $EF in regular cycles, and $EE in
the RDY cycle.

--------------------------------------------------------------------------------
analysis of some real world programs
--------------------------------------------------------------------------------

spectipede - original tape ("burner" loader)
--------------------------------------------

02a7  64 AE       NOOP $AE
02a9  4E BF 02    LSR $02BF
02ac  14 CC       NOOP $CC,X
02ae  A2 FF       LDX #$FF
02b0  8B 51       ANE #$51
02b2  87 FB       SAX $FB
02b4  04 4C       NOOP $4C
02b6  8B E1       ANE #$E1
02b8  54 CC       NOOP $CC,X
02ba  8F 28 03    SAX $0328
02bd  AF 3C 03    LAX $033C
02c0  87 FC       SAX $FC
02c2  A0 FF       LDY #$FF
02c4  B3 FB       LAX ($FB),Y
02c6  54 20       NOOP $20,X
02c8  4D 08 03    EOR $0308
02cb  80 CD       NOOP #$CD
02cd  4D 17 03    EOR $0317
02d0  89 20       NOOP #$20
02d2  91 FB       STA ($FB),Y
02d4  14 CC       NOOP $CC,X

02b0 ANE #$51 ; A=$00 X=$ff -> A=$51 (unstable)
02b6 ANE #$e1 ; A=$51 X=$ff -> A=$e1 (unstable)

this code works correctly with ANE magic constant "$FF" but not with "$EE"

for the game to load, the high nybble of the constant must be $4,$5,$e or $f and
bit 0 must be 1, bits 3,2,1 are "don't care". -> constant $ef will work


rambo II - original tape (ocean/imagine loader)
-----------------------------------------------

41f6  A2 FA       LDX #$FA
41f8  A9 F5       LDA #$F5
41fa  9B 00 01    SHS $0100,Y
41fd  8B C5       ANE #$C5
41ff  48          PHA
4200  8A          TXA
4201  18          CLC
4202  69 0B       ADC #$0B
4204  48          PHA
4205  60          RTS

41fd ANE #$c5 ; A=$c0 X=$fa -> A=$c0 (this is stable)

comic bakery - original tape (ocean/imagine loader)
---------------------------------------------------

423d  A0 00       LDY #$00
423f  A2 FA       LDX #$FA
4241  A9 F5       LDA #$F5
4243  9B 00 01    SHS $0100,Y
4246  8B C5       ANE #$C5
4248  18          CLC
4249  69 31       ADC #$31
424b  48          PHA
424c  8A          TXA
424d  18          CLC
424e  69 6C       ADC #$6C
4250  48          PHA
4251  60          RTS

4246 ANE #$c5 ; A=$c0 X=$fa -> A=$c0 (this is stable)

yie ar kung fu - original tape (euro) (ocean/imagine loader)
------------------------------------------------------------

-> disable drives and printers before loading

.C:4262  A0 00       LDY #$00
.C:4264  A2 FA       LDX #$FA
.C:4266  A9 F5       LDA #$F5
.C:4268  9B 00 01    SHS $0100,Y
.C:426b  8B C5       ANE #$C5
.C:426d  38          SEC
.C:426e  E9 BD       SBC #$BD
.C:4270  48          PHA
.C:4271  8A          TXA
.C:4272  18          CLC
.C:4273  69 05       ADC #$05
.C:4275  48          PHA
.C:4276  60          RTS

426b ANE #$c5 ; A=$f5 X=$fa -> A=$c0 (this is stable)

turrican 3 v1.1
---------------

ta_movecode_1&2:line 641

6379  AD 29 63    LDA $6329 ; initialized to 0
637c  49 01       EOR #$01
637e  8D 29 63    STA $6329
6381  AE 2A 63    LDX $632A ; initialized to 0
6384  E8          INX
6385  8B 03       ANE #$03  ; A will be 0 or 1, X will be 0..3
6387  8D 2A 63    STA $632A ; result is 0..3, all bits instable

if the intention was to do A = A & X & 3, then bit 0 and bit 1 being 0 in the 
magic constant is needed for it to work correctly
(more likely) if the intention was basically just A = X & 3 (and save a txa) 
then bit 0 and bit 1 in the magic constant must be 1 for it to work correctly.

ta_scrolling_1&2:line 1650

a bunch of sequences like this:

lax ($10),y     ; load A and X
and #$0f
ora #$b0        ; 10110000 bit7,5,4 are 1 in A
sta $11
xaa #$f0        ; A = (A | ?) & X & $f0     bit 6 is unstable
ora ystep
sta $10
lax ($12),y

assuming the intention was to do A = X & $f0, bit 6 must be 1 in the magic 
constant

-> we want a magic constant with at least these 1s: 01000011 ($ef will work)
