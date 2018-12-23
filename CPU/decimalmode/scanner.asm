
; TODO: add more instruction types

zptmp = $02
currinstr = $03

zpabuf = $04
zpxbuf = $05
zpybuf = $06

resa = $07
resx = $08
resy = $09


videoram = $0400
colorram = $d800

result_akku = $0500
result_flags = $0600
result_mem = $0700

        !cpu 6510

;-------------------------------------------------------------------------------
        * = $0801
        !word bend
        !word 10
        !byte $9e
        !text "2061", 0
bend:   !word 0
;-------------------------------------------------------------------------------

        sei
        lda #$17
        sta $d018
        lda #$35
        sta $01
        ldx #0
        stx $d021
        dex
        stx $d020

        ldx #0
-
        lda #$20
        sta videoram,x
        sta videoram+$0100,x
        sta videoram+$0200,x
        sta videoram+$0300,x
        lda #1
        sta colorram,x
        sta colorram+$0200,x
        lda #15
        sta colorram+$0100,x
        sta colorram+$0300,x
        inx
        bne -

        jmp main

;-------------------------------------------------------------------------------
; returns carry set on error
testpage_zp:

        ldx #0
testpage_zp_loop:
        stx zpxbuf

testpage_zp_zpval = * + 1
        lda #0
testpage_zp_imm3 = * + 1
        sta $20

        txa     ; A = x
        tay

testpage_zp_clc = *
        clc
        ; the instruction we want to test
        sed

testpage_zp_instr = *
testpage_zp_imm = * + 1
        adc $20
        cld
        ; temp. save the registers
        sta resa
        stx resx
        sty resy
        ; save the flags
        php
        pla
        and #%11010011
        ldx zpxbuf
        sta result_flags,x
        ; save regs to table
        lda resa
        sta result_akku,x

testpage_zp_zpval2 = * + 1
        lda #0
testpage_zp_imm4 = * + 1
        sta $20
        
        ldx zpxbuf
        txa     ; A = x
        tay
        
testpage_zp_clc2 = *
        clc
        ; the instruction we want to test
testpage_zp_instr2 = *
testpage_zp_imm2 = * + 1
        adc $20
        ; temp. save the registers
        sta resa
        stx resx
        sty resy
        ; check the flags
        php
        pla
        and #%11010011
        ldx zpxbuf
        cmp result_flags,x
        bne testpage_zp_fail_f

        lda resa
        cmp result_akku,x
        bne testpage_zp_fail_a
        
        ldx zpxbuf
        inx
        bne testpage_zp_loop

        clc
        rts
testpage_zp_fail_a:
testpage_zp_fail_f:
        sec
        rts
        
;-------------------------------------------------------------------------------
; returns carry set on error
testpage_imm:


        ldx #0
testpage_imm_loop:
        stx zpxbuf
        txa     ; A = x
        tay

testpage_imm_clc = *
        clc
        ; the instruction we want to test
        sed
testpage_imm_instr = *
testpage_imm_imm = * + 1
        adc #0
        cld
        ; temp. save the registers
        sta resa
        stx resx
        sty resy
        ; save the flags
        php
        pla
        and #%11010011
        ldx zpxbuf
        sta result_flags,x
        ; save regs to table
        lda resa
        sta result_akku,x
        
        ;ldx zpxbuf
        txa     ; A = x
        tay
        
testpage_imm_clc2 = *
        clc
        ; the instruction we want to test
testpage_imm_instr2 = *
testpage_imm_imm2 = * + 1
        adc #0
        ; temp. save the registers
        sta resa
        stx resx
        sty resy
        ; check the flags
        php
        pla
        and #%11010011
        ldx zpxbuf
        cmp result_flags,x
        bne testpage_imm_fail_f

        lda resa
        cmp result_akku,x
        bne testpage_imm_fail_a
        
        ldx zpxbuf
        inx
        bne testpage_imm_loop

        clc
        rts
testpage_imm_fail_a:
testpage_imm_fail_f:
        sec
        rts
        
