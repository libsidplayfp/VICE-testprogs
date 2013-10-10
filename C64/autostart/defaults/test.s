
sptr = $02
mptr = $04
refptr = $06
maskptr = $08
cptr = $0a

xtmp = $10
ytmp = $11
numlines = $12
linepos = $13
currcol = $14

currpage = $18
;-------------------------------------------------------------------------------

cpubuf = REGBUFFER
;            !byte 0,0,0,0,0,0,0,0
vicbuf = REGBUFFER + (1 * 8)
;            !byte 0,0,0,0,0,0,0,0
;            !byte 0,0,0,0,0,0,0,0
;            !byte 0,0,0,0,0,0,0,0
;            !byte 0,0,0,0,0,0,0,0
;            !byte 0,0,0,0,0,0,0,0
;            !byte 0,0,0,0,0,0,0,0
cia1buf = REGBUFFER + (1 * 8) + (6 * 8)
;            !byte 0,0,0,0,0,0,0,0
;            !byte 0,0,0,0,0,0,0,0
cia2buf = REGBUFFER + (1 * 8) + (6 * 8) + (2 * 8)
;            !byte 0,0,0,0,0,0,0,0
;            !byte 0,0,0,0,0,0,0,0
ramebuf = REGBUFFER + (1 * 8) + (6 * 8) + (2 * 8) + (2 * 8)
;            !byte 0,0,0,0,0,0,0,0
;            !byte 0,0,0,0,0,0,0,0

pages = MEMBUFFER

;-------------------------------------------------------------------------------

            * = CODESTART

;-------------------------------------------------------------------------------

start:
            php ; push status
            sei
            cld
            sta cpubuf+0
            stx cpubuf+1
            sty cpubuf+2
            tsx
            stx cpubuf+3
            pla ; get status
            sta cpubuf+4

            lda #0
            sta cpubuf+5
            sta cpubuf+6
            sta cpubuf+7

            ldx $00
            ldy $01

            lda #$2f
            sta $00
            lda #$37
            sta $01

            stx pages
            sty pages+1

            ldx #$ff
            txs

            ldy #2
lpp1a:
            lda $0,y
            sta pages,y
            iny
            bne lpp1a

            ldy #0
lpp1:
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

            ; delay so floppy can finish reset routine etc
            ldx #60 * 2
waitframes:
            lda #$80
            cmp $d012
            bne *-3
            cmp $d012
            beq *-3
            dex
            bne waitframes

            ; get VIC, CIA1, CIA2
            ldy #0
lpv1:
            lda $d000,y
            sta vicbuf,y
            iny
            cpy #$30
            bne lpv1

            ldy #0
lpc1:
            lda $dc00,y
            sta cia1buf,y
            iny
            cpy #$10
            bne lpc1

            ldy #0
lpc2:
            lda $dd00,y
            sta cia2buf,y
            iny
            cpy #$10
            bne lpc2

            ; show results
            jsr clear ; clear screen and setup VIC

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


            lda #$ff
            sta $dc02
            lda #0
            sta $dc03

mainlp:

            inc $07e5

            lda #%11011111
            sta $dc00

wait1:
            inc $07e6
            jsr showpage

            lda $dc01
            cmp #$ff
            bne wait1

wait2:
            inc $07e6
            jsr showpage

            lda $dc01
            cmp #$ff
            beq wait2
            sta $07e7

            cmp #%11111110
            beq plus
            cmp #%11110111
            beq minus
            cmp #%01111111
            beq firstpage
            cmp #%11101111
            beq iopage
            jmp mainlp

minus:
            dec currpage
            jmp mainlp
plus:
            inc currpage
            jmp mainlp

firstpage:
            lda #0
            sta currpage
            jmp mainlp
iopage:
            lda #$de
            sta currpage
            jmp mainlp

showpage:
            lda #>($400+(40*24))
            sta sptr+1
            lda #<($400+(40*24))
            sta sptr+0
            lda #1
            sta currcol
            lda #33
            sta linepos
            lda currpage
            jsr puthex

            lda currpage
            cmp #4
            bcc skp
            
            lda currpage
            sta mptr+1
            lda #0
            sta mptr
            
            ldy #0
plpa1:
            lda (mptr),y
            sta $0400+(18*40),y
            lda #1
            sta $d800+(18*40),y
            iny
            bne plpa1
            
            rts
            
skp:
            lda currpage
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
            lda #<pages
            sta mptr
            lda #<pagesref
            sta refptr
            lda #<pagesmask
            sta maskptr

            jsr dopage
            rts

;-------------------------------------------------------------------------------
getcolor:
            ; RED if val & mask != ref & mask
            lda (mptr),y
            eor (refptr),y
            and (maskptr),y
            beq nred
            lda #10
            rts
nred:
            lda (mptr),y
            cmp (refptr),y
            beq nyellow
            lda #7
            rts
nyellow:
            lda #5
            rts
dopage:

            ldy #0
plpa:
            lda (mptr),y
            sta $0400+(18*40),y
            jsr getcolor
            sta $d800+(18*40),y
            iny
            bne plpa

;            ldy #0
;plpb:
;            ldx #7
;            lda (maskptr),y
;            beq grn
;            ldx #5
;
;            lda (mptr),y
;            and (maskptr),y
;            cmp (refptr),y
;            beq grn
;            ldx #10
;grn:
;            txa
;            sta $d800+(18*40),y
;            iny
;            bne plpb
            rts

;-------------------------------------------------------------------------------

doblock:
            sta numlines
            ldx #0
lp3:
            stx xtmp

            jsr startline

            ldy #0
lp2:
            sty ytmp

            jsr getcolor
            cmp #10
            bne notred
            sta $d020
notred:
            sta currcol

            lda (mptr),y
            jsr puthex
            jsr putright

            ldy ytmp
            ldx xtmp
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
            cpx numlines
            bne lp3

            rts
            
;-------------------------------------------------------------------------------
clear:
            ldy #0
lp1:
            lda #$20
            sta $0400,y
            sta $0500,y
            sta $0600,y
            sta $0700,y
            lda #$01
            sta $d800,y
            sta $d900,y
            sta $da00,y
            sta $db00,y
            iny
            bne lp1

            lda #$1b
            sta $d011
            lda #$c8
            sta $d016
!if (USEULTIMAX = 1) {
            lda #$1c
} else {
            lda #$15
}
            sta $d018
            lda #5
            sta $d020
            lda #0
            sta $d021
            
            lda #3
            sta $dd00

            rts

startline:
            lda #0
            sta linepos
            rts
putright:
            inc linepos
            rts

puthex:
            ldy linepos
            pha
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
            lda currcol
            sta (cptr),y

            iny
            pla
            and #$0f
            tax
            lda hextab,x
            sta (sptr),y
            lda currcol
            sta (cptr),y
            iny
            sty linepos
            rts

hextab:
            !text "0123456789"
            !byte 1,2,3,4,5,6

