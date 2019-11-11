; emufuxx0r v2 "instanc4", first test
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

instanc4:

        ; test1: display sprites, in IRQ toggle between different vram configs
        ;        in a specific cycle. read sprite vs sprite collision register
        ;        once per line to check

        lda #%00000000
        sta $07f8
        sta $d000
        sta $d001
        sta $d002
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
        ; x = $ff

        lda #%10000000
        sta $0100

        lda #$ff
        sta $3bff
        sta $3fff
        
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

        lda #<busirq0
        sta $fffe
        lda #>busirq0
        sta $ffff

        lda #$01
        sta $d01a
        lda #$7f
        sta $dc0d
        bit $dc0d
        dec $d019
        cli

        ; busirq0 should now happen
-        
        txa
        bne -

        sei
-        
        bit $d011
        bpl -

        ldx #$10
        bit $d01e       ; sprite vs sprite collision
        
        ; for 16 lines, every line get d01e bit0 and shift into decodbuf+0/1
busloop:

-
        bit $d011
        bmi -
-
        bit $d011
        bpl -

        lsr $d01e       ; sprite vs sprite collision
        rol decodbuf+1
        rol decodbuf+0
        inc $d002
        dex
        bne busloop

        sei
        lda decodbuf+0
        jsr mkhex
        sta resline+0
        sty resline+1

        lda decodbuf+1
        jsr mkhex
        sta resline+3
        sty resline+4

        lda decodbuf+0
        cmp #$ff
        bne failed
        lda decodbuf+1
        cmp #$00
        bne failed
        
        ; test passed
        lda #5
        sta $d020
        lda #0
        sta $d7ff
        sta $07e7
        jmp *

failed:        
        ; test passed
        lda #2
        sta $d020
        lda #$ff
        sta $d7ff
        sta $07e7
        jmp *

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
        !align 255,0

        ; triggers at line $35
busirq0:  
        lda #<busirq1
        sta $fffe
        lda #>busirq1
        sta $ffff
        inc $d012
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
        nop
        nop
        nop
        
        sei

        ; test failed
        lda #2
        sta $d020
        lda #$ff
        sta $d7ff
        sta $07e7
        jmp *
        ;-----------------------------------------------------------------------

        ; triggers at line $36
busirq1:  
        pla
        pla
        pla
        
        ldx #$06
-
        dex
        bne -
        
        bit $24
        
        lda $d012
        cmp $d012
        beq +
+        
        ldx #$07
-
        dex
        bne -
        nop
        
        lda $d018
        pha
        lda #$d0
        ldy #$e0
        sta $d018
        lda $00
        sta $00
        sty $d018
        lda $01
        sta $01
        pla
        sta $d018
        
        dec $d019
        
        ; leaving with X=0 signals main loop to continue
        rti

