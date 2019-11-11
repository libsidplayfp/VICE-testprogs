
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

failed = $20

c128detected = $30

;-------------------------------------------------------------------------------

; $08 bytes
cpubuf = REGBUFFER
;            !byte 0,0,0,0,0,0,0,0
; $30 bytes
vicbuf = cpubuf + $08
;            !byte 0,0,0,0,0,0,0,0
;            !byte 0,0,0,0,0,0,0,0
;            !byte 0,0,0,0,0,0,0,0
;            !byte 0,0,0,0,0,0,0,0
;            !byte 0,0,0,0,0,0,0,0
;            !byte 0,0,0,0,0,0,0,0
; $10 + 8
cia1buf = vicbuf + $30
;            !byte 0,0,0,0,0,0,0,0
;            !byte 0,0,0,0,0,0,0,0
; $10 + 8
cia2buf = cia1buf + $10 + 8
;            !byte 0,0,0,0,0,0,0,0
;            !byte 0,0,0,0,0,0,0,0
; $08
ramebuf = cia2buf + $10 + 8
;            !byte 0,0,0,0,0,0,0,0
;            !byte 0,0,0,0,0,0,0,0

cpubuf_first = cpubuf + $80
vicbuf_first = vicbuf + $80
cia1buf_first = cia1buf + $80
cia2buf_first = cia2buf + $80
ramebuf_first = ramebuf + $80


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
            stx cpubuf+6
            sty pages+1
            sty cpubuf+7

            ldx #$ff
            txs

            ; detect C128 in C64 mode
            ldx #0
            lda #$cc
            sta $d030
            lda $d030
            cmp #$fc
            beq isc128
            ldx #1
isc128:
            stx c128detected
            
            lda c128detected
            bne +
            lda #$77
            sta cpuref + 7  ; $01
+

            lda #5
            sta failed

            lda #0
            ldy #0
lpp1b:
            sta vicbuf,y
            iny
            bne lpp1b

            jsr readpages
            jsr readrameblock

            !if (1 = 1) {
            ; delay so floppy can finish reset routine etc
            ldx #2 * 60
waitframes:
            lda #$80
            cmp $d012
            bne *-3
            cmp $d012
            beq *-3
            dex
            bne waitframes
            }

            jsr readioblock

            ldy #$7f
lpp1c:
            lda vicbuf,y
            sta vicbuf_first,y
            dey
            bpl lpp1c

            ; show results
            jsr clear ; clear screen and setup VIC
            jsr setupvic

            jsr showcpublock
            jsr showrameblock
            jsr showioblock
            jsr showpage

            lda c128detected
            bne +
            
            ldx #5
-
            lda c128string,x
            sta $0428+30,x
            dex
            bpl -
            
+
            
            lda failed
            sta $d020

            ldx #0      ; success
            cmp #5
            beq nofail
            ldx #$ff    ; failure
nofail:
            stx $d7ff

!if (CRTMODE = 1) {
            jmp crtstartup
}            
normalstartup:
            ; wait until key pressed
wait3a:
            inc $d020
            dec $d020
            jsr keyscan
            cmp #$ff
            beq wait3a
            ; wait until no key pressed
wait3:
            jsr keyscan
            cmp #$ff
            bne wait3

mainlp:


            ; wait until no key pressed
wait1:

            jsr restorevic
            jsr readioblock
            jsr setupvic
            jsr showioblock
            jsr showpage

            jsr keyscan
            cmp #$ff
            bne wait1

            ; wait until key pressed
wait2:

            jsr restorevic
            jsr readioblock
            jsr setupvic
            jsr showioblock
            jsr showpage

            jsr keyscan
            cmp #$ff
            beq wait2

            cmp #%11111110      ; +
            beq plus
            cmp #%11110111      ; -
            beq minus
            cmp #%01111111      ; ,
            beq firstpage
            cmp #%11101111      ; .
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
            
!if (CRTMODE = 1) {
crtstartup:
            lda #>irqnmi
            sta $ffff
            sta $fffb
            lda #<irqnmi
            sta $fffe 
            sta $fffa
            
            ldx #6
-
            lda SIGBUFFER,x
            cmp signature,x
            bne firststart
            dex
            bpl -
            
            lda SIGBUFFER+7
            cmp #'1'
            beq secondstart
            jmp thirdstart

firststart:
            lda #'0'
            sta $0400+(0*40)+39
            
            ldx #7
-
            lda signature,x
            sta SIGBUFFER,x
            dex
            bpl -
            
            ; preload registers after first start
            lda #$ff
            ldx #$ff
            ldy #$ff
            txs
            php
            sta $00
            sta $01
            jmp *

secondstart:            
            inc SIGBUFFER+7
            
            lda #'1'
            sta $0400+(0*40)+39
            
            ; preload registers after second start
            lda #$00
            ldx #$00
            ldy #$00
            txs
            php
            sta $00
            sta $01
            jmp *

thirdstart:            
            dec SIGBUFFER+7
            lda #'2'
            sta $0400+(0*40)+39
            
            ; preload registers after second start
            lda #$ff
            ldx #$ff
            ldy #$ff
            txs
            php
            jmp normalstartup
            
            
signature:    
            !scr "sTaRtCy1"
            
}

