; this file is part of the C64 Emulator Test Suite. public domain, no copyright

; original file was: bplr.asm
;-------------------------------------------------------------------------------

            .include "common.asm"
            .include "printhb.asm"
            .include "showregs.asm"

;------------------------------------------------------------------------------           
thisname   .null "bplr"      ; name of this test
nextname   .null "bcsr"      ; name of next test, "-" means no more tests
;------------------------------------------------------------------------------ 
main:
         lda #%00011011
         sta db
         lda #%11000110
         sta ab
         lda #%10110001
         sta xb
         lda #%01101100
         sta yb
         lda #%00000000
         sta pb
         tsx
         stx sb

         lda #0
         sta db

         lda #<break
         sta $0316
         lda #>break
         sta $0317

         ldx #0
         txa
fill     sta $1082,x
         sta $1182,x
         inx
         bne fill

next     lda db
         sta da
         sta dr

         lda ab
         sta ar

         lda xb
         sta xr

         lda yb
         sta yr

         lda pb
         ora #%00110000
.ifeq (TARGET - TARGETDTV)
         and #$cf
.endif
         sta pr

         ldx cmd+1
         lda branch
         sta $1100,x
         lda db
         sta $1101,x

         ldx sb
         stx sr
         txs
         lda pb
         pha
         lda ab
         ldx xb
         ldy yb
         plp

cmd      jmp $1100

break    pla
         sta ya
         pla
         sta xa
         pla
         sta aa
         pla
         sta pa
         pla
         sta al+1
         pla
         sta ah+1
         tsx
         stx sa

         clc
         lda cmd+1
         ldy cmd+2
         adc #4
         bcc noinc
         iny
noinc    bit db
         bpl pos
         dey
pos      clc
         adc db
         bcc al
         iny
al       cmp #0
         bne err
ah       cpy #0
         beq noerr
err      jsr print
         .byte 13
         .text "wrong jump address"
         .byte 13,0
         jsr wait
noerr    jsr check

         inc db
         lda db
         cmp #$fe
         bne jmpnext
         lda #0
         sta db
         ldx cmd+1
         sta $1100,x
         inc cmd+1
         beq nonext
jmpnext  jmp next
nonext
         lda #$80
branch   bpl berr

ookk     jsr print
         .text " - ok"
         .byte 13,0
         lda #0         ; success
         sta $d7ff
         jmp load

berr     jsr print
         .byte 13
         .text "no jump expected"
         .byte 13,0
         jsr wait
         jmp ookk

load     jsr print
name     .text "bcsr"
namelen  = *-name
         .byte 0
         lda #0
         sta $0a
         sta $b9
         lda #namelen
         sta $b7
         lda #<name
         sta $bb
         lda #>name
         sta $bc
         pla
         pla
         jmp $e16f

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

check    lda da
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
         lda #13
         jsr $ffd2

         lda #$ff       ; failure
         sta $d7ff

wait     jsr $ffe4
         beq wait
         rts
