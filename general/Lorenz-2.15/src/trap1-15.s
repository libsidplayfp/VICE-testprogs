; this file is part of the C64 Emulator Test Suite. public domain, no copyright

; original file was: trap1-15.asm
;-------------------------------------------------------------------------------

TESTFAILURE = 0

            .include "common.asm"
            .include "printhb.asm"
            .include "waitborder.asm"
            ;.include "waitkey.asm"
            ;.include "showregs.asm"

;------------------------------------------------------------------------------
thisname   ; name of this test
           .text "trap"
           .ifmi TRAP - 10
           .byte $30 + TRAP
           .else
           .byte $31
           .byte $30 + (TRAP - 10)
           .endif
           .byte 0
nextname   ; name of next test, "-" means no more tests
           .text "trap"
           .ifmi TRAP - 9
           .byte $31 + TRAP
           .else
           .byte $31
           .byte $30 + (TRAP - 9)
           .endif
;------------------------------------------------------------------------------


; #  code  data  zd  zptr   aspect tested
;-----------------------------------------------------------------------------
; 1  2800  29C0  F7  F7/F8  basic functionality
.ifeq TRAP - 1
code       = $2800
data       = $29c0
zerodata   = $f7
zeroptr    = $f7;$f8
.endif
; 2  2FFE  29C0  F7  F7/F8  4k boundary within 3 byte commands
.ifeq TRAP - 2
code       = $2ffe
data       = $29c0
zerodata   = $f7
zeroptr    = $f7;$f8
.endif
; 3  2FFF  29C0  F7  F7/F8  4k boundary within 2 and 3 byte commands
.ifeq TRAP - 3
code       = $2fff
data       = $29c0
zerodata   = $f7
zeroptr    = $f7;$f8
.endif
; 4  D000  29C0  F7  F7/F8  IO traps for code fetch
.ifeq TRAP - 4
code       = $d000
data       = $29c0
zerodata   = $f7
zeroptr    = $f7;$f8
.endif
; 5  CFFE  29C0  F7  F7/F8  RAM/IO boundary within 3 byte commands
.ifeq TRAP - 5
code       = $cffe
data       = $29c0
zerodata   = $f7
zeroptr    = $f7;$f8
.endif
; 6  CFFF  29C0  F7  F7/F8  RAM/IO boundary within 2 and 3 byte commands
.ifeq TRAP - 6
code       = $cfff
data       = $29c0
zerodata   = $f7
zeroptr    = $f7;$f8
.endif
; 7  2800  D0C0  F7  F7/F8  IO traps for 16 bit data access
.ifeq TRAP - 7
code       = $2800
data       = $d0c0
zerodata   = $f7
zeroptr    = $f7;$f8
.endif
; 8  2800  D000  F7  F7/F8  IO trap adjustment in ax, ay and iy addressing
.ifeq TRAP - 8
code       = $2800
data       = $d000
zerodata   = $f7
zeroptr    = $f7;$f8
.endif
; 9  2800  29C0  02  F7/F8  wrap around in zx and zy addressing
.ifeq TRAP - 9
code       = $2800
data       = $29c0
zerodata   = $02
zeroptr    = $f7;$f8
.endif
;10  2800  29C0  00  F7/F8  IO traps for 8 bit data access
.ifeq TRAP - 10
code       = $2800
data       = $29c0
zerodata   = $00
zeroptr    = $f7;$f8
.endif
;11  2800  29C0  F7  02/03  wrap around in ix addressing
.ifeq TRAP - 11
code       = $2800
data       = $29c0
zerodata   = $f7
zeroptr    = $02;$03
.endif
;12  2800  29C0  F7  FF/00  wrap around and IO trap for pointer accesses
.ifeq TRAP - 12
code       = $2800
data       = $29c0
zerodata   = $f7
zeroptr    = $ff;$00
.endif
;13  2800  0002  F7  F7/F8  64k wrap around in ax, ay and iy addressing
.ifeq TRAP - 13
code       = $2800
data       = $0002
zerodata   = $f7
zeroptr    = $f7;$f8
.endif
;14  2800  0000  F7  F7/F8  64k wrap around plus IO trap
.ifeq TRAP - 14
code       = $2800
data       = $0000
zerodata   = $f7
zeroptr    = $f7;$f8
.endif
;15  CFFF  D0C6  00  FF/00  1-14 all together as a stress test
.ifeq TRAP - 15
code       = $cfff
data       = $d0c6
zerodata   = $00
zeroptr    = $ff;$00
.endif


