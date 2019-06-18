; dincsbc-deccmp proves that ISB's and DCP's (DEC+CMP) flags are not affected 
; by the D flag.

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
        adc #loc_878 - basicstart
        tay
        lda ($2b),y     ; $0801+$77+X=$0878+X
        ldy #loc_850 - basicstart
        sta ($2b),y     ; $0801+$4f=$0850
        ldy #loc_85d - basicstart
        sta ($2b),y     ; $0801+$5c=$085d
        txa
        adc #loc_87c - basicstart
        tay
        lda ($2b),y     ; $0801+$7b+X=$087c+X
        ldy #loc_854 - basicstart
        sta ($2b),y     ; $0801+$53=$0854
        ldy #loc_861 - basicstart
        sta ($2b),y     ; $0801+$60=$0861
        txa
        adc #loc_880 - basicstart
        tay
        lda ($2b),y     ; $0801+$7f+X=$0880+X
        ldy #loc_856 - basicstart
        sta ($2b),y     ; $0801+$55=$0856
        ldy #loc_863 - basicstart
        sta ($2b),y     ; $0801+$62=$0863

loc_84f:
        sed
loc_850:
        sec
        clv
        lda $fb
loc_854:
        inc $fc
loc_856:
        dcp $fc
        cld
        php
        pla
        sta $fd
loc_85d:
        sec
        clv
        lda $fb
loc_861:
        inc $fc
loc_863:
        dcp $fc
        php
        pla
        eor $fd
        beq loc_86c
failure:
        ;brk
        lda #10
        sta $d020
        lda #$ff
        sta $d7ff
        jmp *
; --------------------------------------

loc_86c:
        inc $fb
        bne loc_84f
        inc $fc
        bne loc_84f
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
loc_878:
        !byte $18
        !byte $38
        !byte $18
        !byte $38
loc_87c:        
        !byte $e6
        !byte $e6
        !byte $c6
        !byte $c6
loc_880:        
        !byte $c7
        !byte $c7
        !byte $e7
        !byte $e7 
        !byte 0
