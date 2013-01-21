
    !to "test.prg",cbm

    *=$0801

    !byte $0c, $08, $00, $00, $9e, $20, $32, $35, $36, $30, $00, $00, $00

    sptr = $02
    mptr = $04
    refptr = $06
    maskptr = $08
    cptr = $0a

            *=$0a00

            jmp start

;-------------------------------------------------------------------------------
            
cpubuf:
            !byte 0,0,0,0,0,0,0,0
vicbuf:
            !byte 0,0,0,0,0,0,0,0
            !byte 0,0,0,0,0,0,0,0
            !byte 0,0,0,0,0,0,0,0
            !byte 0,0,0,0,0,0,0,0
            !byte 0,0,0,0,0,0,0,0
            !byte 0,0,0,0,0,0,0,0
            !byte 0,0,0,0,0,0,0,0
            !byte 0,0,0,0,0,0,0,0
cia1buf:
            !byte 0,0,0,0,0,0,0,0
            !byte 0,0,0,0,0,0,0,0
cia2buf:
            !byte 0,0,0,0,0,0,0,0
            !byte 0,0,0,0,0,0,0,0

ramebuf:
            !byte 0,0,0,0,0,0,0,0
            !byte 0,0,0,0,0,0,0,0

;-----------------------------------------------------------

cpuref:
            !byte 0,0,0,$f5,$30,0,0,0
vicref:
            !byte 0,0,0,0,0,0,0,0
            !byte 0,0,0,0,0,0,0,0
            !byte 0,$1b,0,0,0,0,$c8,0
            !byte $15,$71,$f0,0,0,0,0,0
            !byte $fe,$f6,$f1,$f2,$f3,$f4,$f0,$f1
            !byte $f2,$f3,$f4,$f5,$f6,$f7,$fc,$ff
            !byte 0,0,0,0,0,0,0,0
            !byte 0,0,0,0,0,0,0,0
cia1ref:
            !byte $7f,$ff,$ff,0,0,0,$ff,$04
            !byte 0,0,0,$01,0,$81,$01,0
cia2ref:
            !byte $07,$ff,$3f,0,$ff,$ff,$ff,$ff
            !byte 0,0,0,$01,0,0,$08,0

rameref:
            !byte $00, $00, $00, $00, $00, $00, $00, $00
            !byte $00, $00, $00, $00, $54, $45, $53, $54
;-----------------------------------------------------------

cpumask:
            !byte $ff, $ff, $ff, $ff, $ff, $00, $00, $00
vicmask:
            !byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
            !byte $ff, $7f, $00, $00, $00, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
cia1mask:
            !byte $ff, $ff, $ff, $ff, $00, $00, $ff, $ff
            !byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
cia2mask:
            !byte $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

ramemask:
            !byte $00, $00, $00, $00, $00, $00, $00, $00
            !byte $00, $00, $00, $00, $ff, $ff, $ff, $ff

;-------------------------------------------------------------------------------

start:
;            inc $d020
;            jmp start

            php ; push status
            sei
            sta cpubuf+0
            stx cpubuf+1
            sty cpubuf+2
            tsx
            stx cpubuf+3
            pla ; get status
            sta cpubuf+4

            ldy #0
lpp1:
            lda $0,y
            sta pages,y
            lda $100,y
            sta pages+$100,y
            lda $200,y
            sta pages+$200,y
            lda $300,y
            sta pages+$300,y
            iny
            bne lpp1

            ldy #0
lpp2:
            lda $9ff0,y
            sta ramebuf,y
            iny
            cpy #$10
            bne lpp2
;            jsr clear

testlp:
            ldy #0
lpv1:
            lda $d000,y
            sta vicbuf,y
            iny
            cpy #$40
            bne lpv1

            ldy #0
lpc1:
            lda $dc00,y
            sta cia1buf,y
            iny
            cpy #$0f
            bne lpc1

            ldy #0