;-------------------------------------------------------------------------------
; A: opcode to test
testinstr:
        sta testpage_imm_instr
        sta testpage_imm_instr2

        lda #0
        sta testpage_imm_imm
        sta testpage_imm_imm2
        
        ;lda #$38    ; sec
        lda #$18    ; clc
        sta testpage_imm_clc
        sta testpage_imm_clc2
        
        jsr testinstr2
        bcc +
        rts
+
        
        lda #0
        sta testpage_imm_imm
        sta testpage_imm_imm2
        
        lda #$38    ; sec
        ;lda #$18    ; clc
        sta testpage_imm_clc
        sta testpage_imm_clc2
        
        jsr testinstr2
        
        rts

testinstr2:
        sed
        lda testpage_imm_instr
        and #$0f
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+2
        lda testpage_imm_instr
        lsr
        lsr
        lsr
        lsr
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+1
        cld
        
        ldy #0
-
        sty testinstr2yb

        sed
        lda testpage_imm_imm
        and #$0f
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+5
        lda testpage_imm_imm
        lsr
        lsr
        lsr
        lsr
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+4
        cld
        
        jsr testpage_imm
        bcc +
        ; C=1 compare failed, instruction depends on decimal flag
        rts
+

        inc testpage_imm_imm
        inc testpage_imm_imm2

testinstr2yb = * + 1
        ldy #0
        iny
        bne -
        
        clc
        rts
        
;-------------------------------------------------------------------------------
; A: opcode to test
testinstrzp:
        sta testpage_zp_instr
        sta testpage_zp_instr2

        lda #$20    ; zp addr = $20
        sta testpage_zp_imm
        sta testpage_zp_imm2
        sta testpage_zp_imm3
        sta testpage_zp_imm4
        
        ;lda #$38    ; sec
        lda #$18    ; clc
        sta testpage_zp_clc
        sta testpage_zp_clc2
        
        jsr testinstrzp2
        bcc +
        rts
+
        lda #$20    ; zp addr = $20
        sta testpage_zp_imm
        sta testpage_zp_imm2
        sta testpage_zp_imm3
        sta testpage_zp_imm4
        
        lda #$38    ; sec
        ;lda #$18    ; clc
        sta testpage_zp_clc
        sta testpage_zp_clc2
        
        jsr testinstrzp2
        
        rts
        
testinstrzp2:
        sed
        lda testpage_zp_instr
        and #$0f
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+2
        lda testpage_zp_instr
        lsr
        lsr
        lsr
        lsr
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+1
        cld
        
        ldy #0
-
        sty testinstrzp2yb

        sed
        lda testpage_zp_zpval
        and #$0f
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+5
        lda testpage_zp_zpval
        lsr
        lsr
        lsr
        lsr
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+4
        cld
        
        jsr testpage_zp
        bcc +
        ; C=1 compare failed, instruction depends on decimal flag
        rts
+

        inc testpage_zp_zpval
        inc testpage_zp_zpval2

;         inc testpage_imm_imm
;         inc testpage_imm_imm2
; 
testinstrzp2yb = * + 1
        ldy #0
        iny
        bne -
        
        clc
        rts

;------------------------------------------------------------------------------
        
main:

        ; skip instructions
        ldx #0
-
        ldy testinstr_skip,x
        lda #'.'
        sta $0400,y

        inx
        cpx #testinstr_skip_num
        bne -

        ; immediate instructions
        ldx #0
-
        stx mainloopctr
        lda instr_list_imm,x
        sta currinstr

        jsr testinstr
        lda #13 ; green
        bcc +
        ; C=1 compare failed, instruction depends on decimal flag
        lda #10 ; red
+
        ldx currinstr
        sta $0400,x
        sta $d800,x
mainloopctr = * + 1
        ldx #0
        inx
        cpx #testinstr_imm_num
        bne -

        ; zp instructions
        ldx #0
-
        stx mainloopctr2
        lda testinstr_zp,x
        sta currinstr
        
        jsr testinstrzp
        lda #13 ; green
        bcc +
        ; C=1 compare failed, instruction depends on decimal flag
        lda #10 ; red
+
        ldx currinstr
        sta $0400,x
        sta $d800,x
mainloopctr2 = * + 1
        ldx #0
        inx
        cpx #testinstr_zp_num
        bne -

        ldx #0
