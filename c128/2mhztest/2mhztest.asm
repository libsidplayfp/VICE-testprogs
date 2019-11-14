         *= $1c01   

!byte $0c,$1c,$0a,$00,$9e,$20,$37,$31,$38,$32,$00,$00,$00
 
         sei         ;Disable IRQ's      
         lda #$f7
         sta $d505
         jsr set2mhztext
         jsr detectntscpal  
         lda #$7f    ;Disable CIA IRQ's
         sta $dc0d
         sta $dd0d
 
         lda #<irq1  ;Install RASTER IRQ
         ldx #>irq1  ;into Hardware
         sta $fffe   ;Interrupt Vector
         stx $ffff
         lda #<nmi  ;Install RASTER NMI
         ldx #>nmi  ;into Hardware
         sta $fffa   ;Interrupt Vector
         stx $fffb
 
 
         lda #$01    ;Enable RASTER IRQs
         sta $d01a
         lda #$34    ;IRQ on line 52
         sta $d012
         lda #$1b    ;High bit (lines 256-311)
         sta $d011
                     ;NOTE double IRQ
                     ;cannot be on or
                     ;around a BAD LINE!
                     ;(Fast Line)
 
         lda #$0e    ;Set Background
         sta $d020   ;and Border colors
         lda #$06
         sta $d021
         lda #$00
         sta $d015   ;turn off sprites
 
         jsr clrscreen
         jsr clrcolor
         jsr printtext
 
         asl $d019   ;Ack any previous
         bit $dc0d   ;IRQ's
         bit $dd0d
 
         cli         ;Allow IRQ's
 
         jmp *       ;Endless Loop
 
 
irq1
         sta reseta1 ;Preserve A,X and Y
         stx resetx1 ;Registers
         sty resety1 ;VIA self modifying
                     ;code
                     ;(Faster than the
                     ;STACK is!)
 
         lda #<irq2  ;Set IRQ Vector
         ldx #>irq2  ;to point to the
                     ;next part of the
         sta $fffe   ;Stable IRQ
         stx $ffff   ;ON NEXT LINE!
         inc $d012
         asl $d019   ;Ack RASTER IRQ
         tsx         ;We want the IRQ
         cli         ;To return to our
         nop         ;endless loop
         nop         ;NOT THE END OF
         nop         ;THIS IRQ!
         nop
         nop         ;Execute nop's
         nop         ;until next RASTER
         nop         ;IRQ Triggers
         nop
         nop         ;2 cycles per
         nop         ;instruction so
         nop         ;we will be within
         nop         ;1 cycle of RASTER
         nop         ;Register change
         nop
irq2
         txs         ;Restore STACK
                     ;Pointer
         ldx #$07    ;Wait exactly 1
         dex         ;lines worth of
         bne *-1     ;cycles for compare
         bit $ea     ;Minus compare 

	   lda palflag
         bne pal
         bit $ea
pal 
 
         lda #$35    ;RASTER change yet?
         cmp $d012
         beq start   ;If no waste 1 more
                     ;cycle
start
         nop         ;Some delay
         nop         ;So stable can be
         nop         ;seen
 
         lda #$0e    ;Colors
         ldx #$06
 
         sta $d021   ;Here is the proof
         stx $d021
 
         lda #<irq3  ;Set IRQ to point
         ldx #>irq3  ;to subsequent IRQ
         ldy #$68    ;at line $68
         sta $fffe
         stx $ffff
         sty $d012
         asl $d019   ;Ack RASTER IRQ
 
         lda #$00    ;Reload A,X,and Y
reseta1  = *-1       ;registers
         ldx #$00
resetx1  = *-1
         ldy #$00
resety1  = *-1
 
         rti         ;Return from IRQ
 
irq3
         sta reseta2 ;Preserve A,X,and Y
         stx resetx2 ;Registers
         sty resety2
 
         ldx #$07    ;Waste some more
         dex         ;time so effect
         bne *-1     ;can be seen

         lda #$0e    ;More colors
         ldx #$1
         stx $d030   ;Cool! subsequent
         sta $d021   ;IRQ's are also
                     ;stable :-)
                     ;Unless you are
                     ;running realtime
                     ;code :-)
