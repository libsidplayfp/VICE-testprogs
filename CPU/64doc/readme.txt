this directory contains the test programs that were originally published in
the "64doc" article.

The following is a slightly edited copy of the relevant part(s) of said article, 
including the original uuencoded programs at the end.

WARNING: a couple things from this article are not entirely correct. for 
learning how those illegal opcodes actually work in detail, use other more
recent documentation.

--------------------------------------------------------------------------------

$CB  SBX   X <- (A & X) - Immediate

The 'SBX' ($CB) may seem to be very complex operation, even though it is a 
combination of the subtraction of accumulator and parameter, as in the 'CMP' 
instruction, and the command 'DEX'. As a result, both A and X are connected to 
ALU but only the subtraction takes place. Since the comparison logic was used, 
the result of subtraction should be normally ignored, but the 'DEX' now happily 
stores to X the value of (A & X) - Immediate.  That is why this instruction does 
not have any decimal mode, and it does not affect the V flag. Also Carry flag 
will be ignored in the subtraction but set according to the result.

vsbx.prg:
sbx.prg:
---------

These test programs show if your machine is compatible with ours regarding the 
opcode $CB. The first test, vsbx, proves that SBX does not affect the V flag. 
The latter one, sbx, proves the rest of our theory. The vsbx test tests 33554432 
SBX combinations (16777216 different A, X and Immediate combinations, and two 
different V flag states), and the sbx test doubles that amount (16777216*4 D and 
C flag combinations). Both tests have run successfully on a C64 and a Vic20.
They ought to run on C16, +4 and the PET series as well. The tests stop with 
BRK, if the opcode $CB does not work as expected. Successful operation ends in 
RTS. As the tests are very slow, they print dots on the screen while running so 
that you know that the machine has not jammed. On computers running at 1 MHz, 
the first test prints approximately one dot every four seconds and a total of 
2048 dots, whereas the second one prints half that amount, one dot every seven
seconds.

If the tests fail on your machine, please let us know your processor's part 
number and revision. If possible, save the executable (after it has stopped with 
BRK) under another name and send it to us so that we know at which stage the 
program stopped.

sbx-c100.prg:
-------------

The following program is a Commodore 64 executable that Marko Makela developed 
when trying to find out how the V flag is affected by SBX. (It was believed that 
the SBX affects the flag in a weird way, and this program shows how SBX sets the 
flag differently from SBC.)  You may find the subroutine at $C150 useful when 
researching other undocumented instructions' flags. Run the program in a machine
language monitor, as it makes use of the BRK instruction. The result tables will 
be written on pages $C2 and $C3.

Other undocumented instructions usually cause two preceding opcodes being 
executed. However 'NOP' seems to completely disappear from 'SBC' code $EB.

The most difficult to comprehend are the rest of the instructions located on the 
'$0B' line.

All the instructions located at the positive (left) side of this line should 
rotate either memory or the accumulator, but the addressing mode turns out to be 
immediate! No problem. Just read the operand, let it be ANDed with the 
accumulator and finally use accumulator addressing mode for the instructions 
above them.

--------------------------------------------------------------------------------

RELIGION_MODE_ON
/* This part of the document is not accurate.  You can
   read it as a fairy tale, but do not count on it when
   performing your own measurements. */

