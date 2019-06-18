; This test program shows if your machine is compatible with ours regarding the 
; opcode $CB. The test proves that SBX does not affect the V flag. 
; It tests 33554432 SBX combinations (16777216 different A, X and Immediate 
; combinations, and two different V flag states).

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
        lda #0
        ldy #loc_083e - basicstart
        sta ($2b),y     ; $0801+$3d=$083e
        ldy #loc_0840 - basicstart
        sta ($2b),y     ; $0801+$3f=$0840
        ldy #loc_0842 - basicstart
        sta ($2b),y     ; $0801+$41=$0842
        lda #7
        sta $fb

loc_082d:
        clc
        lda $fb
        adc #loc_087b - basicstart
        tay
        lda ($2b),y     ; $0801+$7a+n=$087b+n
        ldy #loc_083a - basicstart
        sta ($2b),y     ; $0801+$39=$083a

loc_0839:
loc_083a = * + 1
        lda #0
        pha
        plp
loc_083e = * + 1
        lda #0
loc_0840 = * + 1
        ldx #0
loc_0842 = * + 1
        sbx #0
        php
        pla
        cld
        ldy #loc_083a - basicstart
        eor ($2b),y     ; $0801+$39=$083a
        and #$40
        beq loc_0850
        cli
failure:
        ;brk
        lda #10
        sta $d020
        lda #$ff
        sta $d7ff
        jmp *
; --------------------------------------

loc_0850:
        ldy #loc_083e - basicstart
        lda ($2b),y     ; $0801+$3d=$083e
        sec
        adc #0
        sta ($2b),y     ; $0801+$3d=$083e
        bcc loc_0839
        ldy #loc_0840 - basicstart
        lda ($2b),y     ; $0801+$3f=$0840
        adc #0
        sta ($2b),y     ; $0801+$3f=$0840
        bcc loc_0839
        lda #$2e
        jsr $ffd2
        sec
        ldy #loc_0842 - basicstart
        lda ($2b),y     ; $0801+$41=$0842
        adc #0
        sta ($2b),y     ; $0801+$41=$0842
        bcc loc_0839
        dec $fb
        bpl loc_082d
        cli
pass:
        ;rts
        lda #5 
        sta $d020
        lda #$00
        sta $d7ff
        jmp *
; --------------------------------------
loc_087b:
        !byte $ff
        !byte $fe
        !byte $f7
        !byte $f6
        !byte $bf
        !byte $be
        !byte $b7
        !byte $b6 
