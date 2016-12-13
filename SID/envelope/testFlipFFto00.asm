;-------------------------------------------------------------------------------
            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0
;-------------------------------------------------------------------------------

; acme -f cbm -o testFlipFFto00.prg testFlipFFto00.asm

; The envelope counter can flip from 0xff to 0x00 by changing state to
; release, then to attack. The envelope counter is then frozen at
; zero; to unlock this situation the state must be changed to release,
; then to attack.


; set AD
    lda #$77
    sta $D413
; set gate on
    lda #$01
    sta $D412

loop:
; wait until ENV3 reaches $ff
    lda $D41C
    cmp #$ff
    bne loop

; set gate off
    lda #$00
    sta $D412

; set gate on
    lda #$01
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

    cmp #$00
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
