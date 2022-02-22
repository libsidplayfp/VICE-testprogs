
; Test program to check weird REU behavior where it writes a byte twice when
; transferring data from the REU to the c64
;
; code: dw/style
; Written sometime in 2019.  Updated in Feb of 2022 to check for REU double 
; write in particular.   Maybe I should stop sitting on stuff for two+
; years.
;
; assemble with something like
;   acme -f cbm -o badoublewrite.prg badoublewrite.asm
;
; This code was originally written to test how the REC handles BA for each
; of the four DMA operations, so that I could try to replicate this behavior 
; in my own REU clone.  Some stuff is left over from this original code.
;
; The original idea was to trigger DMA around a badline and inspect the result
; using a logic analyzer.
;
; At the top of the frame (second bad line), it starts by triggering DMA a few
; cycles after the end of the vic char pointer fetches, and then tries to
; trigger it a cycle sooner on each subsequent bad line.  Obviously, the
; limitations of the 6510 pausing on a read cycle when RDY/BA is low apply.


; constants
;-----------

; raster line to start at
startline = $38

; c64 destination address to dma to
destaddr = $d021

; reu source address and bank
reuaddr  = $0000
reubank  = $00

; number of bytes to transfer
dmalen   = $0008

; repeat this many times
dmacount = $0c

; value stored to $df01 to start dma
dmaop    = $91


; zp locations
;--------------

; tmp pointer used to print text
tptr     = $fb

; store current raster irq line
rasterln = $fb

; value used in branch for variable delay
rastdly  = $fc

; number of times remaining
rastcnt  = $fd

; store stack pointer
storex   = $fe

; ntsc/pal flag
npflag   = $14


; basic stub (sys2061)
;-----------------------------
         *= $0801
         
         !byte $0b,$08,$e6,$07
         !byte $9e,$32,$30,$36
         !byte $31,$00,$00,$00

start
         sei
         jsr detectnp   ; detect ntsc/pal
         jsr initscreen
         sei

         tsx
         stx storex

         jsr reuzpinit

         ; set up so we can exit with the restore key
         lda #<nmi
         sta $fffa
         sta $fffc
         lda #>nmi
         sta $fffb
         sta $fffd

         ; disable cia timer interrupts
         lda #$7f
         sta $dc0d
         lda $dc0d

         ; map roms out
         lda #$35
         sta $01
         
         ; set up our raster irq
         lda #<raster1
         sta $fffe
         lda #>raster1
         sta $ffff

         lda #$1b
         sta $d011

rwait    bit $d011
         bpl rwait

         jsr datatoreu
         jsr rastreset

         lda #$01
         sta $d01a
         sta $d019

         cli
endless
         ; just some random code to run while waiting for irqs
         inc $d000
         dec $d000
         inc $d000
         jmp endless

         cli
         rts

         ; stable raster using the double irq method
raster1
         ; first irq points here
         pha
         txa
         pha
         tya
         pha

         lda #$01
         sta $d019

         inc $d000
         ldy rasterln
         iny
         sty $d012
         lda #<raster2
         sta $fffe
         lda #>raster2
         sta $ffff
         tsx
         cli
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop

raster2
         ; second irq.  We're off by one cycle at worst here
         txs
         
         ; set up reu registers.  At the time I wrote this my reu clone
         ; didn't support register autoload yet so I had to load everything
         ; manually.  Timing is critical here so I just left it as is.
         lda $52
         sta $df02
         lda $53
         sta $df03


         lda $54
         sta $df04
         lda $55
         sta $df05
         lda $56
         sta $df06

         bit $02
         bit $02
         bit npflag
         bvs np1        ; 2 cycles in pal, 3 in ntsc
np1      bvs np2        ;
np2
         cpy $d012
         beq addcycle
addcycle ; nice and stable at this point
         lda $57
         sta $df07
         lda $58
         sta $df08

         bit $02
         bit $02
         bit $02
         bit $02
         bit $02
         bit $02
         nop

         ldx #$00
         ldy #$08
         sty $d000      ; misc store.  Was playing around with setting d020/21
         
         lda rastdly    ; branch offset for cycle delay.  Starts at 0 and gets
         sta delaybr+1  ; incremented each time, which makes dma start one
                        ; cycle earlier on the next badline
         stx $d016      ; open side border so we can see double write

