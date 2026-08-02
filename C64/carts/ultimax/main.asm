
; CAUTION: on the C64 we get RAM for the first 4k ($0000-$0fff)
;         - however an actual MAX Machine only has 2k ($0000-$07ff)
;         - also CIA1 mirrors on a MAX exist from DC00 to DFFF

!if (CARTTYPE=3) or (CARTTYPE=1) {
ROMCHARSET=0
} else {
ROMCHARSET=1
}

        * = $0000

        !if (CARTTYPE=0) or (CARTTYPE=2) or (CARTTYPE=3) {
        ; Ultimax ROML
        ; MAX Basic ROML
        ; Easyflash ROML
        !byte $c0,$c0
        !scrxor $c0, "-8000-"
        !fill $1000-8, $e0
        !byte $c0,$c0
        !scrxor $c0, "-9000-"
        !fill $1000-8, $e0
        }

stubramloc = $0400

fontramloc = $0800
iotagoffset = 4


        !pseudopc $e000 {

        !if (CARTTYPE=0) or (CARTTYPE=2) or (CARTTYPE=3) {
                ; Ultimax ROMH
                ; MAX Basic ROMH
                ; Easyflash ROMH
                !byte $e0, $e0, $e0, $e0
                !byte $e0, $e0, $e0, $e0, $e0
                !scrxor $c0, "-e000-", $e0
        } else {
                ; for carts that start as 8/16k game cart, we need the
                ; respective header

                ; Retro Replay ROML
                !word start1 - ($e000 - $8000)
                !word start1 - ($e000 - $8000)
                !byte $c3, $c2, $cd, $38, $30
        
                !scrxor $c0, "-8000-", $e0
        }
       
start1:
        ldx #0
-
        lda stub - ($e000 - $8000),x
        sta stubramloc,x
        inx
        bne -
        jmp stubramloc
stub:
        ; Happify CPU ;-)
        sei
        cld
        ldx	#$ff
        txs

        ; we must set data first, then update DDR
        lda #$37
        sta $01
        lda #$2f
        sta $00

        !if CARTTYPE = 1 {  ; retro replay
        lda #%00000011      ; ultimax
        sta $de00
        }

        lda #$33
        sta $01

        jmp start

        ; this runs in ROM again, but now at ROMH (ultimax)
start:

        ; disable irq sources
        lda #$00
        sta $D01A
        lda #$1F
        sta $DC0D
        sta $DD0D
        ; clear pending irqs
        lda $D019
        sta $D019
        lda $DC0D
        lda $DD0D
        
        lda #$1b
        lda #$5b        ; use ECM
        sta $d011
        
        lda #$00
        sta $d021
        lda #$02        ; red = I/O
        sta $d022
        lda #$06        ; blue = ram
        sta $d023
        lda #$05        ; green = rom
        sta $d024

        lda #$a0
        ldx #2
-       sta $00,x
        inx
        bne -

        ; tag zeropage
        lda #'-' | $80
        sta $02
        sta $05
        lda #('Z' - '@') | $80
        sta $03
        lda #('P' - '@') | $80
        sta $04

        !if (ROMCHARSET=1) {
        lda #$1e        ; char at $3800 ($f800)
        } else {
        lda #$13        ; char at $0800
        }
        sta $d018
        
        lda #$03
        sta $dd00
        
        lda #$c8
        sta $d016
        
        lda #0
        sta $d021
        
        ; TAG I/O area
        lda #$60
        ldx #$0f
-
        sta $d000,x
        dex
        bpl -
        lda #('V' - '@') | $40
        sta $d000+iotagoffset
        lda #('I' - '@') | $40
        sta $d001+iotagoffset
        lda #('C' - '@') | $40
        sta $d002+iotagoffset
        lda #$60
        sta $d003+iotagoffset

        lda #('C' - '@') | $40
        sta $dc00+iotagoffset
        sta $dd00+iotagoffset
        lda #('I'      ) | $40
        sta $dc01+iotagoffset
        sta $dd01+iotagoffset
        lda #('A' - '@') | $40
        sta $dc02+iotagoffset
        sta $dd02+iotagoffset
        ldx #('2'      ) | $40
        stx $dd03+iotagoffset
        dex
        stx $dc03+iotagoffset

        ldx #0
