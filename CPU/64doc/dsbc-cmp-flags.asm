        * =  $801
basicstart:
        !word nextline
        ; 1993 syspeek(43)+256*peek(44)+26
        !word 1993
        !byte $9e, $c2, $28, $34, $33, $29, $aa
        !byte $32, $35, $36, $ac, $c2, $28, $34, $34
        !byte $29, $aa, $32, $36
        !byte 0
nextline:
        !word 0
; --------------------------------------
        sei
        ldy #0
        sty $fb
        sty $fc
        ldx #3

loc_824:
        txa
        clc
        adc #loc_866 - basicstart
        tay
        lda ($2b),y     ; $0801+$65+X=$0866+X
        ldy #loc_842 - basicstart
        sta ($2b),y     ; $0801+$41=$0842
        ldy #loc_84d - basicstart
        sta ($2b),y     ; $0801+$4c=$084d
        txa
        adc #loc_86a - basicstart
        tay
        lda ($2b),y     ; $0801+$69+X=$086a+X
        ldy #loc_846 - basicstart
        sta ($2b),y     ; $0801+$45=$0846
        ldy #loc_851 - basicstart
        sta ($2b),y     ; $0801+$50=$0851

loc_841:
        sed
loc_842:
        sec
        clv
        lda $fb
loc_846:
        sbc $fc
        cld
        php
        pla
        sta $fd
loc_84d:
        sec
        clv
        lda $fb
loc_851:
        sbc $fc
        php
        pla
        eor $fd
        beq loc_85a
failure:
        ;brk
        lda #10
        sta $d020
        lda #$ff
        sta $d7ff
        jmp *
; --------------------------------------

loc_85a:
        inc $fb
        bne loc_841
        inc $fc
        bne loc_841
        dex
        bpl loc_824
pass:
        ;rts
        lda #5 
        sta $d020
        lda #$00
        sta $d7ff
        jmp *
; --------------------------------------
loc_866:
        !byte $18
        !byte $38
        !byte $18
        !byte $38
loc_86a:
        !byte $e5
        !byte $e5
        !byte $c5
        !byte $c5 