delayfast    bit $ea
         nop
         lda palflag
         bne fastdraw
         bit $ea
      nop
	nop
fastdraw
        
;operand of following instructions = character data
cpy #$ff ;1
cpy #$ff ;2
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00 ;39
cpy #$00 ;40
jsr delay

cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
jsr delay

;Badline lower nybble of opcode=color, operand = character data
line0
ldy #$ff   ;black
ldy #$ff
ldy #$ff
ldy #$ff
ldy #$00
ldy #$00
ldy #$00
ldy #$00
ldx #$ff   ;red
ldx #$ff
ldx #$ff
ldx #$ff
ldx #$00
ldx #$00
ldx #$00
ldx #$00
lda #$ff   ;brown
lda #$ff
lda #$ff
lda #$ff
lda #$00
lda #$00
lda #$00
lda #$00
ldy #$ff
ldy #$ff
ldy #$ff
ldy #$ff
ldy #$00
ldy #$00
ldy #$00
ldy #$00
ldx #$ff
ldx #$ff
ldx #$ff
ldx #$ff
ldx #$00
ldx #$00
ldx #$00
ldx #$00
jsr delay

line1
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
jsr delay

line2
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
jsr delay

line3
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
jsr delay

line4
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
jsr delay

line5
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
jsr delay

line6
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
jsr delay

line7
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$ff
cpy #$00
cpy #$00
cpy #$00
cpy #$00
jsr delay
        
         ldy #$0b   ;Waste time on badline
         dey         ;to see what is left on
         bne *-1     ;VICII bus
delayslow bit $ea
         lda #$06
setslow  ldx #$00

         stx $d030
         sta $d021
         lda #<irq1  ;Reset Vectors to
         ldx #>irq1  ;first IRQ again
         ldy #$34    ;at line $34
         sta $fffe
         stx $ffff
         sty $d012
         asl $d019   ;Ack RASTER IRQ
         lda $dc01
         eor #$ff
         beq resetdelay
         dec keyboarddelay
         bne end
         cmp #$10
         bne delay1
         lda setslow+1
         clc
         adc #$04
         sta setslow+1
         jsr printhex
         jmp delaynextkey
delay1   cmp #$01
         bne delay2
         ldx #10
         lda #$24
         cmp delayfast
         bne togglefast
         ldx #05
         lda #$ea
togglefast
         sta delayfast
fastloc=$400+(14*40)+34
         lda #<fastloc
         sta tfloc+1
         lda #>fastloc
         sta tfloc+2
         jsr printtruefalse
         jmp delaynextkey
delay2   cmp #$08
         bne end
         ldx #10
         lda #$24
         cmp delayslow
         bne toggleslow
         ldx #05
         lda #$ea
toggleslow
         sta delayslow
slowloc=$400+(16*40)+34
         lda #<slowloc
         sta tfloc+1
         lda #>slowloc
         sta tfloc+2
         jsr printtruefalse
         jmp delaynextkey



resetdelay
         lda #$1
         sta keyboarddelay
end      lda #$00    ;Reload A,X,and Y
reseta2  = *-1       ;registers
         ldx #$00
resetx2  = *-1
         ldy #$00
resety2  = *-1

         rti         ;Return from IRQ
delaynextkey
         lda #$08
         sta keyboarddelay
         jmp end
 
                     ;Pound RESTORE to
                     ;get back to Turbo
nmi
         asl $d019   ;Ack all IRQ's
         lda $dc0d
         lda $dd0d
         lda #$81    ;reset CIA 1 IRQ
         ldx #$00    ;remove raster IRQ
         ldy #$37    ;reset MMU to roms
         sta $dc0d
         stx $d01a
         sty $01
         ldx #$ff    ;clear the stack
         txs
      ;   cli         ;reenable IRQ's
         jmp $fce2   ;Reset
 
clrscreen
         lda #$20    ;Clear the screen
         ldx #$00
clrscr   sta $0400,x
         sta $0500,x
         sta $0600,x
         sta $0700,x
         dex
         bne clrscr
         rts
clrcolor
         lda #$03    ;Clear color memory
         ldx #$00
clrcol   sta $d800,x
         sta $d900,x
         sta $da00,x
         sta $db00,x
         dex
         bne clrcol
         rts
 