-
        lda scanreference,x
        cmp $0400,x
        bne scanerror
        
        inx
        bne -

        lda #13 ; green
        sta $d020
        lda #$00
        sta $d7ff
        jmp *

scanerror:
        lda #10
        sta $d020
        lda #$ff
        sta $d7ff
        jmp *
        
;------------------------------------------------------------------------------
        
testinstr_skip:
        !byte $00 ; brk
        
        !byte $40 ; rti
        !byte $60 ; rts
        
        !byte $4c ; jmp abs
        !byte $6c ; jmp ind
        
        !byte $10 ; bpl rel
        !byte $30 ; bmi rel
        !byte $50 ; bvc rel
        !byte $70 ; bvs rel
        !byte $90 ; bcc rel
        !byte $b0 ; bcs rel
        !byte $d0 ; bne rel
        !byte $f0 ; beq rel
        
        !byte $18 ; clc
        !byte $38 ; sec
        !byte $d8 ; cld
        !byte $f8 ; sed
        !byte $58 ; cli
        !byte $78 ; sei
        !byte $b8 ; clv
        
        !byte $02 ; jam
        !byte $12 ; jam
        !byte $22 ; jam
        !byte $32 ; jam
        !byte $42 ; jam
        !byte $52 ; jam
        !byte $62 ; jam
        !byte $72 ; jam
        !byte $92 ; jam
        !byte $b2 ; jam
        !byte $d2 ; jam
        !byte $f2 ; jam

        !byte $8b ; ane #imm - FIXME: must be tested in border (RDY)
        !byte $ab ; lax #imm - FIXME: must be tested in border (RDY)
        
testinstr_skip_num = * - testinstr_skip
        
instr_list_imm:
        !byte $09 ; ora #imm
        !byte $0b ; anc #imm
        !byte $29 ; and #imm
        !byte $2b ; anc #imm
        !byte $49 ; eor #imm
        !byte $4b ; alc #imm
        !byte $69 ; adc #imm ; *
        !byte $6b ; arr #imm ; * (u)
        !byte $80 ; nop #imm
        !byte $82 ; nop #imm
        !byte $89 ; nop #imm
;        !byte $8b ; ane #imm - FIXME: must be tested in border (RDY)
        !byte $a0 ; ldy #imm
        !byte $a2 ; ldx #imm
        !byte $a9 ; lda #imm
;        !byte $ab ; lax #imm - FIXME: must be tested in border (RDY)
        !byte $c0 ; cpy #imm
        !byte $c2 ; nop #imm
        !byte $c9 ; cmp #imm
        !byte $cb ; sbx #imm
        !byte $e0 ; cpx #imm
        !byte $e2 ; nop #imm
        !byte $E9 ; sbc #imm ; *
        !byte $eb ; sbc #imm ; * (u)
testinstr_imm_num = * - instr_list_imm

testinstr_zp:
        !byte $04   ; nop zp
        !byte $05   ; ora zp
        !byte $06   ; asl zp
        !byte $07   ; slo zp
        !byte $24   ; bit zp
        !byte $25   ; and zp
        !byte $26   ; rol zp
        !byte $27   ; rla zp
        !byte $44   ; nop zp
        !byte $45   ; eor zp
        !byte $46   ; lsr zp
        !byte $47   ; sre zp
        !byte $64   ; nop zp
        !byte $65   ; adc zp ; *
        !byte $66   ; ror zp
        !byte $67   ; rra zp ; * (u)
        !byte $84   ; sty zp
        !byte $85   ; sta zp
        !byte $86   ; stx zp
        !byte $87   ; sax zp
        !byte $a4   ; ldy zp
        !byte $a5   ; lda zp
        !byte $a6   ; ldx zp
        !byte $a7   ; lax zp
        !byte $c4   ; cpy zp
        !byte $c5   ; cmp zp
        !byte $c6   ; dec zp
        !byte $c7   ; dcp zp
        !byte $e4   ; cpx zp
        !byte $e5   ; sbc zp ; *
        !byte $e6   ; inc zp
        !byte $e7   ; isc zp ; * (u)
testinstr_zp_num = * - testinstr_zp

;------------------------------------------------------------------------------

scanreference:
        !binary "scannerref.bin"
