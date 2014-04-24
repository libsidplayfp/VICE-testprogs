taken from http://www.6502.org/tutorials/decimal_mode.html

--------------------------------------------------------------------------------

Errata - Documents - Decimal Mode tutorial 

The program in Appendix B of the Decimal Mode tutorial is lightly documented, 
and has a significant omission.

As written, it tests all aspects of 8-bit decimal mode behavior on an NMOS 6502: 
documented and undocumented behavior of both ADC and SBC, valid and invalid BCD 
values, and checks the results of the accumulator, and the N, V, Z, and C flags.

The omission is that it neglects to mention that to test a 65C02, you must 
substitute JSR A65C02 and JSR S65C02 for JSR A6502 and JSR S6502, respectively. 
Likewise, it also neglects to mention that to test the 8-bit cases for the 
65816, substitute JSR A65816 and JSR S65816 for JSR A6502 and S6502, 
respectively.

To supplement what little documentation there is, what follows here can be 
considered a mini user's guide.

The program works by calculating the correct values of the accumulator and N, V, 
Z, and C flags using binary arithmetic. Thus, for testing a simulator it is 
important that binary arithmetic be working correctly. Otherwise, a false 
positive or a false negative might result.

Note that N2H is a 2 byte variable. All other variables are 1 byte variables.

It tests 2 * 2 * 256 * 256 cases, i.e. 2 instructions (ADC and SBC), 2 possible 
input values for the carry, 256 possible input values for the accumulator, and 
256 possible values for the operand. The program is just an implementation of 
the formulas given in Appendix A (which, despite its title, covers all cases, 
not just undocumented behavior).

If all of the cases tested passed, $00 is returned in the ERROR variable, and if 
any of the cases tested failed, $01 is returned in the ERROR variable. It stops 
at the first case which failed, so you can tell what input values failed, the 
expected accumulator and flag results, and the actual results. It doesn't tell 
you whether the ADC or the SBC failed, though by looking at the input values and 
the expected values, you can usually tell. Alternatively, there are a few other 
ways to handle this.
Just try both ADC and SBC for the failed case and see which one differs (or if 
both differ)
Comment out one of the BNE DONE instructions to test ADC and SBC separately (in 
other words, you're just ignoring the test results for one of those 
instructions)
Modify the program so that one of them will return with a 2 in ERROR if failed 
(and the other still returns 1 in ERROR)

Input values:
The Y register contains the input C flag value ($00 for C flag clear, $01 for C 
flag set)
The N1 variable contains the input value of the accumulator
The N2 variable contains the input value of the operand

Correct results (calculated using binary arithmetic):
AR is the correct accumulator result
Bit 7 of NF is the correct N flag result, the other bits are ignored and may be 
any combination of zeros and ones
Bit 6 of VF is the correct V flag result, the other bits are ignored and may be 
any combination of zeros and ones
Bit 1 of ZF is the correct Z flag result, the other bits are ignored and may be 
any combination of zeros and ones
Bit 0 of CF is the correct C flag result, the other bits are ignored and may be 
any combination of zeros and ones

Actual results (i.e. values produced by the processor or simulator in decimal 
mode):
DA is the actual accumulator result
DNVZC is the actual result of all (including N, V, Z, and C) flags

The COMPARE routine simply compare the correct results with the actual results. 
It is intended to be easy to made modifications to it that will remove tests.
The first three instructions (LDA DA through the first BNE C1 inclusive) compare 
the accumulator result
The next four instructions (the first LDA DNVZC through the second BNE C1 
inclusive) compare the N flag result
The next four instructions (the second LDA DNVZC through the third BNE C1 
inclusive) compare the V flag result
The next four instructions (the third LDA DNVZC through the fourth BNE C1 
inclusive) compare the Z flag result
The next three instructions (the fourth LDA DNVZC through AND #1 inclusive) 
compare the C flag result

If you wish to test all 8-bit decimal mode behavior COMPARE does not need to be 
modified at all. COMPARE must be modified to remove tests (and thus test only a 
subset of 8-bit decimal mode behavior). For example, it is probably not 
necessary (or even useful) for a simulator to replicate the correct V flag 
behavior. The directions in Appendix B describe modifications to test only valid 
BCD numbers (steps 1 through 6 inclusive) and modifications to test only valid 
flags (steps 7 and 8). 