-
        lda #1
        sta $d800,x
        sta $d900,x
        sta $da00,x
        sta $db00,x
        lda #$20
        sta $0400,x
        sta $0500,x
        sta $0600,x
        sta $0700,x
        inx
        bne -

        ; copy font first, before tagging memory. the tags will slightly
        ; corrupt the font, but this does not really matter
        !if (ROMCHARSET=0) {
        ldx #0
-
        lda characters+$000,x
        sta fontramloc+$000,x
        eor #$ff
        sta fontramloc+$400,x

        lda characters+$100,x
        sta fontramloc+$100,x
        eor #$ff
        sta fontramloc+$500,x

        lda characters+$200,x
        sta fontramloc+$200,x
        eor #$ff
        sta fontramloc+$600,x

        lda characters+$200,x
        sta fontramloc+$300,x
        eor #$ff
        sta fontramloc+$700,x
        inx
        bne -
        }

tagoffset=$fe
        lda #6
        sta $d800+tagoffset
        sta $d801+tagoffset
        sta $d900+tagoffset
        sta $d901+tagoffset
        sta $da00+tagoffset
        sta $da01+tagoffset

        lda #'0' | $80
        sta $0ffe
        sta $0efe
        sta $0dfe
        sta $0cfe
        sta $0bfe
        sta $0afe
        sta $09fe
        sta $08fe
        sta $07fe
        sta $06fe
        sta $05fe
        sta $04fe
        sta $03fe
        sta $02fe
        sta $01fe
        sta $00fe

        ldx #('F' - '@') | $80
        stx $0fff
        dex
        stx $0eff
        dex
        stx $0dff
        dex
        stx $0cff
        dex
        stx $0bff
        dex
        stx $0aff

        ldx #'9' | $80
        stx $09ff
        dex
        stx $08ff
        dex
        stx $07ff
        dex
        stx $06ff
        dex
        stx $05ff
        dex
        stx $04ff
        dex
        stx $03ff
        dex
        stx $02ff
        dex
        stx $01ff
        dex
        stx $00ff


base=$0400+(0*40)

mainloop:

;         ldx #0
; -       txa
;         sta $0700,x
;         inx
;         bne -

tag4koffset=2
tag4kdumplen=$0d

        ; first dump beginning of each 4k block

        ldx #0
-
        lda $0000+tag4koffset,x
        sta base+(0*40),x
        lda $1000+tag4koffset,x
        sta base+(1*40),x
        lda $2000+tag4koffset,x
        sta base+(2*40),x
        lda $3000+tag4koffset,x
        sta base+(3*40),x
        lda $4000+tag4koffset,x
        sta base+(4*40),x
        lda $5000+tag4koffset,x
        sta base+(5*40),x
        lda $6000+tag4koffset,x
        sta base+(6*40),x
        lda $7000+tag4koffset,x
        sta base+(7*40),x
        lda $8000+tag4koffset,x
        sta base+(8*40),x
        lda $9000+tag4koffset,x
        sta base+(9*40),x
        lda $a000+tag4koffset,x
        sta base+(10*40),x
        lda $b000+tag4koffset,x
        sta base+(11*40),x
        lda $c000+tag4koffset,x
        sta base+(12*40),x
        lda $d000+tag4koffset,x
        sta base+(13*40),x
        lda $e000+tag4koffset,x
        sta base+(14*40),x
        lda $f000+tag4koffset,x
        sta base+(15*40),x

        inx
        cpx #tag4kdumplen
        bne -

        ; probe each page of the first 4k
        ; $800-$fff are on-cartridge for MAX Basic!
        ldx #0
