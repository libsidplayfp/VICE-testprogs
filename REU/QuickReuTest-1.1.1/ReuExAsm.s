    .export _lstatus
    .export _reuexec
    .export _enableReuIrq
    .export _disableReuIrq

_lstatus:
    .byte $00

oldirq:
    .word $0000

; =============================================================================

reuirq:
    bit $dc0d
    bmi goOldIrq; don't check for REU IRQ, if CIA IRQ is set
                ; another IRQ will be triggered immediately,
                ; if a REU IRQ is still pending

    lda $df00   ; read out and clear REU status
    tax
    and #$80
    bmi reucausedirq
goOldIrq:
    jmp ( oldirq )

reucausedirq:
    stx _lstatus; store only, when true REU IRQ
    jmp $ea81   ; don't serve CIA IRQ

; =============================================================================

_enableReuIrq:
    php
    sei
    ldx oldirq+1
    bne issaved
    ; install new REU IRQ routine
    ldx $0314   ; save old irq vector
    stx oldirq
    ldx $0315
    stx oldirq + 1

issaved:
    ldx #<reuirq
    stx $0314
    ldx #>reuirq
    stx $0315   ; install custom irq vector
    plp
    rts

_disableReuIrq:
    php
    sei
    ldx oldirq + 1
    beq notsaved
    stx $0315   ; install original irq vector
    ldx oldirq 
    stx $0314
    ldx #$00
    stx oldirq + 1
notsaved:
    plp
    rts

_reuexec:
    ldx #$ff
    stx $dd04 ; init timer A low 
    stx $dd05 ; init timer A high
    stx $dd06 ; init timer B low
    stx $dd07 ; init timer B high

    ; wait for rasterline $fc
    ldx #$fc
    ldy #$10  ; timeout/tryout counter
waitraster:
    cli
    dey
    bmi abort

waitstage1:
    cpx $d012
    bne waitstage1

    sei            ; recheck under IRQ
    cpx $d012
    bcc waitraster ; wait for next screen round

    ; switch off screen and sprites
    ldx #$00
    stx $d011
    stx $d015

    ; install new REU IRQ routine
    jsr _enableReuIrq

    ldx #%10010001 ; configure and start timer A
    ldy #%01010001 ; configure and start timer B
    stx $dd0e      ; start with timer A to prevent ...
    sty $dd0f      ; ... counting early underflow

    ldx #$00
    stx _lstatus   ; clear IRQ status to default value

    sta $df01      ; start transfer or prewrite command register 
    sta $ff00      ; start transfer in case of ff00 trigger set

    ldx #%10000000 ; stop timer A to not produce ...
    ldy #%01000000 ;         stop timer B
    stx $dd0e      ; ... any more underflows
    sty $dd0f

    ldx #$1b       ; switch on screen again
    stx $d011

    cli            ; let the REU IRQ happen, if pending

    ldx #$00
waitIrq:
    dex
    bne waitIrq

    jsr _disableReuIrq

    lda #$00
    .byte $2c
abort:
    lda #$ff
    rts

; =============================================================================



    