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

        !if (0) {
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
        } else {
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

        ; some arbitrary delay
        ldx #0
        dex
        bne *-1

        jsr rcv_wait

        ; recieve the result data
        ldx #$00
-
        jsr rcv_1byte
        sta $0400,x
        inx
        bne -

        jsr $fda3
        ;cli

        lda #5
        ldx tmp
        sta ERRBUF,x

        ldy #0
lla     sta $d800,y
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
        sta ERRBUF,x
        sta ERRBUF+$ff
rot
        iny
        bne ll

        dec $d020
        cli
        rts

;-------------------------------------------------------------------------------

drivecode:
!pseudopc drivecode_start {


        !src "../framework-drive.asm"
drvstart
        sei
        jsr snd_init

        lda #0
        ldy #$00
-
        sta DTMP,y
        iny
        bne -

!if (1) {
        sei

        lda #0
        sta $180b
        sta $180c

        ; disable IRQs
        lda #$7f
        sta $180e

        ; acknowledge pending IRQs
        lda $180d
        lda $180d

        ; init timers
        ldy #0
        tya
t1a     sta $1804
        sta $1805
        sta $1808
        sta $1809
        dey
        bne t1a

!if (TESTID = 15) {
        lda $dc0e
        ora #$80
        sta $dc0e
        ; disable active IRQs
        lda $180e
        and #$7f
        sta $180e
        lda $dc08
}
}
        ; call actual test
        jsr ddotest

        sei
        jsr snd_start

        ; send test data
        ldy #$00
-
        lda DTMP,y
        jsr snd_1byte
        iny
        bne -

        ; (more or less) reset VIA regs and drive
!if (0) {
        lda #0
        ldy #$0f
-
        sta $1800,y
        dey
        bpl -
}
!if (0) {
        ldy #$00
-
        sta 0,y
        sta $400,y
        sta $500,y
        sta $600,y
        sta $700,y
        iny
        bne -

        lda #0
        sta $1804
        sta $1804
        sta $1805
        sta $1805
        sta $1806
        sta $1806
}
!if (0) {
        lda #$ff
        sta $1803       ; VIA1 DDR A
        lda #$02
        sta $1800       ; VIA1 DATA B
        lda #$1a
        sta $1802       ; VIA1 DDR B

        lda #$01
        STA $180C
        lda #$82
        STA $180D
        ;lda #$82
        STA $180E

        lda $180d       ; ack irq
}
;        cli
;        rts
        sei
        jmp $eaa0       ; drive reset

ddotest:
        * = ddotest+TESTLEN
        !word $dead
} 
drivecode_end:

drivecode_dotest = (ddotest - drivecode_start) + drivecode