printtext
         lda #$16    ;C-set = lower case
         sta $d018
 
         ldx #$00
moretext lda text1,x
         sta $0428,x
         inx
         cpx #$78
         bne moretext
         ldx #$00
more
         lda paltext,x
         sta $04c8,x
         inx
         cpx #40
         bne more
         ldx #$00
options  
         lda fast2slow,x
         sta $0400+(12*40),x
         inx
         cpx #200
         bne options
exit     rts
!align 255,0,0
delay ;WARNING MAKE SURE BRANCH DOES NOT CROSS PAGE BOUNDARY WHEN ASSEMBLED!!!
         ldx #$3  ;delay to next line. Refresh DMA cycles run at 1Mhz
         dex
         bne *-1
         nop
         nop
         nop
         lda palflag
         bne return
         bit $ea
         nop     
return   rts
detectntscpal
wait:
              lda $d012
              bne wait                    ; wait for rasterline 0 or 256
              lda #$37
              sta $d012
              lda #$9b                    ; write testline $137 to the
              sta $d011                   ; latch-register
              lda #$01
              sta $d019                   ; clear IMR-Bit 0
wait1:
              lda $d011                   ; Is rasterbeam in the area
              bpl wait1                   ; 0-255? if yes, wait
wait2:
              lda $d011                   ; Is rasterbeam in the area
              bmi wait2                   ; 256 to end? if yes, wait
              lda $d019                   ; read IMR
              and #$01                    ; mask Bit 0
              sta $d019                   ; clear IMR-Bit 0
              sta palflag
              bne paldetected
              ldx #<ntsctext
              ldy #>ntsctext
              jmp palntsc
paldetected
              ldx #<paltext
              ldy #>paltext
palntsc
              stx more+1
              sty more+2
              rts
set2mhztext
         lda #$31    ;Bank in charrom
         sta $01     ;$e000-$ffff
         ldx #$00
         lda #$d0
         sta $03
         lda #<demotext
         sta looptext+1
         lda #>demotext
         sta looptext+2
looptext lda demotext
         pha
         inc looptext+1;
         and #$1f 
         rol
         rol
         rol
         sta $02
         pla
         lsr
         lsr
         lsr
         lsr
         lsr
         ora #$d0
         sta $03
         ldy #$00
         lda ($02),y
         iny
         sta line0+1,x
         lda ($02),y
         iny
         sta line1+1,x
         lda ($02),y
         iny
         sta line2+1,x
         lda ($02),y
         iny
         sta line3+1,x
         lda ($02),y
         iny
         sta line4+1,x
         lda ($02),y
         iny
         sta line5+1,x
         lda ($02),y
         iny
         sta line6+1,x
         lda ($02),y
         iny
         sta line7+1,x
         inx
         inx
         cpx #48
         bne looptext
         lda #$35    ;Bank out kernal and basic
         sta $01     ;$e000-$ffff
         rts
printtruefalse
         ldy #$5
tfloop   dex
         lda truefalse,x
tfloc    sta $0400,y
         dey
         bne tfloop
         rts
           

printhex:
    pha
    ; mask lower
    and #$0f
    ; lookup
    tax
    lda hexlut,x
    ; print
printlocation = (12*40)+19
    sta $0401+printlocation
    ; lsr x4
    pla
    lsr
    lsr
    lsr
    lsr
    ; lookup
    tax
    lda hexlut,x
    ; print
    sta $0400+printlocation
    rts
; hex lookup table

hexlut: 
    !scr "0123456789abcdef"


palflag:      !byte $00
keyboarddelay !byte $10
text1
         !scr "VICIIe 2mhz test - William McCabe (2017)"
         !scr "                                        "
         !scr "Stable Interrupt Code by Fungus (1996)  "
paltext  !scr "PAL detected                            "
ntsctext !scr "NTSC detected                           "
fast2slow        !scr "(space) d030 01 ==>00                   "
                 !scr "                                        "
                 !scr "(1)     delay gfx 1 fast cycle:    false"
                 !scr "                                        "
                 !scr "(2)     delay 1 cycle fast==>slow: false"
truefalse !scr "true false"
!align 255,0,0
demotext !scr "black   red     brown   "


