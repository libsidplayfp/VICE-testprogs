
;-------------------------------------------------------------------------------
            *=$07ff
            !word $0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0
;-------------------------------------------------------------------------------
videoram = $0400
colorram = $d800

        sei
        ldx #$ff
        txs

        lda #$17
        sta $d018
        lda #$35
        sta $01

        ldx #0
-
        lda #$20
        sta videoram,x
        sta videoram+$0100,x
        sta videoram+$0200,x
        sta videoram+$0300,x
        lda #1
        sta colorram,x
        sta colorram+$0100,x
        sta colorram+$0200,x
        sta colorram+$0300,x
        inx
        bne -

mlp:
        jsr check1
        sta videoram

        asl
        asl
        tax
        ldy #4
-
        lda told,x
        sta videoram+(1*40),y
        inx
        dey
        bne -

        jsr check2
        sta videoram

        asl
        asl
        tax
        ldy #4
-
        lda told,x
        sta videoram+(2*40),y
        inx
        dey
        bne -

        jmp mlp

told:   !scr " dlo"
tnew:   !scr " wen"
        
;-------------------------------------------------------------------------------

; detecting sid type (disassembled from Mathematica by Reflex)
; http://codebase64.org/doku.php?id=base:detecting_sid_type

        ; subroutine filling SID's registers with $00
check1:
        sei             ;No disturbing interrupts
        lda #$ff
        cmp $d012       ;Don't run it on a badline.
        bne *-3

        inc $d020

        LDX #24
        LDA #0
loop    STA $D400,x
        DEX
        BPL loop

        ; main routine
        LDA #$02
        STA $D40F       ; v3 freq hi
        LDA #$30
        STA $D412       ; v3 ctrl, enable mixed triangle+saw
        LDY #$00
        LDX #$00
sl3     LDA $D41B
        BMI sl2
        DEX
        BNE sl3
        DEY
        BNE sl3
        BEQ sl4
sl2     LDX #$01        ; 1 = 8580
sl4                     ; 0 = 6581
        bne d8580

; we have 6581 found
        txa
        dec $d020
        rts

; we have 8580 found
d8580   
        txa
        dec $d020
        rts


;-------------------------------------------------------------------------------

;SID DETECTION ROUTINE (http://codebase64.org/doku.php?id=base:detecting_sid_type_-_safe_method)
check2: 
        sei             ;No disturbing interrupts
        lda #$ff
        cmp $d012       ;Don't run it on a badline.
        bne *-3

        LDX #24
        LDA #0
-       STA $D400,x
        DEX
        BPL -        

        inc $d020

        ;Detection itself starts here   
        lda #$ff        ;Set frequency in voice 3 to $ffff 
        sta $d412       ;...and set testbit (other bits doesn't matter) in $d012 to disable oscillator
        sta $d40e
        sta $d40f
        lda #$20        ;Sawtooth wave and gatebit OFF to start oscillator again.
        sta $d412
        lda $d41b       ;Accu now has different value depending on sid model (6581=3/8580=2)
        lsr             ;...that is: Carry flag is set for 6581, and clear for 8580.
        bcc model_8580
model_6581:
        lda #0
        dec $d020
        rts

model_8580:
        lda #1
        dec $d020
        rts
