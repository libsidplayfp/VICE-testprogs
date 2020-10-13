;-------------------------------------------------------------------------------
            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0
;-------------------------------------------------------------------------------

;NEWSID=0
; acme -f cbm -o osc3-wave0.prg osc3-wave0.asm

    sei
    ldx #0
    stx $d020
    stx $d021
-
    lda #1
    sta $d800,x
    sta $d900,x
    sta $da00,x
    sta $db00,x
    lda #$20
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
    inx
    bne -

; zero out SID registers
    lda #$0
    ldx #$18
-
    sta $d400,x
    dex
    bne -

; pulse, pw=$fff
    lda #$ff
    sta $d410
    sta $d411
    lda #$40
    sta $d412

; check OSC3
    lda $d41b
    sta $0400
    cmp #$00
    bne nok

; pulse, pw=$000
    lda #$00
    sta $d410
    sta $d411
    lda #$40
    sta $d412

; check OSC3
    lda $d41b
    sta $0401
    cmp #$ff
    bne nok

; waveform 0
    lda #$00
    sta $d412

; check OSC3
; it still retains the previous value
    lda $d41b
    sta $0402
    cmp #$ff
    bne nok

; check OSC3 again
; after the delay it should have faded to zero
    ldx #0
    ldy #0
    stx $0400+(10*40)
    sty $0401+(10*40)
waitlp:
    jsr waitframe

    lda $d41b
addr1=*+1
    sta $0403
    cmp #$00
    beq ok
addr0=*+1
    cmp $0402
    beq nochange
    ; value changed
    inc addr1
    bne +
    inc addr1+1
+
    inc addr0
    bne +
    inc addr0+1
+
nochange:
    inx
    stx $0401+(10*40)
    bne waitlp
!if NEWSID=1 {
    iny
    sty $0400+(10*40)
    cpy #6
    bne waitlp
}
nok:
    lda #2
    jmp prnt

ok:
    lda #5

prnt:
    sta $d020

    ldy #0      ; success
    lda $d020
    and #$0f
    cmp #5
    beq +
    ldy #$ff    ; failure
+
    sty $d7ff

    jmp *

waitframe:
w1: bit $d011
    bpl w1
w2: bit $d011
    bmi w2
    rts