delaybr  bpl delaynxt   ; branch into cmp #$c9's for variable delay
delaynxt cmp #$c9
         cmp #$c9
         cmp #$c9
         cmp #$c9
         cmp #$c9
         cmp #$c9
         cmp #$c5
         nop

         lda #dmaop
         sta $df01      ; do dma

         sty $d016      ; restore side border reg
         ;stx $d021

         lda #$00       ; left over from earlier tests
         sta $d021      ; dma already sets this to 0

         ; restore first irq
         lda #<raster1
         sta $fffe
         lda #>raster1
         sta $ffff

         lda #$01
         sta $d019

         dec rastcnt
         bne rastnext
         jsr rastreset
         jmp irqdone

rastnext
         lda rasterln
         clc
         adc #$08
         sta rasterln
         sta $d012
         
         ; old test code originally copied dma data to the screen
;         lda $52
;         clc
;         adc #$14
;         sta $52
;         bcc skiphi1
;         inc $53
;skiphi1  lda $54
;         clc
;         adc #dmalen
;         sta $54
;         bcc skiphi2
;         inc $55

skiphi2  inc rastdly

frames: lda #2
        bne +

        lda #0
        sta $d7ff

+
        dec frames+1

irqdone
         pla
         tay
         pla
         tax
         pla
         rti


; set up for next frame
;---------------------------------------
rastreset
         lda #startline
         sta $d012
         sta rasterln

         lda #dmacount
         sta rastcnt

         lda #$00       ; raster delay count starts at 0 for ntsc
         bit npflag
         bvs ntsc
         lda #$02       ; starts at 2 for pal
ntsc     sta rastdly

         jsr reuzpinit
         rts


; init zp locations that will be copied to reu registers
;--------------------------------------------------------
reuzpinit
         ; guess I should've used labels for these
         lda #<destaddr
         sta $52
         lda #>destaddr
         sta $53
         lda #<reuaddr
         sta $54
         lda #>reuaddr
         sta $55
         lda #reubank
         sta $56
         lda #<dmalen
         sta $57
         lda #>dmalen
         sta $58
         rts


; init color mem
;---------------------------------------
initcolor
         ldy #$00
         lda #$01
clrcolor sta $d800,y
         sta $d900,y
         sta $da00,y
         sta $db00,y
         iny
         bne clrcolor
         rts


; clear screen and print doublewrite text
;-----------------------------------------
initscreen
         lda #<msgtxt
         sta tptr
         lda #>msgtxt
         sta tptr+1
         ldy #$00
         jsr textout
         ; print ntsc/pal text
;          ldy #msgpal-msgtxt
;          bit npflag
;          bvc donpmsg
;          ldy #msgntsc-msgtxt
; donpmsg  jsr textout
         rts
textout
         lda (tptr),y
         beq done
         jsr $ffd2
         iny
         bne textout
done     jsr initcolor
         rts

msgtxt
         ; no idea how you do petscii chars in acme...
         !byte $93
         !byte $11,$11,$11
         !byte $11,$11,$11
         !pet " ", $a3,$a3, " d021 doublewrite "
         !pet "on this line ", $a3,$a3
         !byte $13,$00

; msgpal
;          !pet "pal"
;          !byte $00
; msgntsc
;          !pet "ntsc"
;          !byte $00


; transfer our data table to the REU
;---------------------------------------
datatoreu
         lda #<dmadata
         sta $df02
         lda #>dmadata
         sta $df03
         lda #<reuaddr
         sta $df04
         lda #>reuaddr
         sta $df05
         lda #reubank
         sta $df06

         lda #<dmalen
         sta $df07
         ldx #>dmalen
         stx $df08
         
         ; increment c64 and reu addresses to copy table
         lda #$00
         sta $df0a
         
         ; transfer to reu
         lda #$90
         sta $df01
         
         ; fix c64 address for dma transfers in the main code
         lda #$80
         sta $df0a
         rts


; poor man's ntsc/pal detect routine
;---------------------------------------
detectnp
         !zone np {
         bit $d011
         bmi detectnp
.wait2   bit $d011
         bpl .wait2
         lda #$40
         sta npflag
.wait3   bit $d011
         bpl .npdone
         lda $d012
         cmp #$0a
         bcc .wait3
         lda #$00
         sta npflag
.npdone   rts
         }


; handle nmi (restore key).  Clean up somewhat and exit
;-------------------------------------------------------
nmi
         ;inc $d020
         lda #$37
         sta $01

         lda #$81
         sta $dc0d
         ldx #$00
         stx $d01a
         inx
         stx $d019
         ldx storex
         txs
         cli
         rts


; data to dma during test (colors for $d021)
;--------------------------------------------
dmadata
;          !byte $06,$04,$09,$0a
;          !byte $02,$0b,$0c,$00
         !byte $02,$03,$04,$05
         !byte $06,$07,$08,$09
