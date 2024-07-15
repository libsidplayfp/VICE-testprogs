; this file is part of the C64 Emulator Test Suite. public domain, no copyright

; original file was: lxab.asm
;-------------------------------------------------------------------------------

TESTFAILURE = 0

            .include "common.asm"
            .include "printhb.asm"
            .include "showregs.asm"
            .include "waitborder.asm"

;------------------------------------------------------------------------------           
thisname   .null "lxab"      ; name of this test
nextname   .null "sbxb"      ; name of next test, "-" means no more tests
;------------------------------------------------------------------------------ 
main:
        jsr waitborder

        lda #0
        .byte $ab, $ff
        sta magicvalue+1

        jsr print
        .text 13, "magic value: ", 0
        lda magicvalue+1
        jsr hexb

         lda #%00011011
         sta db
         lda #%11000111
         sta ab
         lda #%10110001
         sta xb
         lda #%01101100
         sta yb
         lda #0
         sta pb
         tsx
         stx sb

         lda #0
         sta db

next     lda db
         sta da
         sta dr
         sta cmd+1

         lda ab
magicvalue:
         ora #$ee
         and db
         sta ar
         sta xr

         lda yb
         sta yr

         lda pb
         ora #%00110000
         and #%01111101
         ldx ar
         bne nozero
         ora #%00000010
nozero
         ldx ar
         bpl nominus
         ora #%10000000
nominus
.ifeq (TARGET - TARGETDTV)
         and #$cf
.endif
         sta pr

         lda sb
         sta sr

         jsr waitborder

         ldx sb
         txs
         lda pb
         pha
         lda ab
         ldx xb
         ldy yb
         plp

cmd      .byte $ab      ; LXA #imm
         .byte 0

         php
         cld
         sta aa
         stx xa
         sty ya
         pla
         sta pa
         tsx
         stx sa
         jsr check

         inc ab
         clc
         lda db
         adc #17
         sta db
         bcc jmpnext
         lda #0
         sta db
         clc
         lda xb
         adc #17
         sta xb
         bcc jmpnext
         lda #0
         sta xb
         inc pb
         beq nonext
jmpnext  jmp next
nonext

         rts ; success

db       .byte 0
ab       .byte 0
xb       .byte 0
yb       .byte 0
pb       .byte 0
sb       .byte 0
da       .byte 0
aa       .byte 0
xa       .byte 0
ya       .byte 0
pa       .byte 0
sa       .byte 0
dr       .byte 0
ar       .byte 0
xr       .byte 0
yr       .byte 0
pr       .byte 0
sr       .byte 0

check
         .block
.ifeq (TESTFAILURE - 1)
        jmp error
.endif
         lda da
         cmp dr
         bne error
         lda aa
         cmp ar
         bne error
         lda xa
         cmp xr
         bne error
         lda ya
         cmp yr
         bne error
         lda pa
.ifeq (TARGET - TARGETDTV)
         and #$cf
.endif
         cmp pr
         bne error
         lda sa
         cmp sr
         bne error
         rts

error    jsr print
         .byte 13
         .null "before  "
         ldx #<db
         ldy #>db
         jsr showregs
         jsr print
         .byte 13
         .null "after   "
         ldx #<da
         ldy #>da
         jsr showregs
         jsr print
         .byte 13
         .null "right   "
         ldx #<dr
         ldy #>dr
         jsr showregs
;         lda #13
;         jsr cbmk_bsout

        ; show magic again
        jsr waitborder

        lda #0
        .byte $ab, $ff
        sta magicvalue+1

        jsr print
        .text 13, "magic value: ", 0
        lda magicvalue+1
        jsr hexb

        lda #13
        jsr cbmk_bsout

         #SET_EXIT_CODE_FAILURE

wait     jsr $ffe4
         beq wait
         rts

showregs stx 172
         sty 173
         ldy #0
         lda (172),y
         jsr hexb
         lda #32
         jsr cbmk_bsout
         lda #32
         jsr cbmk_bsout
         iny
         lda (172),y
         jsr hexb
         lda #32
         jsr cbmk_bsout
         iny
         lda (172),y
         jsr hexb
         lda #32
         jsr cbmk_bsout
         iny
         lda (172),y
         jsr hexb
         lda #32
         jsr cbmk_bsout
         iny
         lda (172),y
         ldx #"n"
         asl a
         bcc ok7
         ldx #"N"
ok7      pha
         txa
         jsr cbmk_bsout
         pla
         ldx #"v"
         asl a
         bcc ok6
         ldx #"V"
ok6      pha
         txa
         jsr cbmk_bsout
         pla
         ldx #"0"
         asl a
         bcc ok5
         ldx #"1"
ok5      pha
         txa
         jsr cbmk_bsout
         pla
         ldx #"b"
         asl a
         bcc ok4
         ldx #"B"
ok4      pha
         txa
         jsr cbmk_bsout
         pla
         ldx #"d"
         asl a
         bcc ok3
         ldx #"D"
ok3      pha
         txa
         jsr cbmk_bsout
         pla
         ldx #"i"
         asl a
         bcc ok2
         ldx #"I"
ok2      pha
         txa
         jsr cbmk_bsout
         pla
         ldx #"z"
         asl a
         bcc ok1
         ldx #"Z"
ok1      pha
         txa
         jsr cbmk_bsout
         pla
         ldx #"c"
         asl a
         bcc ok0
         ldx #"C"
ok0      pha
         txa
         jsr cbmk_bsout
         pla
         lda #32
         jsr cbmk_bsout
         iny
         lda (172),y
         .bend
hexb     pha
         lsr a
         lsr a
         lsr a
         lsr a
         jsr hexn
         pla
         and #$0f
hexn     ora #$30
         cmp #$3a
         bcc hexn0
         adc #6
hexn0    jmp cbmk_bsout