lpc2:
            lda $dd00,y
            sta cia2buf,y
            iny
            cpy #$0f
            bne lpc2

            ; show results

            jsr clear

            ; cpu
            lda #>$0400
            sta sptr+1
            lda #<$0400
            sta sptr

            lda #>cpubuf
            sta mptr+1
            lda #<cpubuf
            sta mptr

            lda #>cpuref
            sta refptr+1
            lda #<cpuref
            sta refptr

            lda #>cpumask
            sta maskptr+1
            lda #<cpumask
            sta maskptr

            lda #1
            jsr doblock

            ; vic
            lda #>($0400+(2*40))
            sta sptr+1
            lda #<($0400+(2*40))
            sta sptr

            lda #>vicbuf
            sta mptr+1
            lda #<vicbuf
            sta mptr

            lda #>vicref
            sta refptr+1
            lda #<vicref
            sta refptr

            lda #>vicmask
            sta maskptr+1
            lda #<vicmask
            sta maskptr

            lda #6
            jsr doblock

            ; cia1
            lda #>($0400+(9*40))
            sta sptr+1
            lda #<($0400+(9*40))
            sta sptr

            lda #>cia1buf
            sta mptr+1
            lda #<cia1buf
            sta mptr

            lda #>cia1ref
            sta refptr+1
            lda #<cia1ref
            sta refptr

            lda #>cia1mask
            sta maskptr+1
            lda #<cia1mask
            sta maskptr

            lda #2
            jsr doblock

            ; cia2
            lda #>($0400+(12*40))
            sta sptr+1
            lda #<($0400+(12*40))
            sta sptr

            lda #>cia2buf
            sta mptr+1
            lda #<cia2buf
            sta mptr

            lda #>cia2ref
            sta refptr+1
            lda #<cia2ref
            sta refptr

            lda #>cia2mask
            sta maskptr+1
            lda #<cia2mask
            sta maskptr

            lda #2
            jsr doblock

            ; end of basic ram
            lda #>($0400+(15*40))
            sta sptr+1
            lda #<($0400+(15*40))
            sta sptr

            lda #>ramebuf
            sta mptr+1
            lda #<ramebuf
            sta mptr

            lda #>rameref
            sta refptr+1
            lda #<rameref
            sta refptr

            lda #>ramemask
            sta maskptr+1
            lda #<ramemask
            sta maskptr

            lda #2
            jsr doblock

            lda #'0'
            jmp skp
;            lda #>(pages+$0000)
;            sta mptr+1
;            lda #<(pages+$0000)
;            sta mptr
;            jsr dopage
;            jmp testlp

;            lda #$37
;            sta $01
;            lda $dc0d
;            cli
mainlp:
            inc $07e5

            jsr $ff9f
            jsr $ffe4
            sta $07e7

            cmp #'0'
            beq skp
            cmp #'1'
            beq skp
            cmp #'2'
            beq skp
            cmp #'3'
            beq skp
            jmp mainlp
skp:
            sec
            sbc #'0'
            tax
            clc
            adc #>pages
            sta mptr+1
            txa
            clc
            adc #>pagesref
            sta refptr+1
            txa
            clc
            adc #>pagesmask
            sta maskptr+1
            lda #0
            sta mptr
            sta refptr
            sta maskptr
            jsr dopage

            jmp mainlp

;-------------------------------------------------------------------------------
dopage:

            ldy #0
plpa:
            lda (mptr),y
            sta $0400+(18*40),y
            iny
            bne plpa

            ldy #0
plpb:
            ldx #7
            lda (maskptr),y
            beq grn
            ldx #5

            lda (mptr),y
            and (maskptr),y
            cmp (refptr),y
            beq grn
            ldx #10
grn:
            txa
            sta $d800+(18*40),y
            iny
            bne plpb
            rts

;-------------------------------------------------------------------------------

doblock:
            sta numlines+1
            ldx #0