c128string: !scr "(c128)"

irqnmi:
            rti

keyscan:
            lda #$ff
            sta $dc02 ; 1 = Pin set to Output, 0 = Input 
            lda #0
            sta $dc03
            lda #%11011111
            sta $dc00
            lda $dc01
            pha
            ; restore CIA1
            lda cia1buf_first+$02
            sta $dc02
            lda cia1buf_first+$03
            sta $dc03
            lda cia1buf_first+$12
            sta $dc00
            pla
            rts

;-------------------------------------------------------------------------------
readpages:
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
            rts

readrameblock:
            ldy #0
lpp2:
            lda $9ff8,y
            sta ramebuf,y
            iny
            cpy #$08
            bne lpp2
            rts

readioblock:
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

            lda #$00
            sta $dc02
            sta $dc03

            lda $dc00
            sta cia1buf+$10
            lda $dc01
            sta cia1buf+$11

            lda #$ff
            sta $dc02
            sta $dc03

            lda $dc00
            sta cia1buf+$12
            lda $dc01
            sta cia1buf+$13

            lda cia1buf+$02
            sta $dc02
            lda cia1buf+$03
            sta $dc03

            ldy #0
lpc2:
            lda $dd00,y
            sta cia2buf,y
            iny
            cpy #$10
            bne lpc2

            lda #$00
            sta $dd02
            lda #$00
            sta $dd03

            lda $dd00
            sta cia2buf+$10
            lda $dd01
            sta cia2buf+$11

            lda #$ff
            sta $dd02
            lda #$ff
            sta $dd03

            lda $dd00
            sta cia2buf+$12
            lda $dd01
            sta cia2buf+$13

            lda cia2buf+$02
            sta $dd02
            lda cia2buf+$03
            sta $dd03
            rts

showcpublock:
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
            jmp doblock

showioblock:
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

            lda #3
            jsr doblock

            ; cia2
            lda #>($0400+(13*40))
            sta sptr+1
            lda #<($0400+(13*40))
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

            lda #3
            jmp doblock

showrameblock
            ; end of basic ram
            lda #>($0400+(17*40))
            sta sptr+1
            lda #<($0400+(17*40))
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

            lda #1
            jmp doblock

showpage:
            lda #>($0400+(40*16))
            sta sptr+1
            lda #<($0400+(40*16))
            sta sptr+0
            lda #1
            sta currcol
            lda #38
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
            sta $0400+(18*40)+24,y
            lda #1
            sta $d800+(18*40)+24,y
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
            sta $0400+(18*40)+24,y
            jsr getcolor
            sta $d800+(18*40)+24,y
            iny
            bne plpa
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
            sta failed
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
            sta $06e8,y
            lda #$01
            sta $d800,y
            sta $d900,y
            sta $da00,y
            sta $dae8,y
            iny
            bne lp1
    
            ldy #15
lp1a:            
            lda testname,y
            and #$3f
            sta $0400+24,y
            dey
            bpl lp1a
            rts

setupvic:
;            lda #$fc
;            cmp $d012
;            bne *-3

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
            lda failed
            sta $d020
            lda #0
            sta $d021

            !if (1 = 0) {
            lda $dd02
            ora #%00000011
            sta $dd02

            lda $dd02 ; 1 = Pin set to Output, 0 = Input
            and $dd00
            ora #$03
            sta $dd00
            }

            rts

restorevic:
            lda #$fc
            cmp $d012
            bne *-3

            lda vicbuf_first + $11
            and #$7f
            sta $d011
            lda vicbuf_first + $16
            sta $d016
            lda vicbuf_first + $18
            sta $d018
            lda vicbuf_first + $20
            sta $d020
            lda vicbuf_first + $21
            sta $d021

            !if (1 = 0) {
            lda cia2buf_first + $02 ; 1 = Pin set to Output, 0 = Input
            sta $dd02
            and cia2buf_first + $00
            sta $dd00
            }
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

