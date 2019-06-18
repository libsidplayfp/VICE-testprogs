; The following program is a Commodore 64 executable that Marko Makela developed 
; when trying to find out how the V flag is affected by SBX. (It was believed that 
; the SBX affects the flag in a weird way, and this program shows how SBX sets the 
; flag differently from SBC.)  You may find the subroutine at $C150 useful when 
; researching other undocumented instructions' flags. Run the program in a machine
; language monitor, as it makes use of the BRK instruction. The result tables will 
; be written on pages $C2 and $C3.

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

        ldx #0
        stx $07e7
-
        lda payload,x
        sta $c100,x
        inx
        bne -
        jmp $c100
        
payload:
!pseudopc $c100 {  
        sei
        ldy #0
        sty loc_c10d+1
        sty loc_c10f+1
        sty loc_c111+1

loc_c10c:
        clv

loc_c10d:
        lda #$82

loc_c10f:
        ldx #$82 

loc_c111:
        sbx #$17
        stx $fb
        php
        pla
        sta $fc
        clv
        sec
        lda loc_c10d+1
        and loc_c10f+1
        sbc loc_c111+1
        php
        cmp $fb
        beq loc_c12b
        plp
        brk
; --------------------------------------

loc_c12b:
        pla
        eor $fc
        beq loc_c133
        jsr sub_c150

loc_c133:
        inc loc_c10d+1
        bne loc_c10c
        inc loc_c10f+1
        bne loc_c10c
        dec $07e7
        inc loc_c111+1
        bne loc_c10c
        ;brk
        beq failure
; --------------------------------------
        !byte 0
        !byte 0
        !byte 0
        !byte 0
        !byte 0
        !byte 0
        !byte 0
        !byte 0
        !byte 0
        !byte 0

sub_c150:
        tya
        tax
        beq loc_c16b

loc_c154:
        lda loc_c10d+1
        and loc_c10f+1
        cmp $c1ff,x
        bne loc_c168
        lda loc_c111+1
        cmp $c2ff,x
        bne loc_c168

locret_c167:
pass:
        ;rts
        lda #5 
        sta $d020
        lda #$00
        sta $d7ff
        jmp *
; --------------------------------------

loc_c168:
        dex
        bne loc_c154

loc_c16b:
        lda loc_c10d+1
        and loc_c10f+1
        sta $c200,y
        sta $400,y
        lda loc_c111+1
        sta $c300,y
        sta $500,y
        iny
        bne locret_c167
failure:
        ;brk
        lda #10
        sta $d020
        lda #$ff
        sta $d7ff
        jmp *
}
