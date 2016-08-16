;-------------------------------------------------------------------------------
; acme -f cbm -o noise_writeback_test2.prg noise_writeback_test2.asm
;-------------------------------------------------------------------------------
            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0
;-------------------------------------------------------------------------------

; disallow interrupts and disable screen to get stable timing
    sei
    lda #0
    sta $d011

; set frequency
    lda #$00
    ldx #$00
    sta $d40E
    stx $d40F

; set testbit
    lda #$08
    sta $d412

; noise reg may need some time
; to reset
    ldy #$10
---
    ldx #$00
--
    lda #$f0
-
    cmp $d012
    bne -
    dex
    bne --
    dey
    bne ---

; at this point all bit should be high

; release testbit and set noise+triangle
; a writeback followed by a shift should happen
    lda #$90
    sta $d412

; after the first shift we should read all zeros
    lda $d41b
    sta $0400
    cmp #$00
    bne nok

; set frequency
    lda #$ff
    ldx #$ff
    sta $d40E
    stx $d40F

; wait until next shift
    nop
    nop
    nop

; 
    lda $d41b
    sta $0401
    !if (NEWSID=0) {
    cmp #$14
    } else {
    cmp #$12
    }
    bne nok

ok:
    lda #5
    jmp prnt

nok:
    lda #2

prnt:
    sta $D020

    ldy #0      ; success
    lda $d020
    and #$0f
    cmp #5
    beq +
    ldy #$ff    ; failure
+
    sty $d7ff

; enable screen again to make result visible
    cli
    lda #$1b
    sta $d011

    jmp *

