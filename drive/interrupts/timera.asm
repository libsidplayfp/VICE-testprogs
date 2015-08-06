        !convtab pet
        !cpu 6510
        !to "timera.prg", cbm

;-------------------------------------------------------------------------------

drivecode_start = $0300
drivecode_exec = drvstart

        !src "../framework.asm"

;-------------------------------------------------------------------------------
start:
        jsr clrscr

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

        sei
        jsr rcv_wait

        ; recieve the result data
        ldx #$00
-
        jsr rcv_1byte
        sta $0400,x
        jsr rcv_1byte
        sta $0500,x
        inx
        bne -

        lda $0400
        jsr mkhex
        stx $0400+(15*40)+3
        sta $0400+(15*40)+2

        lda $0500
        jsr mkhex
        stx $0400+(15*40)+1
        sta $0400+(15*40)+0

        jsr checkrefs
        bcs +

        jsr mkhex
        stx $0400+(15*40)+6
        sta $0400+(15*40)+5

        lda #5
        sta $d020
        jmp cont
+
        lda #10
        sta $d020
        jmp cont

cont:


waitk:
        cli
-       lda $dc01
        cmp #$ef
        bne -

        jmp start

checkrefs:
        ; check data
        ldx #>reference1
        stx refp+2
        inx
        stx refp2+2
        lda #<reference1
        sta refp+1
        sta refp2+1

        lda #0
        sta refcnt+1
checklp:
        ldy #2
--
        ldx #$00
-
refp:   lda reference1,x
        cmp $0400,x
        bne chkerr
refp2:  lda reference1+$100,x
        cmp $0500,x
        bne chkerr
        inx
        bne -
        ; no error
refcnt: lda #0
        clc
        rts

chkerr:
        inc refp+2
        inc refp+2
        inc refp2+2
        inc refp2+2

        inc refcnt+1
        lda refcnt+1
        cmp #3
        bne checklp
        sec
        rts

mkhex:
        pha
        and #$0f
        tay
        lda hextab,y
        tax
        pla
        lsr
        lsr
        lsr
        lsr
        tay
        lda hextab,y
        rts

;hextab:
;        !scr "0123456789abcdef"
;-------------------------------------------------------------------------------

drivecode:
!pseudopc drivecode_start {
.data1 = $0600
.data2 = $0700

        !src "../framework-drive.asm"
drvstart
        sei
        jsr snd_init

        lda #0
        ldx #$00
-
        sta .data1,x
        inx
        bne -

        lda #$00
        sta $1c04
        lda #$01
        sta $1c05

        lda #$ff
        sta $1805
        lda #$ff
        sta $1804

        lda #18         ; track nr
        sta $08  
        ldx #$00        ; sector nr
        stx $09  
        lda #$e0        ; seek and start program at $0400
        sta $01
        cli
        lda $01  
        bmi *-2

.drvwait: 
        lda #0
        beq .drvwait

        sei
        jsr snd_start

        ; send test data
        ldy #$00
-
        lda .data1,y
        jsr snd_1byte
        lda .data2,y
        jsr snd_1byte
        iny
        bne -
        rts

        ; irq/jobcode routine
        ;* = $0400
        !align $ff, 0, 0

.irqcnt: ldx #0

        lda $1804
        sta .data1,x
        lda $1805
        sta .data2,x
        inx
        cpx #0
        beq .irqstop
        stx .irqcnt+1

        jmp $F99C       ; to job loop

.irqstop:
        lda #1
        sta .drvwait+1

        lda #$80
        sta $01

        jmp $F99C       ; to job loop

} 
drivecode_end:
 
        * = $1000
reference1:
        !bin "timera-ref1.bin", $200
reference2:
        !bin "timera-ref2.bin", $200,
reference3:
        !bin "timera-ref3.bin", $200,
