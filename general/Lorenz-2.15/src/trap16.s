; this file is part of the C64 Emulator Test Suite. public domain, no copyright

; original file was: trap16.asm
;-------------------------------------------------------------------------------

            .include "common.asm"
            .include "printhb.asm"
            .include "waitborder.asm"
            ;.include "waitkey.asm"
            ;.include "showregs.asm"

;-------------------------------------------------------------------------------
thisname:   .null "trap16"      ; name of this test
nextname:   .null "trap17"      ; name of next test, "-" means no more tests
;-------------------------------------------------------------------------------

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
sk1
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

           jmp main2

code       = $fffe
data       = $03c0
zerodata   = $f7
zeroptr    = $f7;$f8

ptable     = 172;173
bcmd       .byte 0
pcode      = 174;175

db         = %00011011
ab         = %11000110
xb         = %10110001
yb         = %01101100

da         = data
aa         .byte 0
xa         .byte 0
ya         .byte 0
pa         .byte 0

ram
           lda #127
           sta $dc0d
           lda #$03
           sta 0
           lda #$14
           sta 1
           rts

rom
           lda #$2f
           sta 0
           lda #$37
           sta 1
           lda #129
           sta $dc0d
           rts


main2
           lda #<code
           sta pcode+0
           lda #>code
           sta pcode+1

           lda #<table
           sta ptable+0
           lda #>table
           sta ptable+1

nextcommand

           jsr waitborder
;waitborder
;           lda $d011
;           bpl waitborder
;           bmi isborder
;           lda $d012
;           cmp #30
;           bcs waitborder
;isborder
           jsr ram
           lda #$60
           sta $ffff
           sta 2
           sta 3
           ldy #0
           lda bcmd
           sta (pcode),y

           ldy #3
           lda (ptable),y
           sta jump+1
           iny
           lda (ptable),y
           sta jump+2

jump       jsr $1111

           jsr rom

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
           jsr rom
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
           jsr rom
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
           lda #13
           jsr $ffd2

            #SET_EXIT_CODE_FAILURE

wait        jsr $ffe4
            beq wait
           jmp nostop
return
           lda #47
           sta 0
           rts

ok
            rts ; SUCCESS

;-------------------------------------------------------------------------------

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
           sta $ffff
           lda #$87
           sta 0
           jsr execute
           rts

z
           lda #$87
           sta 0
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
           lda #$87;saxz
           sta 0
           lda #zerodata-xb&$ff
           ldy #1
           sta (pcode),y
           lda #db
           sta zerodata
           jsr execute
           lda zerodata
           sta da
           rts

zy
           lda #$87;saxz
           sta 0
           lda #zerodata-yb&$ff
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
           lda #$87;saxz
           sta 0
           ldy #1
           lda #zeroptr-xb&$ff
           sta (pcode),y
           lda #<da
           sta zeroptr+0&$ff
           lda #>da
           sta zeroptr+1&$ff
           jsr execute
           rts

iy
           lda #$87;saxz
           sta 0
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
           lda #$87
           sta 0
           lda #2
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
           lda #$4c
           sta $3000
           lda #<continue
           sta $3001
           lda #>continue
           sta $3002
           lda #$00
           sta $fffe
           lda #$30
           sta $ffff
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
           lda #$00
           sta $ffff
           lda #$33
           sta 0
           lda #<continue
           sta $3300
           lda #>continue
           sta $3301
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
           lda #$00
           sta $ffff
           lda #$33
           sta 0
           lda #$4c
           sta $3300
           lda #<continue
           sta $3301
           lda #>continue
           sta $3302
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
           lda #$00
           sta $ffff
           lda #$33
           sta 0
           lda #$4c
           sta $3300
           lda #<continue
           sta $3301
           lda #>continue
           sta $3302
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
           sta 3
           lda #<continue
           sta 4
           lda #>continue
           sta 5
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


txsn
           .block
           lda #$0c
           sta $ffff
           lda #$4c
           sta 2
           lda #<continue
           sta 3
           lda #>continue
           sta 4
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
           lda #$0c
           sta $ffff
           lda #$4c
           sta 2
           lda #<continue
           sta 3
           lda #>continue
           sta 4
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
           lda #$0c
           sta $ffff
           lda #$4c
           sta 2
           lda #<continue
           sta 3
           lda #>continue
           sta 4
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
           lda #$0c
           sta $ffff
           lda #$4c
           sta 2
           lda #<continue
           sta 3
           lda #>continue
           sta 4
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
           lda #$0c
           sta $ffff
           lda #$4c
           sta 2
           lda #<continue
           sta 3
           lda #>continue
           sta 4
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
           sta 3
           lda #<continue
           sta 4
           lda #>continue
           sta 5
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