-
        lda $0000+tagoffset,x
        sta $0400+$11+(0*40),x
        lda $0100+tagoffset,x
        sta $0400+$11+(1*40),x
        lda $0200+tagoffset,x
        sta $0400+$11+(2*40),x
        lda $0300+tagoffset,x
        sta $0400+$11+(3*40),x
        lda $0400+tagoffset,x
        sta $0400+$11+(4*40),x
        lda $0500+tagoffset,x
        sta $0400+$11+(5*40),x
        lda $0600+tagoffset,x
        sta $0400+$11+(6*40),x
        lda $0700+tagoffset,x
        sta $0400+$11+(7*40),x
        lda $0800+tagoffset,x
        sta $0400+$11+(8*40),x
        lda $0900+tagoffset,x
        sta $0400+$11+(9*40),x
        lda $0a00+tagoffset,x
        sta $0400+$11+(10*40),x
        lda $0b00+tagoffset,x
        sta $0400+$11+(11*40),x
        lda $0c00+tagoffset,x
        sta $0400+$11+(12*40),x
        lda $0d00+tagoffset,x
        sta $0400+$11+(13*40),x
        lda $0e00+tagoffset,x
        sta $0400+$11+(14*40),x
        lda $0f00+tagoffset,x
        sta $0400+$11+(15*40),x

        inx
        cpx #$02
        bne -

        ; probe each page of the i/o area
        ldx #0
-
        lda $d000+iotagoffset,x
        sta $0400+$18+(0*40),x
        lda $d100+iotagoffset,x
        sta $0400+$18+(1*40),x
        lda $d200+iotagoffset,x
        sta $0400+$18+(2*40),x
        lda $d300+iotagoffset,x
        sta $0400+$18+(3*40),x
        lda $d400+iotagoffset,x
        sta $0400+$18+(4*40),x
        lda $d500+iotagoffset,x
        sta $0400+$18+(5*40),x
        lda $d600+iotagoffset,x
        sta $0400+$18+(6*40),x
        lda $d700+iotagoffset,x
        sta $0400+$18+(7*40),x
        lda $d800+iotagoffset,x
        sta $0400+$18+(8*40),x
        lda $d900+iotagoffset,x
        sta $0400+$18+(9*40),x
        lda $da00+iotagoffset,x
        sta $0400+$18+(10*40),x
        lda $db00+iotagoffset,x
        sta $0400+$18+(11*40),x
        lda $dc00+iotagoffset,x
        sta $0400+$18+(12*40),x
        lda $dd00+iotagoffset,x
        sta $0400+$18+(13*40),x
        lda $de00+iotagoffset,x
        sta $0400+$18+(14*40),x
        lda $df00+iotagoffset,x
        sta $0400+$18+(15*40),x

        inx
        cpx #$05
        bne -


        inc $d020
        dec $d020
        jmp mainloop

!if (ROMCHARSET=0) {
characters:
	!src "charset.asm"
}

}

        !if CARTTYPE=1 {
        ; Retro Replay
        * = $0e00
        !scrxor $c0, "0e"
        * = $0f00
        !scrxor $c0, "0f"
        * = $1000
        !byte $e0,$e0
        !scrxor $c0, "-8000-"
        !byte $e0,$e0,$e0,$e0,$e0,$e0,$e0,$e0
        * = $1800
        !src "charset.asm"
        * = $1ffa
        !word start
        !word start
        !word start
        }

        !if (CARTTYPE=0) or (CARTTYPE=2) or (CARTTYPE=3) {
        ; ultimax
        ; MAX BASIC
        ; Easyflash
        * = $3000
        !byte $e0,$e0
        !scrxor $c0, "-f000-"
        !byte $e0,$e0,$e0,$e0,$e0,$e0,$e0,$e0
        * = $3800
        !src "charset.asm"
        * = $3ffa
        !word start
        !word start
        !word start
        }