The rest two instructions on the same line, called 'ANE' and 'LXA' ($8B and $AB 
respectively) often give quite unpredictable results. However, the most usual 
operation is to store ((A | #$ee) & X & #$nn) to accumulator. Note that this 
does not work reliably in a real 64! In the Commodore 128 the opcode $8B uses 
values 8C, CC, EE, and occasionally 0C and 8E for the OR instead of EE,EF,FE and 
FF used in the C64. With a C128 running at 2 MHz #$EE is always used.  Opcode 
$AB does not cause this OR taking place on 8502 while 6510 always performs it. 
Note that this behaviour depends on processor and/or video chip revision.

Let's take a closer look at $8B (6510).

A <- X & D & (A | VAL)

where VAL comes from this table:

X high   D high  D low   VAL
even     even    ---    $EE (1)
even     odd     ---    $EE
odd      even    ---    $EE
odd      odd      0     $EE
odd      odd     not 0  $FE (2)

(1) If the bottom 2 bits of A are both 1, then the LSB of the result may be 0. 
    The values of X and D are different every time I run the test. This appears 
    to be very rare.
(2) VAL is $FE most of the time. Sometimes it is $EE - it seems to be random,
    not related to any of the data. This is much more common than (1).

In decimal mode, VAL is usually $FE.

Two different functions have been discovered for LAX, opcode $AB. One is 
A = X = ANE (see above) and the other, encountered with 6510 and 8502, is less 
complicated A = X = (A & #byte). However, according to what is reported, the 
version altering only the lowest bits of each nybble seems to be more common.

What happens, is that $AB loads a value into both A and X, ANDing the low bit of 
each nybble with the corresponding bit of the old A. However, there are 
exceptions. Sometimes the low bit is cleared even when A contains a '1', and 
sometimes other bits are cleared. The exceptions seem random (they change every 
time I run the test). Oops - that was in decimal mode. Much the same with D=0.

What causes the randomness?  Probably it is that it is marginal logic levels - 
when too much wired-anding goes on, some of the signals get very close to the 
threshold. Perhaps we're seeing some of them step over it. The low bit of each 
nybble is special, since it has to cope with carry differently (remember decimal 
mode). We never see a '0' turn into a '1'.

Since these instructions are unpredictable, they should not be used.

--------------------------------------------------------------------------------

There is still very strange instruction left, the one named SHA/X/Y, which is 
the only one with only indexed addressing modes. Actually, the commands 'SHA', 
'SHX' and 'SHY' are generated by the indexing algorithm.

While using indexed addressing, effective address for page boundary crossing is 
calculated as soon as possible so it does not slow down operation. As a result, 
in the case of SHA/X/Y, the address and data are processed at the same time 
making AND between them to take place. Thus, the value to be stored by SAX, for 
example, is in fact (A & X & (ADDR_HI + 1)).  On page boundary crossing the same 
value is copied also to high byte of the effective address.

RELIGION_MODE_OFF

--------------------------------------------------------------------------------
Decimal mode in NMOS 6500 series
--------------------------------------------------------------------------------

Most sources claim that the NMOS 6500 series sets the N, V and Z flags 
unpredictably when performing addition or subtraction in decimal mode. Of 
course, this is not true. While testing how the flags are set, I also wanted to 
see what happens if you use illegal BCD values.

ADC works in Decimal mode in a quite complicated way. It is amazing how it can 
do that all in a single cycle. Here's a C code version of the instruction:

 [ Warning: this code is NOT accurate. ]

        unsigned
           A,  /* Accumulator */
           AL, /* low nybble of accumulator */
           AH, /* high nybble of accumulator */

           C,  /* Carry flag */
           Z,  /* Zero flag */
           V,  /* oVerflow flag */
           N,  /* Negative flag */

           s;  /* value to be added to Accumulator */

        AL = (A & 15) + (s & 15) + C;         /* Calculate the lower nybble. */

        AH = (A >> 4) + (s >> 4) + (AL > 15); /* Calculate the upper nybble. */


        Z = ((A + s + C) & 255 != 0);         /* Zero flag is set just
                                                 like in Binary mode. */

        if (AL > 9) AL += 6;                  /* BCD fixup for lower nybble. */

        /* Negative and Overflow flags are set with the same logic than in
           Binary mode, but after fixing the lower nybble. */

        N = (AH & 8 != 0);
        V = ((AH << 4) ^ A) & 128 && !((A ^ s) & 128);

        if (AH > 9) AH += 6;                  /* BCD fixup for upper nybble. */

        /* Carry is the only flag set after fixing the result. */

        C = (AH > 15);
        A = ((AH << 4) | (AL & 15)) & 255;


The C flag is set as the quiche eaters expect, but the N and V flags are set 
after fixing the lower nybble but before fixing the upper one. They use the same 
logic than binary mode ADC. The Z flag is set before any BCD fixup, so the D 
flag does not have any influence on it.

dadc.prg:       

Proof: The following test program tests all 131072 ADC combinations in
       Decimal mode, and aborts with BRK if anything breaks this theory.
       If everything goes well, it ends in RTS.

                                Decimal Mode
         AC  +1 +2 +3 +4 +5 +6 +7 +8 +9 +a +b +c +d +e +f +10 +11

         59  60 61 62 63 64 65 66 67 68 69 6a 6b 6c 6d 6e  69 70
         5a  61 62 63 64 65 66 67 68 69 6a 6b 6c 6d 6e 6f  70 71
         5b  62 63 64 65 66 67 68 69 6a 6b 6c 6d 6e 6f 60  71 72
         5c  62 64 65 66 67 68 69 6a 6b 6c 6d 6e 6f 60 61  72 73
         5d  64 65 66 67 68 69 6a 6b 6c 6d 6e 6f 60 61 62  73 74
         5e  65 66 67 68 69 6a 6b 6c 6d 6e 6f 60 61 62 63  74 75
         5f  66 67 68 69 6a 6b 6c 6d 6e 6f 60 61 62 63 64  75 76
         60  61 62 63 64 65 66 67 68 69 70 71 72 73 74 75  70 71

                        Table 1: Sample results
     The triangular area (5b+f, 5f+b, 5f+f) with significantly smaller
     results is due to the fact that Carry cannot reach value of "2".


All programs in this chapter have been successfully tested on a Vic20 and a 
Commodore 64 and a Commodore 128D in C64 mode. They should run on C16, +4 and on 
the PET series as well. If not, please report the problem to Marko Makela. Each 
test in this chapter should run in less than a minute at 1 MHz.

dsbc-cmp-flags.prg:
-------------------

SBC is much easier. Just like CMP, its flags are not affected by the D flag.

The only difference in SBC's operation in decimal mode from binary mode
is the result-fixup:

        unsigned
           A,  /* Accumulator */
           AL, /* low nybble of accumulator */
           AH, /* high nybble of accumulator */

           C,  /* Carry flag */
           Z,  /* Zero flag */
           V,  /* oVerflow flag */
           N,  /* Negative flag */

           s;  /* value to be added to Accumulator */

        AL = (A & 15) - (s & 15) - !C;        /* Calculate the lower nybble. */

        if (AL & 16) AL -= 6;                 /* BCD fixup for lower nybble. */

        AH = (A >> 4) - (s >> 4) - (AL & 16); /* Calculate the upper nybble. */

        if (AH & 16) AH -= 6;                 /* BCD fixup for upper nybble. */

        /* The flags are set just like in Binary mode. */

        C = (A - s - !C) & 256 != 0;
        Z = (A - s - !C) & 255 != 0;
        V = ((A - s - !C) ^ s) & 128 && (A ^ s) & 128;
        N = (A - s - !C) & 128 != 0;

        A = ((AH << 4) | (AL & 15)) & 255;


Again Z flag is set before any BCD fixup. The N and V flags are set at any time 
before fixing the high nybble. The C flag may be set in any phase.

Decimal subtraction is easier than decimal addition, as you have to make the BCD 
fixup only when a nybble overflows. In decimal addition, you had to verify if 
the nybble was greater than 9. The processor has an internal "half carry" flag 
for the lower nybble, used to trigger the BCD fixup. When calculating with legal 
BCD values, the lower nybble cannot overflow again when fixing it. So, the 
processor does not handle overflows while performing the fixup. Similarly, the 
BCD fixup occurs in the high nybble only if the value overflows, i.e. when the C 
flag will be cleared.

Because SBC's flags are not affected by the Decimal mode flag, you could guess 
that CMP uses the SBC logic, only setting the C flag first. But the SBX 
instruction shows that CMP also temporarily clears the D flag, although it is 
totally unnecessary.

dsbc.prg:
---------

The following program, which tests SBC's result and flags, contains the 6502 
version of the pseudo code example above.

--------------------------------------------------------------------------------

droradc.prg:
dincsbc.prg:
dincsbc-deccmp:
---------------

Obviously the undocumented instructions RRA (ROR+ADC) and ISB (INC+SBC) have 
inherited also the decimal operation from the official instructions ADC and SBC. 

The program droradc proves this statement for ROR, and the dincsbc test proves 
this for ISB. Finally, dincsbc-deccmp proves that ISB's and DCP's (DEC+CMP) 
flags are not affected by the D flag.

--------------------------------------------------------------------------------
original uuencoded programs follow
--------------------------------------------------------------------------------

begin 644 vsbx
M`0@9$,D'GL(H-#,IJC(U-JS"*#0T*:HR-@```*D`H#V1*Z`_D2N@09$KJ0>%
M^QBE^VEZJ+$KH#F1*ZD`2"BI`*(`RP`(:-B@.5$K*4#P`E@`H#VQ*SAI`)$K
JD-Z@/[$K:0"1*Y#4J2X@TO\XH$&Q*VD`D2N0Q,;[$+188/_^]_:_OK>V
`
end

begin 644 sbx
M`0@9$,D'GL(H-#,IJC(U-JS"*#0T*:HR-@```'BI`*!-D2N@3Y$KH%&1*ZD#
MA?L8I?M*2)`#J1@LJ3B@29$K:$J0`ZGX+*G8R)$K&/BXJ?2B8\L)AOP(:(7]
MV#B@3;$KH$\Q*Z!1\2L(1?SP`0!H1?TIM]#XH$VQ*SAI`)$KD,N@3[$K:0"1
9*Y#!J2X@TO\XH%&Q*VD`D2N0L<;[$))88-#X
`
end

begin 644 sbx-c100
M`,%XH`",#L&,$,&,$L&XJ8*B@LL7AOL(:(7\N#BM#L$M$,'M$L$(Q?OP`B@`
M:$7\\`,@4,'N#L'0U.X0P=#/SB#0[A+!T,<``````````````)BJ\!>M#L$M
L$,'=_\'0":T2P=W_PM`!8,K0Z:T.P2T0P9D`PID`!*T2P9D`PYD`!<C0Y``M
`
end

begin 644 dadc
M 0@9",D'GL(H-#,IJC(U-JS"*#0T*:HR-@   'BI&*  A/N$_$B@+)$KH(V1
M*Q@(I?PI#X7]I?LI#V7]R0J0 FD%J"D/A?VE^RGP9?PI\ C $) ":0^JL @H
ML ?)H) &""@X:5\X!?V%_0AH*3W@ ! ""8"HBD7[$ JE^T7\, 28"4"H**7[
M9?S0!)@) J@8N/BE^V7\V A%_= G:(3]1?W0(.;[T(?F_-"#:$D8\ )88*D=
0&&4KA?NI &4LA?RI.&S[  A%

end

begin 600 dsbc-cmp-flags
M 0@9",D'GL(H-#,IJC(U-JS"*#0T*:HR-@   'B@ (3[A/RB XH8:66HL2N@
M09$KH$R1*XII::BQ*Z!%D2N@4)$K^#BXI?OE_-@(:(7].+BE^^7\"&A%_? !
5 .;[T./F_-#?RA"_8!@X&#CEY<7%

end

begin 600 dsbc
M 0@9",D'GL(H-#,IJC(U-JS"*#0T*:HR-@   'BI&*  A/N$_$B@+)$KH':1
M*S@(I?PI#X7]I?LI#^7]L /I!1@I#ZBE_"GPA?VE^RGP"#CE_2GPL KI7RBP
M#ND/.+ )*+ &Z0^P NE?A/T%_87]*+BE^^7\"&BH.+CXI?OE_-@(1?W0FVB$
8_47]T)3F^]">YOS0FFA)&- $J3C0B%A@

end

begin 644 droradc
M`0@9",D'GL(H-#,IJC(U-JS"*#0T*:HR-@```'BI&*``A/N$_$B@+)$KH(V1
M*S@(I?PI#X7]I?LI#V7]R0J0`FD%J"D/A?VE^RGP9?PI\`C`$)`":0^JL`@H
ML`?)H)`&""@X:5\X!?V%_0AH*3W@`!`""8"HBD7[$`JE^T7\,`28"4"H**7[
M9?S0!)@)`J@XN/BE^R;\9_S8"$7]T"=HA/U%_=`@YOO0A>;\T(%H21CP`EA@
2J1T892N%^ZD`92R%_*DX;/L`
`
end

begin 644 dincsbc
M`0@9",D'GL(H-#,IJC(U-JS"*#0T*:HR-@```'BI&*``A/N$_$B@+)$KH':1
M*S@(I?PI#X7]I?LI#^7]L`/I!1@I#ZBE_"GPA?VE^RGP"#CE_2GPL`KI7RBP
M#ND/.+`)*+`&Z0^P`NE?A/T%_87]*+BE^^7\"&BH.+CXI?O&_.?\V`A%_="9
::(3]1?W0DN;[T)SF_-"8:$D8T`2I.-"&6&#\
`
end

begin 644 dincsbc-deccmp
M`0@9",D'GL(H-#,IJC(U-JS"*#0T*:HR-@```'B@`(3[A/RB`XH8:7>HL2N@
M3Y$KH%R1*XII>ZBQ*Z!3D2N@8)$KBFE_J+$KH%61*Z!BD2OX.+BE^^;\Q_S8
L"&B%_3BXI?OF_,?\"&A%_?`!`.;[T-_F_-#;RA"M8!@X&#CFYL;&Q\?GYP#8
`
end
