; emufuxx0r v2 "instanc4", second
;-------------------------------------------------------------------------------        

decodbuf=$0400
resline =$0400+(1*40)

        *=$0801
        !word $080b,00
        !byte $9e
        !text "2560"
        !byte $00,$00,$00

;-------------------------------------------------------------------------------        
        
        *=$0a00

        sei
        lda #$35
        sta $01
        ldx #$ff
        txs

instanc4b:

        lda #%00000000
        sta $07f8
        sta $d000
;        sta $d001
;        sta $d002
        sta $d003

        ldx #$04
        stx $07f9

        ; clear sprite block at $100
        ldx #$3e
-
        sta $0100,x
        dex
        bpl -

        sta $d010
        sta $d017
        sta $d01b
        sta $d01c
        sta $d01d

        lda #$20
        ldx #120
-
        sta $0400,x
        dex
        bpl -

        lda #%10000000
        sta $0100

        lda $3bff
        pha
        txa
        eor $3fff
        sta $3bff

        lda #$08
        sta $d016
        
        lda $d018
        and #%00001111
        ora #%00010000
        sta $d018
        
        lda #%00000011
        sta $d015
        
        ora $dd00
        sta $dd00
        
        lda #$9b
        sta $d011
        lda #$35
        sta $d012

;        lda #<busirq0
;        sta $fffe
;        lda #>busirq0
;        sta $ffff

        lda #$01
        sta $d01a
        lda #$7f
        sta $dc0d
        bit $dc0d
;        dec $d019
;        cli



        ;test2:

        ldx #$40
        stx $07fd
        stx $07fe
        stx $07ff
-
        lda $0fff,x
;        sta $ff,x
        !byte $0d, $ff, $00 ; sta $00ff,x
        lda #$00
        sta $0fff,x
        dex
;        bne *-12       ; FIXME BUG?
        bne -

;.C:0abf  07 BD       SLO $BD
;.C:0ac1  FF 0F 95    ISB $950F,X
;.C:0ac4  FF A9 00    ISB $00A9,X
;.C:0ac7  9D FF 0F    STA $0FFF,X

        stx $d002
        stx $d004
        inx
        stx $d001
        stx $d00b
        stx $d00c
        stx $d00d
        stx $d00e
        stx $d00f
        
        ldy #$05
        sty $d00a
        stx $d017
        lda #%11100000
        sta $d015           ; enable sprites 5-7

        lda #$36
        sta $d012
;        lda #<emuirq
;        sta $fffe
;        lda #>emuirq
;        sta $ffff
;        dec $d019
;        cli

        ;test3: SID readback and bitfading
        lda #$01
        sta $d400

        lda $d400
        sta decodbuf+2

        ldx #0
        ldy #$ff
sidcolsc: 
        lda decodbuf+2
        cmp $d400
        beq +

        lda #$f0            ; BEQ
        sta emuchkps_inst
+        
        lda $d012
-
        cmp $d012
        beq -
        
        inx
        bne sidcolsc

emuchkps_inst:        
        !byte $24,emuchkng-*-2
        dey
        bne sidcolsc

emuchkps: 
        ; test failed

    ;	jmp decodjmp+3
        sei
        
        lda decodbuf+2
        jsr mkhex
        sta resline+0
        sty resline+1
        
        lda #2
        sta $d020
        lda #$ff
        sta $d7ff
        sta $07e7
        jmp *

        ;--------------------------------

emuchkng 
        jmp toinstn3

;-> original code continues at "toinstn3"
toinstn3

        sei

        lda decodbuf+2
        jsr mkhex
        sta resline+0
        sty resline+1

        ; test passed
        lda #5
        sta $d020
        lda #0
        sta $d7ff
        sta $07e7
        jmp *

result:
        !byte 0,0,0

;-------------------------------------------------------------------------------	
	

; in:  value in A
; out: hex in Y/A
mkhex:
        pha
        and #$0f
        tax
        lda hextab,x
        tay
        pla
        lsr
        lsr
        lsr
        lsr
        tax
        lda hextab,x
        rts

hextab:
        !byte $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$01,$02,$03,$04,$05,$06
