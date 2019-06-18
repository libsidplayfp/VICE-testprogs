; The following program tests SBC's result and flags

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
        lda #$18

loc_81e:
        ldy #0
        sty $fb
        sty $fc

loc_824:
        pha
        ldy #loc_82d - basicstart
        sta ($2b),y     ; $0801+$2c=$082d
        ldy #loc_877 - basicstart
        sta ($2b),y     ; $0801+$76=$0877

loc_82d:
        sec
        php
        lda $fc
        and #$f
        sta $fd
        lda $fb
        and #$f
        sbc $fd
        bcs loc_840
        sbc #5
        clc

loc_840:
        and #$f
        tay
        lda $fc
        and #$f0
        sta $fd
        lda $fb
        and #$f0
        php
        sec
        sbc $fd
        and #$f0
        bcs loc_85f
        sbc #$5f
        plp
        bcs loc_868
        sbc #$f
        sec
        bcs loc_868

loc_85f:
        plp
        bcs loc_868
        sbc #$f
        bcs loc_868
        sbc #$5f

loc_868:
        sty $fd
        ora $fd
        sta $fd
        plp
        clv
        lda $fb
        sbc $fc
        php
        pla
        tay
loc_877:
        sec
        clv
        sed
        lda $fb
        sbc $fc
        cld
        php
        eor $fd
        bne failure
        pla
        sty $fd
        eor $fd
        bne failure
        inc $fb
        bne loc_82d
        inc $fc
        bne loc_82d
        pla
        eor #$18
        bne loc_89c
        lda #$38 
        bne loc_824

loc_89c:
        cli
pass:
        ;rts
        lda #5 
        sta $d020
        lda #$00
        sta $d7ff
        jmp *
failure:
        ;brk
        lda #10
        sta $d020
        lda #$ff
        sta $d7ff
        jmp *