ptable     = 172    ;173
bcmd       .byte 0  ;opcode
pcode      = 174    ;175

db         = %00011011
ab         = %11000110
xb         = %10110001
yb         = %01101100

da         = data
aa         .byte 0
xa         .byte 0
ya         .byte 0
pa         .byte 0

main:
           jsr waitborder
           ; read ANE "magic constant"
           lda #0
           ldx #$ff
           ane #$ff
           sta anemagic

           ; calc reference test result
           lda #$c6 ; value in A
anemagic = * + 1
           ora #0
           and #$1b ; immediate value used in the test
           and #$b1 ; value in X
           sta aneresult
           ; reference status
           lda aneresult
           and #$80
           ora #$30
           sta aneresultstatus
           lda aneresult
           bne sk1
           lda aneresultstatus
           ora #$02
           sta aneresultstatus
sk1:
            jsr print
            .text 13, "ane magic value: ", 0
            lda anemagic
            jsr printhb

           jsr waitborder
           ; read the LAX "magic constant"
           lda #0
           .byte $ab, $ff
           sta laxmagic
           ; calc reference test result
           lda #$c6 ; value in A
laxmagic = * + 1
           ora #0
           and #$1b ; immediate value used in the test
           sta laxresulta
           sta laxresultx
           ; reference status
           lda laxresulta
           and #$80
           ora #$30
           sta laxresultstatus
           lda laxresulta
           bne sk2
           lda laxresultstatus
           ora #$02
           sta laxresultstatus
sk2:
            jsr print
            .text 13, "lxa magic value: ", 0
            lda laxmagic
            jsr printhb


           lda #<code
           sta pcode+0
           lda #>code
           sta pcode+1

           lda #<table
           sta ptable+0
           lda #>table
           sta ptable+1

nextcommand

           ldy #0
           lda bcmd
           sta (pcode),y
           lda #$60
           iny
           sta (pcode),y
           iny
           sta (pcode),y
           iny
           sta (pcode),y
           ldy #3
           lda (ptable),y
           sta jump+1
           iny
           lda (ptable),y
           sta jump+2

           jsr waitborder

jump       jsr $1111

.ifeq (TESTFAILURE - 1)
            jmp error
.endif

           ldy #5
           lda da
           cmp (ptable),y
           bne error
           iny
           lda aa
           cmp (ptable),y
           bne error
           iny
           lda xa
           cmp (ptable),y
           bne error
           iny
           lda ya
           cmp (ptable),y
           bne error
           iny
           lda pa
           cmp (ptable),y
           bne error
nostop
           clc
           lda ptable+0
           adc #10
           sta ptable+0
           lda ptable+1
           adc #0
           sta ptable+1
           inc bcmd
           bne jmpnextcommand
           jmp ok
jmpnextcommand
           jmp nextcommand

