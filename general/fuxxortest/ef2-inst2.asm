; emufuxx0r v2 "instanc2"
;-> originally "toinstn3" test ran before
;-------------------------------------------------------------------------------        

corrval1 = $ed
decodbuf=$0400
irqwait =$0400+1

        *=$0801
        !word $080b, 0
        !byte $9e
        !text "2560"
        !byte $00,$00,$00

;-------------------------------------------------------------------------------

tod000:
!byte $00, $01, $00, $00, $00, $00, $00, $00,  $00, $00, $05, $01, $01, $01, $01, $01
!byte $00, $1b, $00, $00, $00, $e0, $c8, $01,  $15, $01, $00, $00, $00, $00, $e0, $00
        
        *=$0a00
start:

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

        bit $d011
        bpl *-3
        bit $d011
        bmi *-3

        lda #$00
        sta $d020
        sta $0400+(24*40)
        sta $0400+(24*40)+1
        sta irqwait
        jmp instanc2

;-------------------------------------------------------------------------------        
        
        *=$0b00
instanc2
        ; set sprite pointers to
        ; 4*64 = $0100 and 5*64 = $0140
        ldy #$04
        sty $07fc
        sty $07fd
        sty $07fe
        sty $07ff
        iny
        sty $07f9
        sty $07fb

        ldy #$3f
        lda #$ff
        sta $ff,y
        lda #$00
        sta $013f,y
        dey
        bne *-11

        sta $0105

        sta $d015

        lda #$a0
        sta $0140

        sty $d002   ; 00
        sta $d006   ; a0
        ldx #$4b
        stx $d003   ; 4b
        stx $d007
        lda #$e0
        sta $d008   ; e0
        lda #$36
        sta $d009   ; 36
        sta $d00d
        lda #$58
        sta $d00a   ; 58
        sta $d00e
        lda #$21
        sta $d00b   ; 21
        lda #$64
        sta $d00c   ; 64
        dex
        stx $d00f   ; 4a
        ldx #%11111010
        stx $d010
        
        ;  spr0  1   2   3   4   5   6   7
        ; x 0.. 100 0.. 1a0 1e0 158 164 158
        ; y ... .4b ... .4b .36 .21 .36 .4a
        
        lda #%00010000
        sta $d017       ; y-exp
        lda #%00001010
        sta $d01c       ; multicolor
        lda #%11111000
        sta $d01d       ; x-exp

;        lda #$01
;        sta $d020
        
        lda $d020
        ldy #$0a
-
        sta $d024,y
        dey
        bne -

-
        bit $d011
        bpl -
-
        bit $d011
        bmi -

        stx $d015       ; enable all sprites, except 0 and 2
        bit $d01e       ; clear sprite vs sprite collision

        lda #$1b
        sta $d011
        lda #$01
        sta $d01a
        lda #$7f
        sta $dc0d
        lda #$34
        sta $d012

        lda #<sprextr0
        sta $fffe
        lda #>sprextr0
        sta $ffff

        ;-----------------------------------------
        ldy #0

        lda $dc0d
        sta $dc0d

        dec $d019
        ; y=0, will be changed in irq
        cli
        
        ; irq should trigger in this loop
;        tya
wait:
    ;	inc $d020
        lda irqwait
        beq wait

        sei
        lda #<sprextr2
        sta $fffe
        lda #>sprextr2
        sta $ffff
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
        lda #$00
        sta $d01a

        sty $0400+40

        cpy #corrval1
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
        ;-----------------------------------------

sprextr2 
        dec $d019
        rti

;-------------------------------------------------------------------------------        
        
        *=$0d00

        ; triggers in line $34
sprextr0: 
        lda #<sprextr1
        sta $fffe
        lda #>sprextr1
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
        nop
        sei
        jmp decodjmp
decodjmp:
        lda #$03
        sta $d020

        jmp *

        ;-----------------------------------------
        ; triggers in line $35 (stable +/- 1 cycle)
        ; Y=0
sprextr1 
        pla
        pla
        pla

        ldx #$06
        dex
        bne *-1

        nop

        lda $d012
        cmp $d012
        bne *+2
        
        ; stable now

        ldx #$07
        dex
        bne *-1
        nop
        nop

        ; open border
        stx $d016
        lda #$08
        sta $d016

        ; read sprite vs sprite collision and push on stack
        lda $d01e   ; Sprite to Sprite Collision Detect
        pha

        ldx #$c3
        dex
        bne *-1
        nop
        nop

        lda #$78
        sta $d006

        ; open border
        stx $d016
        lda #$08
        sta $d016

        ; read sprite vs sprite collision and push on stack
        lda $d01e   ; Sprite to Sprite Collision Detect
        pha

        lda #$6f
        sta $d002

        ldx #$04
        dex
        bne *-1
        bit $24

        ; open border
        stx $d016
        lda #$08
        sta $d016

        ; read sprite vs sprite collision
        lda $d01e       ; sprite vs sprite collision
        and #%11110111  ; for very old
        cmp #$82;$8a    ; c64s, stm. $82
        beq *+3
        iny

        pla	; Sprite to Sprite Collision Detect (line 1)
        cmp #$88
        beq *+3
        iny

        pla	; Sprite to Sprite Collision Detect (line 2)
        cmp #$60
        beq *+3
        iny

        tya
        bne *+4
        ldy #corrval1 ; ed

        ; wait for line==0
-
        lda $d012
        bne -

        ldx #$10
-
        sta $d000,x
        dex
        bpl -

        sta $d015   ; disable all sprites
        sta $d017
        sta $d01c
        sta $d01d

        ldx #$07
-
        sta $d027,x
        dex
        bpl -

        lda #$00
        sta $d01a

        lda #$34
        sta $d012

    ;	inc $d021
        inc $0400+(24*40)

        lda #<sprextr2
        sta $fffe
        lda #>sprextr2
        sta $ffff

        lda #1
        sta irqwait

    ;	ldy #1
        dec $d019

        ; A=0, X=$ff, Y=result
        rti
