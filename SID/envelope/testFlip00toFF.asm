;-------------------------------------------------------------------------------
            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0
;-------------------------------------------------------------------------------

; acme -f cbm -o testFlip00toFF.prg testFlip00toFF.asm

; The envelope counter can flip from 0x00 to 0xff by changing state to
; attack, then to release. The envelope counter will then continue
; counting down in the release state.


; set AD and SR
    lda #$77
    sta $D413
    sta $D414

; set gate off
    lda #$00
    sta $D412

; wait until ENV3 reaches $00
loop:
    lda $D41C
    cmp #$00
    bne loop

; set gate on
    lda #$01
    sta $D412

; set gate off
    lda #$00
    sta $D412

; wait at least 313 cycles
; so the counter is clocked once
	ldy #$3f
wait:
	dey
	bne wait

; sample ENV3
    lda $D41C
	sta $0400

    cmp #$ff
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

    jmp *
