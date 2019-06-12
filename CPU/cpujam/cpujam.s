    .macpack longbranch
    .export Start

Start:
        sei
        lda #$35
        sta $01
        lda #>eaeahook
        sta $eaea+2
        lda #<eaeahook
        sta $eaea+1
        lda #$4c ; JMP
        sta $eaea+0
        lda #5
        sta $d020
        jsr dojam
        ; if we return here, the JAM behaved like RTS
        lda #2
        sta $d020
        lda #$ff
        sta $d7ff
        jmp *

        nop
        bit $eaea
        bit $eaea
        bit $eaea
        bit $eaea
        nop
        ; if we come here, the JAM behaved like branch
        lda #2
        sta $d020
        lda #$ff
        sta $d7ff
        jmp *

dojam:
        .byte JAMCODE
        .byte $ea       ; - $14 incase JAM=branch
        .byte $ea
        ; if we come here, the JAM did not halt the CPU
        lda #2
        sta $d020
        lda #$ff
        sta $d7ff
        jmp *

eaeahook:
        ; if we come here, the JAM did behave like JMP or JSR
        lda #2
        sta $d020
        lda #$ff
        sta $d7ff
        jmp *