error
           lda #13
           jsr $ffd2
           ldy #0
           lda (ptable),y
           jsr $ffd2
           iny
           lda (ptable),y
           jsr $ffd2
           iny
           lda (ptable),y
           jsr $ffd2
           lda #32
           jsr $ffd2
           lda bcmd
           jsr printhb
           jsr print
           .byte 13
           .text "after  "
           .byte 0
           lda da
           jsr printhb
           lda #32
           jsr $ffd2
           jsr $ffd2
           lda aa
           jsr printhb
           lda #32
           jsr $ffd2
           lda xa
           jsr printhb
           lda #32
           jsr $ffd2
           lda ya
           jsr printhb
           lda #32
           jsr $ffd2
           jsr $ffd2
           lda pa
           jsr printhb
           jsr print
           .byte 13
           .text "right  "
           .byte 0
           ldy #5
           lda (ptable),y
           jsr printhb
           lda #32
           jsr $ffd2
           jsr $ffd2
           iny
           lda (ptable),y
           jsr printhb
           lda #32
           jsr $ffd2
           iny
           lda (ptable),y
           jsr printhb
           lda #32
           jsr $ffd2
           iny
           lda (ptable),y
           jsr printhb
           lda #32
           jsr $ffd2
           jsr $ffd2
           iny
           lda (ptable),y
           jsr printhb
;           lda #13
;           jsr $ffd2

            ; show magic again
            jsr waitborder

            lda #0
            ldx #$ff
            .byte $8b, $ff
            sta anemagic

            ; read the LAX "magic constant"
            lda #0
            .byte $ab, $ff
            sta laxmagic

            jsr print
            .text 13, "ane magic value: ", 0
            lda anemagic
            jsr printhb

            jsr print
            .text 13, "lax magic value: ", 0
            lda laxmagic
            jsr printhb

            lda #13
            jsr cbmk_bsout

            #SET_EXIT_CODE_FAILURE

wait     jsr $ffe4
         beq wait

           jmp nostop
return
           lda #$37
           sta 1
           lda #$2f
           sta 0
           rts

ok
            rts ; SUCCESS


savesp     .byte 0
savedstack = $2a00;2aff


savestack
           .block
           tsx
           stx savesp
           ldx #0
save
           lda $0100,x
           sta savedstack,x
           inx
           bne save
           rts
           .bend


restorestack
           .block
           pla
           sta retlow+1
           pla
           sta rethigh+1
           ldx savesp
           inx
           inx
           txs
           ldx #0
restore
           lda savedstack,x
           sta $0100,x
           inx
           bne restore
rethigh
           lda #$11
           pha
retlow
           lda #$11
           pha
           rts
           .bend

execute
           lda #0
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jsr jmppcode
           php
           cld
           sta aa
           stx xa
           sty ya
           pla
           sta pa
           rts

jmppcode
           jmp (pcode)

n
           jsr execute
           rts

b
           lda #db
           ldy #1
           sta (pcode),y
           jsr execute
           rts

z
           lda #zerodata
           ldy #1
           sta (pcode),y
           lda #db
           sta zerodata
           jsr execute
           lda zerodata
           sta da
           rts

zx
           lda #(zerodata-xb)&$ff
           ldy #1
           sta (pcode),y
           lda #db
           sta zerodata
           jsr execute
           lda zerodata
           sta da
           rts

zy
           lda #(zerodata-yb)&$ff
           ldy #1
           sta (pcode),y
           lda #db
           sta zerodata
           jsr execute
           lda zerodata
           sta da
           rts

ac
           ldy #1
           lda #<da
           sta (pcode),y
           iny
           lda #>da
           sta (pcode),y
           jsr execute
           rts

ax
           ldy #1
           lda #<(da-xb)
           sta (pcode),y
           iny
           lda #>(da-xb)
           sta (pcode),y
           jsr execute
           rts

ay
           ldy #1
           lda #<(da-yb)
           sta (pcode),y
           iny
           lda #>(da-yb)
           sta (pcode),y
           jsr execute
           rts

ix
           ldy #1
           lda #(zeroptr-xb)&$ff
           sta (pcode),y
           lda #<da
           sta zeroptr+0&$ff
           lda #>da
           sta zeroptr+1&$ff
           jsr execute
           rts

