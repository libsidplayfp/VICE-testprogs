        *=$8000

        !byte $09,$80,$09,$80           ; Sprungadressen Kaltstart , Warmstart
        !byte $C3,$C2,$CD,$38,$30       ; Modulkennung CBM80

        SEI                 ; IRQ sperren
        CLD
        LDX #$FF
        TXS                    ; Stackpointer setzen
        lda #$2f
        sta $00
        lda #$37
        sta $01

        lda #6
        sta $d020
        sta $d021
        lda #$c8
        sta $d016
        lda #$15
        sta $d018

        lda #$1b
        sta $d011
        
        ldx #0
-
        lda #$20
        sta $0400,x
        sta $0500,x
        sta $0600,x
        sta $0700,x
        lda #$01
        sta $d800,x
        sta $d900,x
        sta $da00,x
        sta $db00,x
        inx
        bne -

        ldy #0
-
        lda #'X' & $3f
        sta $9000,y
        iny
        bne -
        
        ldy #0
-
        lda code,y
        sta $0500,y
        iny
        bne -
        jmp $0500

code:
        ldx #2

        lda #%0000      ; bank0
        sta $df00

        ldy #12
-
        lda b1pat,y
        sta $0400+(0*40),y
        dey
        bpl -

        lda #%0110      ; bank2, disable rom
        sta $df00

        ldy #12
-
        lda b3pat,y
        sta $0400+(1*40),y
        dey
        bpl -

        lda #%0000      ; bank0
        sta $df00

        ldy #12
-
        lda b1pat,y
        sta $0400+(2*40),y
        dey
        bpl -

        lda #%1001      ; bank1, disable reg
        sta $df00

        ldy #12
-
        lda b2pat,y
        sta $0400+(3*40),y
        dey
        bpl -

        lda #%0010      ; bank2, enable reg
        sta $df00

        ldy #12
-
        lda b3pat,y
        sta $0400+(4*40),y
        dey
        bpl -

        ldy #12
-
        lda (exp0-code)+$0500,y
        cmp $0400+(0*40),y
        bne fail
        lda (exp1-code)+$0500,y
        cmp $0400+(1*40),y
        bne fail
        lda (exp2-code)+$0500,y
        cmp $0400+(2*40),y
        bne fail
        lda (exp3-code)+$0500,y
        cmp $0400+(3*40),y
        bne fail
        lda (exp4-code)+$0500,y
        cmp $0400+(4*40),y
        bne fail
        dey
        bpl -
        ldx #5
        
fail:
-
        stx $d020

        lda #0          ; success
        cpx #5
        bne fail2
        lda #$ff        ; failure
fail2:
        stx $d7ff

        bne -
        beq -

exp0:   !scr "bank0 pattern"
exp1:   !scr "xxxxxxxxxxxxx"
exp2:   !scr "bank0 pattern"
exp3:   !scr "bank1 pattern"
exp4:   !scr "bank1 pattern"
        
        *=$8000 + $1000
b1pat = $8000 + $1000
        !scr "bank0 pattern"

        *=$8000 + $1000 + $4000
b2pat = $8000 + $1000
        !scr "bank1 pattern"

        *=$8000 + $1000 + $6000
b3pat = $8000 + $1000
        !scr "bank2 pattern"

        