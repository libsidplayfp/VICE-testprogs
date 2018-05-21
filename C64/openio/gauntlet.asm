            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0
            jmp start
;-------------------------------------------------------------------------------

     * = $0900
start:
    sei
    lda #$35
    sta $01

    ldx #0
-
    txa
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
    inx
    bne -

    jsr test

    ; passed
    jsr clear

    ldx #7
-
    lda txtpassed,x
    sta $0400,x
    dex
    bpl -

    lda #5
    sta $d020
    lda #$00
    sta $d7ff
    jmp *

test:
    LDY #$1E
i4067:
    JSR i406D      ; run the check 30 times
    DEY
    BNE i4067
i406D:
    LDA $D012
    BPL i406D
i4072:
    LDA $D012
    BMI i4072      ; wait raster, give i/o time to change
    LDX #$0F
    LDA #$00
i407B:
    EOR $DEF8,X
    EOR i4178,X    ; check for Warpspeed cart signature
    DEX
    BPL i407B
    TAX
    BEQ i40CF      ; Warpspeed is exempt
    LDX #$0F
i4089:
    LDA $DE00,X
    CMP i418B,X    ; check io1, compare to last reading
    BNE i409B      ; not the same = good, no cart
    DEX
    BPL i4089
    DEC i4189      ; dec try counter. same 20 times = failure
    BEQ failed
    BNE i40AB
i409B:
    LDX #$0F
i409D:
    LDA $DE00,X    ; store io1 values into buffer
    STA i418B,X
    DEX
    BPL i409D
    LDA #$14       ; set 20 tries
    STA i4189
i40AB:
    LDX #$0F
i40AD:
    LDA $DF00,X
    CMP i419F,X    ; check io2, compare to last reading
    BNE i40BF      ; not the same = good, no cart
    DEX
    BPL i40AD
    DEC i419D      ; dec try counter. same 20 times = failure
    BEQ failed
    BNE i40CF
i40BF:
    LDX #$0F
i40C1:
    LDA $DF00,X    ; store io2 values into buffer
    STA i419F,X
    DEX
    BPL i40C1
    LDA #$14
    STA i419D
i40CF:
    LDA $8004      ; make sure no cart mapped into $8000 area
    INC $8004
    CMP $8004
    BEQ failed
    STA $8004

    rts

    ; failed
failed:
    lda #2
    sta $d020
    lda #$ff
    sta $d7ff
    jsr clear
    ldx #7
-
    lda txtfailed,x
    sta $0400,x
    dex
    bpl -
    jmp *

clear:
    lda #$20
    ldx #0
-
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
    inx
    bne -
    rts

i4178:  !byte $5f, $df, $c7, $20, $53, $91, $74, $f0, $6d, $ab, $45, $1a, $64, $72, $73, $2e, $ff 
i4189:  !byte $0f, $96
i418B:  !byte $01, $02, $03, $04, $05, $06, $07, $08, $09, $10, $11, $12, $13, $14, $15, $16, $96, $ff
i419D:  !byte $0f, $96
i419F:  !byte $01, $02, $03, $04, $05, $06, $07, $08, $09, $10, $11, $12, $13, $14, $15, $16, $96, $00

txtpassed: !scr "passed  "
txtfailed: !scr "failed  "