iy
           ldy #1
           lda #zeroptr
           sta (pcode),y
           lda #<(da-yb)
           sta zeroptr+0&$ff
           lda #>(da-yb)
           sta zeroptr+1&$ff
           jsr execute
           rts

r
           lda #1
           ldy #1
           sta (pcode),y
           lda #0
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jsr jmppcode
           lda #$f3
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jsr jmppcode
           dec pcode+1
           lda #$60
           ldy #130
           sta (pcode),y
           inc pcode+1
           lda #128
           ldy #1
           sta (pcode),y
           lda #0
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jsr jmppcode
           lda #$f3
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jsr jmppcode
           php
           cld
           sta aa
           stx xa
           sty ya
           pla
           sta pa
           rts

hltn
           lda #0
           sta da
           sta aa
           sta xa
           sta ya
           sta pa
           rts

brkn
           .block
           lda #<continue
           sta $fffe
           lda #>continue
           sta $ffff
           sei
           lda 0
           sta old0+1
           lda #47
           sta 0
           lda 1
           sta old1+1
           and #$fd
           sta 1
           lda #0
           pha
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jmp (pcode)
continue
           php
           cld
           sta aa
           stx xa
           sty ya
           pla
           sta pa
old1
           lda #$11
           sta 1
old0
           lda #$11
           sta 0
           lda #db
           sta da
           cli
           pla
           pla
           pla
           rts
           .bend

jmpi
           .block
           lda #<zeroptr
           ldy #1
           sta (pcode),y
           lda #>zeroptr
           iny
           sta (pcode),y
           lda #<continue
           sta zeroptr+0&$ff
           lda #>continue
           sta zeroptr+1&$ff
           lda #0
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jmp (pcode)
continue
           php
           cld
           sta aa
           stx xa
           sty ya
           pla
           sta pa
           rts
           .bend

jmpw
           .block
           lda #<continue
           ldy #1
           sta (pcode),y
           lda #>continue
           iny
           sta (pcode),y
           lda #0
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jmp (pcode)
continue
           php
           cld
           sta aa
           stx xa
           sty ya
           pla
           sta pa
           rts
           .bend

jsrw
           .block
           lda #<continue
           ldy #1
           sta (pcode),y
           lda #>continue
           iny
           sta (pcode),y
           lda #0
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jmp (pcode)
continue
           php
           cld
           sta aa
           stx xa
           sty ya
           pla
           sta pa
           pla
           pla
           rts
           .bend


rtin
           .block
           lda #>continue
           pha
           lda #<continue
           pha
           lda #$b3
           pha
           lda #0
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jmp (pcode)
continue
           php
           cld
           sta aa
           stx xa
           sty ya
           pla
           sta pa
           rts
           .bend

txsn
           .block
           lda #$4c
           ldy #1
           sta (pcode),y
           lda #<continue
           iny
           sta (pcode),y
           lda #>continue
           iny
           sta (pcode),y
           jsr savestack
           lda #0
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jmp (pcode)
continue
           php
           cld
           sta aa
           stx xa
           sty ya
           pla
           sta pa
           tsx
           stx newsp+1
           jsr restorestack
newsp
           lda #$11
           cmp #xb
           bne wrong
           rts
wrong
           pla
           pla
           jmp error
           .bend

plan
           .block
           lda #$4c
           ldy #1
           sta (pcode),y
           lda #<continue
           iny
           sta (pcode),y
           lda #>continue
           iny
           sta (pcode),y
           lda #$f0
           pha
           lda #0
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jmp (pcode)
continue
           php
           cld
           sta aa
           stx xa
           sty ya
           pla
           sta pa
           rts
           .bend

phan
           .block
           lda #$4c
           ldy #1
           sta (pcode),y
           lda #<continue
           iny
           sta (pcode),y
           lda #>continue
           iny
           sta (pcode),y
           lda #0
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jmp (pcode)
continue
           php
           cld
           sta aa
           stx xa
           sty ya
           pla
           sta pa
           pla
           cmp #ab
           bne wrong
           rts