lp3:
            stx xtmp+1

            jsr startline

            ldy #0
lp2:
            sty ytmp+1

            lda #5
            sta currcol+1

            lda (maskptr),y
            bne green1
            lda #7
            sta currcol+1
green1:
            lda (mptr),y
            and (maskptr),y
            cmp (refptr),y
            beq green
            lda #10
            sta currcol+1
            sta $d020
green:
            lda (mptr),y
            jsr puthex
            jsr putright

ytmp:       ldy #0
xtmp:       ldx #0
            iny
            cpy #8
            bne lp2

            lda sptr
            clc
            adc #40
            sta sptr
            lda sptr+1
            adc #0
            sta sptr+1

            lda mptr
            clc
            adc #8
            sta mptr
            lda mptr+1
            adc #0
            sta mptr+1

            lda maskptr
            clc
            adc #8
            sta maskptr
            lda maskptr+1
            adc #0
            sta maskptr+1

            lda refptr
            clc
            adc #8
            sta refptr
            lda refptr+1
            adc #0
            sta refptr+1

            inx
numlines:   cpx #6
            bne lp3

            rts
            
;-------------------------------------------------------------------------------
clear:
            lda #$20
            ldy #0
lp1:
            sta $0400,y
            sta $0500,y
            sta $0600,y
            sta $0700,y
            iny
            bne lp1
            
            lda #5
            sta $d020
            lda #0
            sta $d021
            
            rts

startline:
            lda #0
            sta linepos+1
            rts
putright:
            inc linepos+1
            rts

puthex:
linepos:    ldy #0
            sta tmp+1
            lsr 
            lsr 
            lsr 
            lsr 
            tax
            
            lda sptr
            sta cptr
            lda sptr+1
            clc
            adc #$d4
            sta cptr+1
            
            lda hextab,x
            sta (sptr),y
currcol:    lda #1
            sta (cptr),y

            iny
tmp:        lda #0
            and #$0f
            tax
            lda hextab,x
            sta (sptr),y
            lda currcol+1
            sta (cptr),y
            iny
            sty linepos+1
            rts

hextab:
            !text "0123456789"
            !byte 1,2,3,4,5,6

;-------------------------------------------------------------------------------

            * = $1000
pages:

            * = $1400
pagesref:
            !binary "dump-pages.bin"

            * = $1800
pagesmask:
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff

            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            ; $A0-$A2/160-162         Real-time jiffy Clock
            !byte $00, $00, $00, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            ; $C5/197                 Matrix value of last Key pressed
            !byte $ff, $ff, $ff, $ff,  $ff, $00, $ff, $ff
            ; $C8/200                 Pointer: End of Line for Input
            ; $C9-$CA/201-202         Cursor X/Y position at start of Input
            ; $CB/203                 Matrix value of last Key pressed
            ; $CC/204                 Flag: Cursor blink
            ; $CD/205                 Timer: Count down for Cursor blink toggle
            ; $CE/206                 Character under Cursor while Cursor Inverted            
            !byte $00, $00, $00, $00,  $00, $00, $00, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            ; $F5-$F6/245-246         Vector: Current Keyboard decoding Table
            ; $F7-$F8/247-248         RS232 Input Buffer Pointer            
            !byte $ff, $ff, $ff, $ff,  $ff, $00, $00, $00
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff

            ; $0100-$0104 seems to be always "38911" after reset
            !byte $ff, $ff, $ff, $ff,  $ff, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00

            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff

            ; $0200-$0258    BASIC Input Buffer (Input Line from Screen)
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff

            ; $0287/647               Background Color under Cursor
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $00
            ;  $028B   Repeat Key: Speed Counter
            ;  $028C   Repeat Key: First repeat delay Counter
            !byte $ff, $ff, $ff, $00,  $00, $ff, $ff, $ff

            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff

            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff

            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff

            ; make sure the binary always ends at the same "odd" address
            * = $1cde
            !byte $42