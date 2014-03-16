        !convtab pet
        !cpu 6510

;-------------------------------------------------------------------------------

drivecode_start = $0300
drivecode_exec = drvstart

        !src "../framework.asm"

;-------------------------------------------------------------------------------
start:
        jsr $e518       ; init I/O

        jsr clrscr

        lda #5
        sta ERRBUF+$ff

        !if (1) {
        ; run all tests once
        ldx #0
clp1b
        txa
        sta tmp
        pha
        jsr $e518       ; init I/O
        jsr dotest
        pla
        tax
        inx
        cpx #NUMTESTS
        bne clp1b
        }
        !if (0) {
        ; run only first test
        lda #0
        sta tmp
        jsr $e518       ; init I/O
        jsr dotest
        }

loop
        ; show errors
        ldx #0
clp1a
        txa
        clc
        adc #"a"
        and #$3f
        sta $0400+(24*40),x
        lda ERRBUF,x
        sta $d800+(24*40),x
        inx
        cpx #NUMTESTS
        bne clp1a

        lda ERRBUF+$ff
        sta $d020
        lda #0
        sta $d021
wkey
        jsr $ffe4
        cmp #"a"
        bcc wkey
        cmp #"a"+NUMTESTS
        bcs wkey
        tax
        sec
        sbc #"a"
        sta tmp
        txa
        and #$3f
        sta $0400+(24*40)+39

        jsr $e518       ; init I/O
        jsr dotest
        jmp loop

dotest
        inc $d020

        lda #$20
        ldx #0
clp1    sta $0400,x
        inx
        bne clp1

        lda #0
        sta addr+1
        lda tmp
        asl
        rol addr+1
        asl
        rol addr+1
        asl
        rol addr+1
        asl
        rol addr+1
        asl
        rol addr+1
!if (TESTLEN >= $40) {
        asl
        rol addr+1
}
        sta addr
        lda #>TESTSLOC        ; testloc hi
        clc
        adc addr+1
        sta addr+1

        ldy #0
clp2:
        lda (addr),y
        sta drivecode_dotest,y
        iny
        cpy #TESTLEN
        bne clp2
        
        lda #<drivecode
        ldy #>drivecode
        ldx #((drivecode_end - drivecode) + $1f) / $20 ; upload x * $20 bytes to 1541
        jsr upload_code

        lda #<drivecode_exec
        ldy #>drivecode_exec
        jsr start_code

        sei
        jsr rcv_init

        dec $d020
        ; delay here long enough so the floppy is done testing
        ldx #$a0
-
        lda #$f0
        cmp $d012
        bne *-3
        cmp $d012
        beq *-3

        dex
        bne -
        inc $d020

        jsr rcv_wait

        ; recieve the result data
        ldx #$00
-
        jsr rcv_1byte
        sta $0400,x
        inx
        bne -

        ;jsr $fda3
        ;cli

        lda #5
        ldx tmp
        sta ERRBUF,x

        ldy #0
lla     sta $d800,y
        sta $d800+(8*40),y
        sta $d800+(16*40),y
        iny
        bne lla

        lda tmp
        clc
        adc #>TMP
        sta addr+1
        lda #<TMP
        sta addr

        lda tmp
        clc
        adc #>DATA
        sta add2+1
        lda #<DATA
        sta add2

        ; copy data from screen to TMP and check errors
        ldy #0
ll      ;lda (addr),y
        ;sta $0400,y
        lda $0400,y
        sta (addr),y
        cmp (add2),y
        beq rot
        lda #10
        sta $d800,y
        sta $d800+(8*40),y
        sta $d800+(16*40),y
        sta ERRBUF,x
        sta ERRBUF+$ff
rot
        lda (add2),y
        sta $0400+(8*40),y
        eor (addr),y
        sta $0400+(16*40),y
        iny
        bne ll

        inc $d020

        ; delay here long enough so the floppy is done resetting itself
        ldx #$80
-
        lda #$f0
        cmp $d012
        bne *-3
        cmp $d012
        beq *-3

        dex
        bne -

        dec $d020
        dec $d020
        cli
        rts

;-------------------------------------------------------------------------------

drivecode:
!pseudopc drivecode_start {


        !src "../framework-drive.asm"
drvstart
        sei
        jsr .setdefaults
        jsr snd_init

        lda #0
        ldy #$00
-
        sta DTMP,y
        iny
        bne -

        ; call actual test
        jsr ddotest

        sei
        jsr .setdefaults
        jsr snd_init    ; call init again, because the test may have changed VIA1 port B
        jsr snd_start

        ; send test data
        ldy #$00
-
        lda DTMP,y
        jsr snd_1byte
        iny
        bne -

        ; (more or less) reset VIA regs and drive
        sei
        jmp $eaa0       ; drive reset

.setdefaults:
!if (1) {
        ; serial port: disabled
        ; timer A: count clk, continuous, Timed Interrupt when Timer 1 is loaded, no PB7
        ; timer B: count PB6 pulses (=stop)
        ; port A latching disabled
        ; port B latching disabled
        lda #%00100000
        sta $180b
        ; CB2 Control: Input negative active edge 
        ; CB1 Interrupt Control: Negative active edge
        ; CA2 Control: Input negative active edge 
        ; CA1 Interrupt Control: Negative active edge
        lda #0
        sta $180c

        lda #$a5
        sta $180a ; serial shift register

        ; disable IRQs
        lda #$7f
        sta $180e

        ; acknowledge pending IRQs
        lda $180d
        lda $180d

        ; init timers
        ; after this all timer values will be = $0000
        ldy #0
        tya
t1a     sta $1804
        sta $1805
        sta $1806
        sta $1807
        sta $1808
        sta $1809
        dey
        bne t1a
        rts
}

ddotest:
        * = ddotest+TESTLEN
        !word $dead
} 
drivecode_end:

drivecode_dotest = (ddotest - drivecode_start) + drivecode
