
from https://sourceforge.net/p/vice-emu/bugs/1308/

"The follwing code worked fine for most emulated real drives that I've tried, 
but with the fs drive, there has been some unrealiablility inf. loop also in 
the code below), so I had to comment out some lines to match c64 ROM. This 
might not be a bug (my guess is my code was beond the 80µs minimum spec.), 
but probably a noteworthy difference, given the purpose of the fs drv."

SRDsendSATalk:
        php
        sei
        sta SRDshift
        jsr SRDsendbyte
        ; jsr SRDpDat
        ; lda $dd00
        ; and #f7   ; release atn
        ; sta $dd00
        ; and #ef   ; release clk
        ; sta $dd00
        jsr SRDpDat
        jsr SRDrAtn
        jsr SRDrClk ; 1541 doesn't wait for this
SRDsendSATw: 
        jsr SRDreaddatstable    ; wait for clk lo
        bmi SRDsendSATw         ; despite we've released it
        plp
        clc
        rts


The program tries to load a file named "testseq,s,r" mutiple times, first with
the corrected version of the snippet, then with the problematic lines 
uncommented.

On success, the program shows green border. If the testfile isn't found, 
it shows red border. 

