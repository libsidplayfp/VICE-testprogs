; emufuxx0r v2 "instanc1"
;-> originally "toinstn2" test ran before
;-------------------------------------------------------------------------------        

decodbuf=$0400

        *=$0801
        !word $080b, 0
        !byte $9e
        !text "2560"
        !byte $00,$00,$00

;-------------------------------------------------------------------------------        
        
        *=$0a00
start:
        lda #8  ; drive nr
        sta $ba

        lda #$00
        sta $d020

        lda #$00
        sta $90
        sta decodbuf+0
        sta $d01a

        jsr emudrvls
        bit $90
        bpl emudrvi0

        ; test failed
        ; drive error
        lda #$07
        sta $d020
        lda #$ff
        sta $d7ff
        sta $07e7
        jmp *

        ;-------------------------------------

emudrvi0: 

        lda #$01
        sta $d020

        ; send drive code
        ldx #$05
-
        lda emudrvmw,x
        jsr $ffa8	; Handshake Serial Byte Out
        dex
        bpl -

        ldx decodbuf+0

        ldy #$20
emudrvcp: 
        lda emudrive,x
        jsr $ffa8	; Handshake Serial Byte Out
        inx
        cpx #emudrved-emudrive
        beq emudrvi1 ; exit loop
        dey
        bne emudrvcp

        stx decodbuf+0

        jsr emudrvuls 
        clc
        lda #$20
        adc emudrvmw+2	; addr lo
        sta emudrvmw+2	; addr lo
        bne emudrvi0

        lda #$03
        sta $d020

emudrvi1: 
        ; execute drive code
        jsr emudrvuls
    
        ldx #$05
-
        lda emudrvme-1,x
        jsr $ffa8	; Handshake Serial Byte Out
        dex
        bne -

        jsr $ffae	; Command Serial Bus UNLISTEN

-
        bit $dd00
        bvs -

        ldx #%00101111
        stx $dd02
        ora #%00100100
        sta $dd00

        ; delay
-
        inx
        bne -

        lda #%00111111
        sta $dd02
        beq failed

        lda #%01001001
        eor $dd00
        ldx #%00000011
        stx $dd00
        cmp #%01101110
        beq passed

failed:
        ; test failed
        lda #$02
        sta $d020
        lda #$ff
        sta $d7ff
        sta $07e7
        jmp *

passed:
        lda #$05
        sta $d020
        lda #0
        sta $d7ff
        sta $07e7
        jmp *

        ;---------

emudrvuls: 
        jsr $ffae	; Command Serial Bus UNLISTEN
emudrvls: 
        lda $ba
        jsr $ffb1	; Set Logical File Parameters
        lda #$6f
        jmp $ff93	; Send SA After Listen

;-------------------------------------------------------------------------------        

emudrvmw:
        !byte $20,>$0320,<$0320
    ;	!byte "w","-","m"
        !text "W-M"
emudrvme:
        !byte >$0300,<$0300
    ;	!byte "e","-","m"
        !text "E-M"

;-------------------------------------------------------------------------------        
emudrive: 
        sei
        lda #$08
        sta $1800

        lda $1800
        lsr
        bcc *-4

        lda #$00
        sta $1800
        lda $1800
        asl
        and #%00001000
        sta $1800

        lda $1800
        lsr
        bcs *-4

        lda #%11101111
        and $20
        sta $20
        rts
emudrved:
