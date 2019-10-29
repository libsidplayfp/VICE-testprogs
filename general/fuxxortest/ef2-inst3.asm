; emufuxx0r v2 "instanc3"
;-> originally "toinstn4" test ran before
;-------------------------------------------------------------------------------        

corrvala=$06

resline =$0400+(1*40)

        *=$0801
        !word $080b,00
        !byte $9e
        !text "2560"
        !byte $00,$00,$00

;-------------------------------------------------------------------------------        
        
tod000:
!byte $00, $01, $00, $00, $00, $00, $00, $00,  $00, $00, $05, $01, $01, $01, $01, $01
!byte $00, $1b, $00, $00, $00, $00, $c8, $00,  $15, $00, $00, $00, $00, $00, $e0, $00
        
        *=$0a00

        lda #$7f
        sta $dc0d
        bit $dc0d
         
        lda #$20
        ldx #120
-        
        sta $0400,x
        dex
        bpl -
        
        ldx #$1f
-
        lda tod000,x
        sta $d000,x
        dex
        bpl -
        bit $d01e       ; sprite vs sprite collision
        bit $d01f
        
        sei
        lda #$35
        sta $01
        ldx #$ff
        txs
toinstn3:


instanc3 
        ; uses sprite 0-2

        ; set sprite pointers to
        ; 4*64 = $0100 and 5*64 = $0140
        ldy #$04
        sty $07f8
        sty $07f9
        iny
        sty $07fa

        ; make sprite data
        ldy #$3f
-
        lda #$55
        sta $0100,y
        asl
        sta $0140,y
        dey
        bpl -
        
        ; y = $ff
        lda #$81
        sta $d003  ; spr 1 y
        lda #$95
        sta $d005  ; spr 2 y
-
        bit $d011
        bpl -
-        
        bit $d011
        bmi -

        lda #%00000111 ; spr 0,1,2 on
        sta $d015
        lda #%00000100 ; spr 2 multicolor
        sta $d01c

        lda #$37
        sta $d012
        lda #$01
        sta $d01a
        lda #$9b
        sta $d011

        lda #<wrapdirq
        sta $fffe
        lda #>wrapdirq
        sta $ffff

        dec $d019
        jmp toinstn2

;---------------------------------------------------------

;-> original code continues at "toinstn2"
toinstn2 
        cli
-        
        tya    ; y = $ff
        bmi -

        sei
        sta result
        stx result+1
        sty result+2

;        lda #5
;        sta $d020
        sty $0400

        lda result
        jsr mkhex
        sta resline+0
        sty resline+1

        lda result+1
        jsr mkhex
        sta resline+3
        sty resline+4

        lda result+2
        jsr mkhex
        sta resline+6
        sty resline+7
        
        lda result
        cmp #corrvala
        bne fail

        ; test passed
        lda #$05
        sta $d020
        lda #0
        sta $d7ff
        sta $07e7

        jmp *

fail:
        ; test failed
        lda #$02
        sta $d020
        lda #$ff
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
	
;-------------------------------------------------------------------------------
        ;*=$0b00
        !align 255,0

        ; triggers at line $37
wrapdirq: 
        bit $d01e         ; sprite vs sprite collision
        lda #<wrapirq2
        sta $fffe
        lda #>wrapirq2
        sta $ffff
        lda #$1b
        sta $d011
        lda #$00
        sta $d012
        dec $d019
        cli
        
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        
        jmp *

        ; triggers at line $00 ?
wrapirq2: 
        pla
        pla
        pla

        ldx #$07
-
        dex
        bne -

        lda $d012-$ff,y    ; y = $ff
        beq +
+
        ldx #$3b
-
        dex
        bne -
        nop

        stx $d017  ; x = 0
        sty $d017  ; y = $ff

        lda #$96
-
        cmp $d012
        bne -

        ldx #$08
-
        dex
        bne -
        ; x = 0
        stx $d01c       ; multicolor off

        ldy $d01e       ; sprite vs sprite collision
        dec $d019
        rti