wrong
           pla
           pla
           jmp error
           .bend

plpn
           .block
           lda #$4c
           ldy #1
           sta (pcode),y
           lda #<continue
           iny
           sta (pcode),y
           lda #>continue
           iny
           sta (pcode),y
           lda #$b3
           pha
           lda #0
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jmp (pcode)
continue
           php
           cld
           sta aa
           stx xa
           sty ya
           pla
           sta pa
           rts
           .bend

phpn
           .block
           lda #$4c
           ldy #1
           sta (pcode),y
           lda #<continue
           iny
           sta (pcode),y
           lda #>continue
           iny
           sta (pcode),y
           lda #0
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jmp (pcode)
continue
           php
           cld
           sta aa
           stx xa
           sty ya
           pla
           sta pa
           pla
           cmp #$30
           bne wrong
           rts
wrong
           pla
           pla
           jmp error
           .bend


shaay
           .ifpl da&$ff-$c0
           lda #>da
           clc
           adc #1
           and #ab
           and #xb
           ldy #5
           sta (ptable),y
           jmp ay
           .endif
shaiy
           .ifpl da&$ff-$c0
           lda #>da
           clc
           adc #1
           and #ab
           and #xb
           ldy #5
           sta (ptable),y
           jmp iy
           .endif
shxay
           .ifpl da&$ff-$c0
           lda #>da
           clc
           adc #1
           and #xb
           ldy #5
           sta (ptable),y
           jmp ay
           .endif
shyax
           .ifpl da&$ff-$c0
           lda #>da
           clc
           adc #1
           and #yb
           ldy #5
           sta (ptable),y
           jmp ax
           .endif
shsay
           .ifpl da&$ff-$c0
           .block
           lda #ab
           and #xb
           sta sr+1
           ldx #>da
           inx
           stx andx+1
andx
           and #$11
           ldy #5
           sta (ptable),y
           jsr savestack
           lda #<da-yb
           ldy #1
           sta (pcode),y
           lda #>da-yb
           iny
           sta (pcode),y
           lda #$4c
           iny
           sta (pcode),y
           lda #<continue
           iny
           sta (pcode),y
           lda #>continue
           iny
           sta (pcode),y
           lda #0
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jmp (pcode)
continue
           php
           cld
           sta aa
           stx xa
           sty ya
           pla
           sta pa
           tsx
           stx sa+1
           jsr restorestack
sa
           lda #$11
           ldy #6
sr
           cmp #$11
           bne wrong
           rts
wrong
           pla
           pla
           jmp error
           .bend
           .endif

           .ifmi da&$ff-$c0
           pla
           pla
           jmp nostop
           .endif


lasay
           .block
           tsx
           txa
           and #db
           php
           ldy #6
           sta (ptable),y
           iny
           sta (ptable),y
           pla
           and #%10110010
           ldy #9
           sta (ptable),y
           jsr savestack
           lda #<da-yb
           ldy #1
           sta (pcode),y
           lda #>da-yb
           iny
           sta (pcode),y
           lda #$4c
           iny
           sta (pcode),y
           lda #<continue
           iny
           sta (pcode),y
           lda #>continue
           iny
           sta (pcode),y
           lda #0
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jmp (pcode)
continue
           php
           cld
           sta aa
           stx xa
           sty ya
           pla
           sta pa
           tsx
           stx sa+1
           jsr restorestack
sa
           lda #$11
           ldy #6
           cmp (ptable),y
           bne wrong
           rts
wrong
           pla
           pla
           jmp error
           .bend

tsxn
           jsr execute
           tsx
           dex
           dex
           dex
           dex
           php
           txa
           ldy #7
           sta (ptable),y
           pla
           ldy #9
           sta (ptable),y
           rts

           .include "trap-table.s"
