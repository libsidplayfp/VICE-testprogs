; This test program shows if your machine is compatible with ours regarding the 
; opcode $CB. The sbx test tests 16777216*4 D and C flag combinations. 

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
        lda #0
        ldy #loc_084e - basicstart
        sta ($2b),y     ; $0801+$4d=$084e
        ldy #loc_0850 - basicstart
        sta ($2b),y     ; $0801+$4f=$0850
        ldy #loc_0852 - basicstart
        sta ($2b),y     ; $0801+$51=$0852
        lda #3
        sta $fb
        clc

loc_082f:
        lda $fb
        lsr
        pha
        bcc loc_0837+1
        lda #$18

loc_0837:
        bit $38a9
        ldy #loc_084a - basicstart
        sta ($2b),y     ; $0801+$49=$084a
        pla
        lsr
        bcc loc_0844+1
        lda #$f8

loc_0844:
        bit $d8a9
        iny
        sta ($2b),y     ; $0801+$4a=$084b

loc_084a:
        clc
        sed
        clv
loc_084e = * + 1        
        lda #$f4
loc_0850 = * + 1        
        ldx #$63
loc_0852 = * + 1        
        sbx #9
        stx $fc
        php
        pla
        sta $fd
        cld
        sec
        ldy #loc_084e - basicstart
        lda ($2b),y     ; $0801+$4d=$084e
        ldy #loc_0850 - basicstart
        and ($2b),y     ; $0801+$4f=$0850
        ldy #loc_0852 - basicstart
        sbc ($2b),y     ; $0801+$51=$0852
        php
        eor $fc
        beq loc_086d

loc_086c:
failure:
        ;brk
        lda #10
        sta $d020
        lda #$ff
        sta $d7ff
        jmp *
; --------------------------------------

loc_086d:
        pla
        eor $fd
        and #$b7
        bne loc_086c
        ldy #loc_084e - basicstart
        lda ($2b),y     ; $0801+$4d=$084e
        sec
        adc #0
        sta ($2b),y     ; $0801+$4d=$084e
        bcc loc_084a
        ldy #loc_0850 - basicstart
        lda ($2b),y     ; $0801+$4f=$0850
        adc #0
        sta ($2b),y     ; $0801+$4f=$0850
        bcc loc_084a
        lda #$2e
        jsr $ffd2
        sec
        ldy #loc_0852 - basicstart
        lda ($2b),y     ; $0801+$51=$0852
        adc #0
        sta ($2b),y     ; $0801+$51=$0852
        bcc loc_084a
        dec $fb
        bpl loc_082f
        cli
pass:
        ;rts
        lda #5 
        sta $d020
        lda #$00
        sta $d7ff
        jmp *
