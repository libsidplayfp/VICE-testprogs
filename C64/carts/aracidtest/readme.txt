
AR/RR Acid RAM Test by Count Zero
---------------------------------

see the original AR+Co_AcidRamTest_0.1.txt for details.

aracidtest.prg - this is the combined program

--------------------------------------------------------------------------------

the following describes only the seperated tests for the testbench:

test-ramdetect-ar.prg       - for AR/AP/NP
test-ramsizedetect-ar.prg   - for AR/AP/NP
test-ariotest1-ar.prg       - for AR/AP/NP
test-ariotest2-ar.prg       - for AR/AP/NP
test-arramtest2-ar.prg      - for AR/AP/NP (*)

test-ramdetect.prg          - for RR/NR
test-ramsizedetect.prg      - for RR/NR
test-ariotest1.prg          - for RR/NR
test-ariotest2.prg          - for RR/NR
test-arramtest2.prg         - for RR

test-arramtest2-nr.prg      - for NR

 (*) WARNING: on original Action Replay V5/V6 Hardware this test causes bus
              contention and there is a (although small) chance it might
              damage the hardware. If in doubt, do not run it.
