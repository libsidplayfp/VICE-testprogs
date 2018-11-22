;-------------------------------------------------------------------------------
            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0
;-------------------------------------------------------------------------------

; acme -f cbm -o testADSRDelayBug.prg testADSRDelayBug.asm

; If the rate counter comparison value is set below the current value of the
; rate counter, the counter will continue counting up until it wraps around
; to zero at 2^15 = 0x8000, and then count rate_period - 1 before the
; envelope can constly be stepped.

; disallow interrupts and disable screen to get stable timing
    sei
    lda #0
    sta $d011

; set minimum ADSR time
    lda #$00
    sta $D413
    sta $D414
; gate off
    sta $D412

; wait frame
-   lda $d011
    bpl -
-   lda $d011
    bmi -

; check that ENV3 is at $00
-
    lda $D41C
    cmp #$00
    bne -

; set Attack time
    lda #$70
    sta $D413

; gate on
    lda #$01
    sta $D412

; wait until ENV3 reaches $01
-
    lda $D41C
    cmp #$01
    bne -

; wait 200 cycles
    ldy #$28
-
    dey
    bne -

; sample ENV3
    lda $D41C
    sta $0400

; it's still at $01
    cmp #$01
    bne nok

; set lower Attack time
; should theoretically clock after 63 cycles
    lda #$20
    sta $D413

; wait another 200 cycles
    ldy #$28
-
    dey
    bne -

; sample ENV3
    lda $D41C
    sta $0401

; it's still at $01 even if enough cycles have passed
    cmp #$01
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

