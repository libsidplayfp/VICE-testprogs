        *= $0801
        !byte $0c,$08,$0b,$00,$9e
        !byte $32,$30,$36,$34
        *= $0810

        ldx #1
l1:     lda $d012
l2:     cmp $d012
        beq l2
        bmi l1
        cmp #$20
        bcc ntsc
        ldx #0
ntsc:   stx ntscflag
        jmp start

ntscflag:
        !byte 0 ; 1 means NTSC

;-------------------------------------------------------------------------------
rcv_init:
        lda #$3f
        sta $dd02
        lda #$03
        sta $dd00

        rts

rcv_wait:
.wait1
        lda $dd00       ; wait for DATA = 0 CLOCK = 0 (1 on drive side)
        and #%11000000
        bne .wait1

        ; ack start
        lda #%00001011 ; ATN=1
        sta $dd00
        ;nop
        nop
        lda #%00000011 ; ATN=0
        sta $dd00

        rts

;-------------------------------------------------------------------------------

rcv_1byte
        lda ntscflag
        bne rcv_1byte_ntsc

!if (0) {
.poll
        lda $d012
        cmp #$2e
        bcc +
        eor $d011
        and #$07
        beq .poll
        and #$04
        bne .poll
+
}
!if (1) {
-
        lda #$2e
        cmp $d012
        bcc -
}
        inc $d020

.wait2
        lda $dd00       ; wait for DATA = 0 CLOCK = 0 (1 on drive side)
        and #%11000000
        bne .wait2

        lda #%00001011 ; ATN=1
        sta $dd00
        nop
        lda #%00000011 ; ATN=0
        sta $dd00

        lda #$ff
        eor $dd00      ; get 000000nn
        lsr
        lsr
        eor $dd00      ; get 0000nn00
        lsr
        lsr
        eor $dd00      ; get 00nn0000
        lsr
        ;asr #$fe       ;lets carry be cleared after lsr!
        lsr
        eor $dd00      ; get nn000000

        dec $d020
        rts

rcv_1byte_ntsc
!if (1) {
-
        lda #$2e
        cmp $d012
        bcc -
}
        dec $d020

.wait2a
        lda $dd00       ; wait for DATA = 0 CLOCK = 0 (1 on drive side)
        and #%11000000
        bne .wait2a

        lda #%00001011 ; ATN=1
        sta $dd00
        bit $ea
        lda #%00000011 ; ATN=0
        sta $dd00

        lda #$ff
        eor $dd00      ; get 000000nn
        lsr
        lsr
        eor $dd00      ; get 0000nn00
        lsr
        lsr
        eor $dd00      ; get 00nn0000
        lsr
        ;asr #$fe       ;lets carry be cleared after lsr!
        lsr
        eor $dd00      ; get nn000000
        inc $d020
        rts

;-------------------------------------------------------------------------------

.listen
        lda $ba
        jsr $ffb1
        lda #$6f
        jmp $ff93

upload_code:
        stx .cnt+1
        sta dc_addr+1
        sty dc_addr+2

        lda #$00
        sta $90
        lda #$08
        sta $ba

        ; send "i" command
        jsr .listen

        lda #"i"
        jsr $ffa8
        jsr $ffae

        lda #<drivecode_start
        sta mw_dest+0
        lda #>drivecode_start
        sta mw_dest+1

.cnt:   ldx #$08   ;upload 8 * $20 bytes to 1541
.l0
        jsr .listen

        ldy #$00
-
        lda mw_comm,y
        jsr $ffa8
        iny
        cpy #$06
        bne -

        ldy #$00
-
dc_addr: 
        lda $dead,y
        jsr $ffa8
        iny
        cpy #$20
        bne -
        jsr $ffae
        tya
        clc
        adc dc_addr+1
        sta dc_addr+1
        bcc +
        inc dc_addr+2
+
        tya
        clc
        adc mw_dest
        sta mw_dest
        bcc +
        inc mw_dest+1
+
        dex
        bne .l0
        rts

start_code
        sta me_comm+3
        sty me_comm+4

        jsr .listen

        ldy #$00
-
        lda me_comm,y
        jsr $ffa8
        iny
        cpy #$05
        bne -
        jsr $ffae

        jmp rcv_init

mw_comm
        !text "m-w"
mw_dest
        !byte <drivecode_start
        !byte >drivecode_start
        !byte $20

me_comm
        !text "m-e"
        !byte <$dead
        !byte >$dead

;-------------------------------------------------------------------------------

clrscr:
        ldx #0
        stx $d020
        stx $d021
clp:
        lda #$20
        sta $0400,x
        sta $0500,x
        sta $0600,x
        sta $0700,x
        lda #1
        sta $d800,x
        sta $d900,x
        sta $da00,x
        sta $db00,x
        inx
        bne clp
        rts

hextab:
        !byte $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$01,$02,$03,$04,$05,$06
