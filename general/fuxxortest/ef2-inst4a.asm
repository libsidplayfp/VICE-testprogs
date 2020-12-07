; emufuxx0r v2 "instanc4", first test
;-------------------------------------------------------------------------------        

decodbuf=$0400
resline =$0400+(1*40)
dbgbuf  =$0400+2

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

        ; test1: writes test values to RAM at $00,$01 and checks the written
        ;        value using sprite/sprite collisions

        lda #0
        sta $07f8   ; sprite 0 pointer  -> $0000
        sta $d000   ; sprite 0 x-pos -> 0
        sta $d001   ; sprite 0 y-pos -> 0
        sta $d002   ; sprite 1 x-pos -> 0
        sta $d003   ; sprite 1 y-pos -> 0

        ldx #$04
        stx $07f9   ; sprite 1 pointer  -> $0100

        ; clear sprite block at $100
        ldx #$3e
-
        sta $0100,x
        dex
        bpl -

        sta $d010   ; clear all x-pos msb
        sta $d017   ; y-expand off
        sta $d01b   ; sprite has priority
        sta $d01c   ; sprites are hires
        sta $d01d   ; x-expand off

        ; clear top of screen
        lda #$20
        ldx #120
-
        sta $0400,x
        dex
        bpl -
        ; x = $ff

        ; set top/left pixel of sprite 1
        lda #%10000000
        sta $0100

        ; prepare the sprite pointers that are fetched later and that will
        ; end up in RAM at $00,$01
        lda #$00        ; goes to $01
        sta $3bff
        lda #$ff        ; goes to $00
        sta $37fa

        lda #$08
        sta $d016

        lda $d018
        and #%00001111
        ora #%00010000
        sta $d018       ; vram at $0400

        lda #%00000011  ; enable sprite 0, sprite 1
        sta $d015

        ora $dd00
        sta $dd00       ; videobank 3

        ; set irq to line $135 (309)
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

        ; wait for irq to set x = 0
-
        txa
        bne -

        sei
-
        bit $d011
        bpl -

        ldx #$10
        bit $d01e       ; clear sprite vs sprite collision

        ; for 16 vertical positions get d01e bit0 and shift into decodbuf+0/1
busloop:

-
        bit $d011
        bmi -
-
        bit $d011
        bpl -

        lsr $d01e       ; sprite vs sprite collision (sprite 0)
        rol decodbuf+1
        rol decodbuf+0
        inc $d002       ; sprite 1 x-position
        dex
        bne busloop

        ; decodebuf is expected to contain %11111111 %00000000
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
        ; test failed
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

        ; triggers at line $135 (309)
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

        ; triggers at line $136 (310)
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

        ; when writing to $00 or $01, the value fetched by the VIC in the
        ; previous "p cycle" will get written to the actual RAM
        ;
        ; here this will be 1) the sprite pointer for sprite 3 ($37fa) and
        ; 2) the sprite pointer for sprite 8 ($3bff).

        lda #$d0
        ldy #$e0

        sta $d018   ; 1101  vram at $3400, $37fa contains $ff
        lda $00     ; loads $2f
        ; we are at line 311, cycle 62
        sta $00     ; writes $ff to RAM at $00

        sty $d018   ; 1110  vram at $3800, $3bff contains $00
        ldy $01     ; loads $35
        ; we are at line 0, cycle 6
        sty $01     ; writes $00 to RAM at $01

        ; lets display what values we wrote :)
        sta dbgbuf+0
        sty dbgbuf+1

        pla
        sta $d018

        dec $d019

        ; leaving with X=0 signals main loop to continue
        rti

