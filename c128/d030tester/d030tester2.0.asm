; DO30 test Version 2.0
; Released 7 February 2018
;
; Compiled using Z64K
;
; William McCabe (18 March 2018)

; Stable IRQ code inspired by Fungus (1996) - CodeBase64
; PAL/NTSC detection code inspired by TLR - CodeBase64
; NTSC testing - Stab

stableraster = 51+(3*8)-3
stableraster2 =192
spritey=200
bordercolor =14
backgroundcolor = 6
displayctrlline=6
delayctrline=9
testbittestline=delayctrline+2
palvblank=300-2;13
ntscvblank=13;-2
palsyncpos=303
ntscsyncpos=17
palframepos=281;palvblank-15
ntscframepos=0;263+ntscvblank-15
spritepage=$20


fast2slow=$0400+(delayctrline*40)+30
slow2fast=$0400+(delayctrline*40)+28
 *= $1c01
byt $0c,$1c,$0a,$00,$9e,$20,$37,$31,$38,$32,$00,$00,$00
mainprogram
         sei         ;Disable IRQ's
         lda #$f7
         sta $d505   ;C64 Mode
         jmp reset
irq1
         sta reseta1+1 ;Preserve A,X and Y
         stx resetx1+1 ;Registers
         sty resety1+1 ;VIA self modifying code(Faster than the STACK is!)
irq1ready
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
         lda #$00
palflag=*-1
         bne rasterchange
         bit $ea
rasterchange 
         lda $d012    ;RASTER change yet?
         cmp $d012
         beq start   ;If no waste 1 more cycle  
start
         jsr $0000   ;instruction ready to execute on VICII cycle 4 - main program code starts on VICII cycle 10

         asl $d019   ;Ack RASTER IRQ

         jsr initstableraster
 
reseta1  lda #$00    ;Reload A,X,and Y
resetx1  ldx #$00
resety1  ldy #$00
         rti         ;Return from IRQ
nmi
         lda #0
         sta $d030
         jmp reset 
initstableraster
         lda #<irq1  ;Set IRQ to point
         ldx #>irq1  ;to subsequent IRQ        
         sta $fffe
         stx $ffff 
         rts
wsync
; must be used as first instruction of stable interrupt program
; sets VICII cycle where 1st instruction should execute
; jsr wsync+x (x = 0 to 34)
; x=cycles before VICII cycle 1
;             ; following example would set testbit at cycle 1
;             jsr wsync+5    ;returns at cycle -5
;             ldx #$02       
;             stx $d030      
             
         cmp #$c9                     
         cmp #$c9           
         cmp #$c9        
         cmp #$c9                     
         cmp #$c9           
         cmp #$c9     
         cmp #$c9                     
         cmp #$c9       
         cmp #$c9                     
         cmp #$c9
         cmp #$c9     
         cmp #$c9                     
         cmp #$c9    
         cmp #$c9                     
         cmp #$c9   
         cmp #$c9        
         cmp $ea                      
         lda palflag       
         bne palmode        
         bit $ea            
palmode             
         rts
initcll
         lda#<calculatelostlines
         ldx#>calculatelostlines
         sta start+1
         stx start+2
         ldy palflag
         lda calcpos,y
         sta $d012
         lda calcpos+1,y
         ora #$1b
         sta $d011
         rts
calculatelostlines
         ldy #$00
         sty $dc0e ;  stop CIA1 timerA

         lda #11
         ldx #20
         jsr setscreenpos

         lda $dc04
         ldx $dc05 
         sta timeralo
         stx timerahi

         ldy #$00
         cmp #$00
         bne anotherline
testhi
         cpx #$00
         beq endtimercalc
         dex
anotherline 
         iny
         cpy #$40
         beq endtimercalc
         sec
         sbc cyclesperline
         beq testhi
         bcs anotherline 
         jmp testhi
endtimercalc
         tya
         pha
         jsr printhex
         pla
         clc
         adc #224-32
         sta reclaimnow

         lda#<frame
         ldx#>frame
         sta start+1
         stx start+2
         ldy palflag
         lda framepos,y
         sta $d012
         lda framepos+1,y
         ora #$1b
         sta $d011
         rts
align $100
frame    ;arrives here at raster 300 cycle 10 (PAL), raster 13 cycle 10 (NTSC) vync 303/2 (PAL) 17/3 (NTSC)

;         jsr clockslide+255
;delaycorrection=*-2
         ldx #$0b        ; 2
         stx $d011       ; 4 ensure bad lines do not interfere with timing...
         lda #$00        ; 2
         sta $d015       ; 4 ...and sprite DMA does not intefere either
         ldx #$02        ; 2
         lda #$00        ; 2
         jsr wsync+34    ; 
         stx $d030
                          ; END OF FRAME
         jsr clockslide   ; recover lines deducted at start of frame (lines/frame - 14 - number of lines)
clockslide1=*-2
         jsr clockslide         ;14                                           (14 + correction)
reclaimnow=*-2
         sta $d030       ;4         
nexttest
         ldx #$2
         lda #0
raisescreen=*-1 
         ldy $d011
         bmi *-3
         ldy #$0
         cmp $d012
         bne *-3

         stx $d030
         jsr clockslide
clockslide2a=*-2
         jsr clockslide
clockslide2=*-2
         sty $d030
         lda #$1b        ; 2
         sta $d011       ; 2
         lda #$00
spriteon=*-1
         sta $d015
         lda #bordercolor       
         ldx #backgroundcolor
         sta $d020     
         stx $d021
         lda #11   ;print timerA value
         ldx #$23
         jsr setscreenpos
         lda #$00
timerahi =*-1 
         jsr printhex
         lda #$00
timeralo =*-1
         iny
         jsr printhex+2
         jsr checkkeyboard   
inittest1
         lda#<test1
         ldx#>test1
         ldy #stableraster
         sta start+1
         stx start+2
         sty $d012
         rts
test1             
         jsr wsync+9+25
;Use CIA1 Timer B to calculate cycles per frame 
         lda #$00
         ldy #$11
         sta $dc0f
         lda $dc06
         ldx $dc07
         sty $dc0f
         sta $f0
         stx $f1

         lda #$1b
d011set =*-1
         ldx #$0e        
         ldy #$1       
d030set =*-1  
         sty $d030 
         stx $d021
         ldx #$c8
d016set=*-1
         sta $d011
         stx $d016    
delayfast    
         bit $ea
         jmp drawcode           
finishdraw
         ldx #$08    ; Waste time on badline
         dex         ; to see what is left on
         bne *-1     ; internal VICII bus
         lda #backgroundcolor  
delayslow  
         bit $ea
         bit $ea
         ldx d030set
         dex
         stx $d030
disablemethod=*-3
         sta $d021
         lda #$1b
         ldx #$c8
         sta $d011
         stx $d016
 
         sec
         lda #$ff
         sbc $f0
         sta $f0
         lda #$ff
         sbc $f1
         sta $f1 
         clc
         lda #$0d
         adc $f0
         sta $f0
         bcc printframecycles
         inc $f1
printframecycles
         lda #0
         ldx #33
         jsr setscreenpos
         lda $f1
         jsr printhex
         lda $f0
         iny
         jsr printhex+2
         jsr inittest2
         rts

inittest2
         lda#<test2
         ldx#>test2
         ldy #stableraster2
         sta start+1
         stx start+2
         sty $d012
         rts
align $100
test2
         ldy #$11        ; 2
         sty $dc0e       ; 6
         lda #$00        ; 8
         clc             ; 10
         sbc #0          ; 12
testbitdelay=*-1
         sta jumpdelay+1 ; 16

         jsr wsync+16+12 ;             
         lda testbitcolor; 4
         sta $d021       ; 8    
         sta $d020       ; 12    stableraster+1

jumpdelay
         jsr clockslide  ;              14 (when delay = 0)
delay256
         ldy #0
         beq startirq4 ;2            (  2)
         ldx #49       ;2            (  4)
         dex           ;2*49=98      (102) 
         bne *-1       ;3*48+2=146   (248)
         bit $ea       ;3            (251)
         dey           ;2            (253)
         jmp delay256+2  ;3          (256)
         
startirq4                             ; VICII cycle 14  (when delay = 0)
         jsr wsync+5+14        
         ldx #1            ;2         
         ldy #14           ;2                     
         lda #14           ;2                     
testbitcolor=*-1
         stx $d021         ;4         ( 4)
         sty $d021         ;4         ( 8)
         sta $d021         ;4         (12)
         ldx #7            ;2         (14)
delayline           
         dex               ; 2*7=14   (28)
         bne delayline     ; 3*6+2=20 (48)
         lda palflag       ;4         (52)
         bne delaypal      ;3         (55/54)
         bit $ea           ;3         (xx/57)
delaypal 
         nop    ; 2        (57/59)
         nop    ; 2        (59/61)
         ldx #0 ; 2        (61/63)
disabletestbit = *-1
         lda #2 ; 2        (63/65)
enabletestbit = *-1
         sta $d030         
         stx $d030
         ldy $d012         ;lower nybble of opcode colors 3 blocks at delay 815
         lda $d011
         cmp #$ff
         bne rasterok
         ldy #$00
rasterok
         and #$80
         sta rasterhibit
         sty rasterlobit
         lda #15
         ldx #15
         jsr setscreenpos
         lda #0
rasterhibit =*-1
         ldy #0
         clc
         rol
         rol
         jsr printdigit
         lda #$00
rasterlobit =*-1
         jsr printhex
         jsr initcll
         rts
clrscreen
         lda #$20    ;Clear the screen
         ldx #$00
clrscr   sta $0400,x
         sta $0500,x
         sta $0600,x
         sta $0700,x
         dex
         bne clrscr
         lda #$03    ;Clear color memory
         ldx #$00
clrcol   sta $d800,x
         sta $d900,x
         sta $da00,x
         sta $db00,x
         dex
         bne clrcol
         rts
delay                ;delay to next line. Refresh DMA cycles run at 1Mhz (5 cycles)
         jsr clockslide+(255+14-22) ;delay 22 CPU cycles
delayntscpal
         lda palflag
         bne return  ;*** WARNING - BRANCH SHOULD NOT CROSS PAGE BOUNDARY  ***
         bit $ea
         nop     
return   rts

set2mhztext
         lda $01
         sta restorebank
         lda #$31    ;Bank in charrom
         sta $01     ;$e000-$ffff
       
         lda #<demotext ;reset
         ldx #>demotext
         sta $02
         stx $03
         lda #0
         sta $04
looptext
         ldy #40  
         lda($02),y
         ora #$a0
         sta fastcharline+1
         ldy #0
         lda($02),y
         tax
         inc $02
         lda chartable,x
         sta fastchardata+1
         lda chartable+256,x
         sta fastchardata+2
         ldx #>drawcode
         lda $04
         asl
         clc
         adc #<drawcode
         bcc startfd
         inx
startfd
         sta fgfx+1
         stx fgfx+2
         ldx #0
fastcharline
         lda #$a0
         ldy #0
         jsr fgfx
         
fastchardata
         lda $0000,x
         iny
         jsr fgfx
         lda $04
         cmp #39
         bne skfs
insertdelay
         iny
         lda skipcycles,y
         jsr fgfx
         cpy #$4
         bne insertdelay
skfs
         inx
         cpx #8
         beq nextfastchar
nextcharline
         lda #83
         clc
         adc fgfx+1
         sta fgfx+1
         bcc fastcharline
         inc fgfx+2
         jmp fastcharline
nextfastchar
         inc $04
         lda $04
         cmp #40
         beq endfastdraw
         jmp looptext
endfastdraw
         iny
         lda skipcycles,y
         jsr fgfx
         cpy #$7
         bne endfastdraw
         lda #$00
restorebank=*-1
         sta $01     
         rts
fgfx
         sta $0000,y
         rts     
skipcycles=*-2
         jsr delay
         jmp finishdraw
printscreentext
         lda #$16    ;C-set = lower case
         sta $d018

         ldx #0
         lda #1
         jsr setscreenpos
         jsr printline

         ldx #0
         lda #2
         jsr setscreenpos
         ldx #<fasttesttext
         ldy #>fasttesttext
         jsr printtext

         lda #displayctrlline
         ldx #0
         jsr setscreenpos
         ldx #<modecontrol
         ldy #>modecontrol
         jsr printtext

         ldx #0
         lda #7
         jsr setscreenpos
         ldx #<d030bitstext
         ldy #>d030bitstext
         jsr printtext
         jsr displayhb

         ldx #0
         lda #8
         jsr setscreenpos
         ldx #<disablefast
         ldy #>disablefast
         jsr printtext
         jsr printmethod

         ldx #0
         lda #delayctrline
         jsr setscreenpos
         ldx #<delaycontrol
         ldy #>delaycontrol
         jsr printtext
         jsr printmethod

         ldx #0
         lda #delayctrline+1
         jsr setscreenpos
         jsr printline
   
         lda #testbittestline
         ldx #0
         jsr setscreenpos
         ldx #<testbittext
         ldy #>testbittext
         jsr printtext

         lda #testbittestline+1
         ldx #0
         jsr setscreenpos
         ldx #<testbitline1;
         ldy #>testbitline1;
         jsr printtext

         lda #testbittestline+2
         ldx #0
         jsr setscreenpos
         ldx #<testbitline2;
         ldy #>testbitline2;
         jsr printtext

         lda #testbittestline+2
         ldx #20
         jsr setscreenpos
         ldx #<tbline2col2;
         ldy #>tbline2col2;
         jsr printtext

         lda #testbittestline+3
         ldx #0
         jsr setscreenpos
         ldx #<testbitline3;
         ldy #>testbitline3;
         jsr printtext

         lda #testbittestline+3
         ldx #20
         jsr setscreenpos
         ldx #<tbline3col2;
         ldy #>tbline3col2;
         jsr printtext

         lda #testbittestline+4
         ldx #0
         jsr setscreenpos
         ldx #<testbitline4;
         ldy #>testbitline4;
         jsr printtext

         lda #testbittestline+4
         ldx #20
         jsr setscreenpos
         ldx #<tbline4col2;
         ldy #>tbline4col2;
         jsr printtext

         lda #testbittestline+5
         ldx #0
         jsr setscreenpos
         ldx #<testbitline5;
         ldy #>testbitline5;
         jsr printtext

         lda #testbittestline+5
         ldx #20
         jsr setscreenpos
         ldx #<tbline5col2;
         ldy #>tbline5col2;
         jsr printtext

         lda #testbittestline+6
         ldx #20
         jsr setscreenpos
         ldx #<tbline6col2;
         ldy #>tbline6col2;
         jsr printtext

         jsr colorbox

         ldx #0
         lda #0
         jsr setscreenpos
         ldx #<title
         ldy #>title
         jsr printtext
     
         lda palflag
         bne paldetected
defaultntscdelay=$244
         lda #<defaultntscdelay
         ldx #>defaultntscdelay
         sta testbitdelay
         stx delay256+1
         lda #65
         ldx #<ntsctext
         ldy #>ntsctext
         jmp printpalntsc
paldetected
defaultpaldelay=$230
         lda #<defaultpaldelay
         ldx #>defaultpaldelay
         sta testbitdelay
         stx delay256+1

         lda #63
         ldx #<paltext
         ldy #>paltext
printpalntsc
         sta cyclesperline
         sec
         sbc #12
palntsccyclepos=$400+(14*40)+8
         jsr printtext
         jsr printdelay
         rts
printtext
         sta endprint+1
         stx $02
         sty $03
         ldy #0
         lda($02),y
         tay
         tax
printtextloop 
         lda($02),y
         sta($04),y
         dey
         bne printtextloop
         txa
updatetextpos
         clc
         adc $04
         sta $04
         bcc endprint
         inc $05
endprint
         lda #$00
         rts
printhex:
         ldy #$01
         pha
         lsr
         lsr
         lsr
         lsr
         jsr printdigit
         pla
         and #$f
         iny
printdigit
         tax
         lda hexlut,x
digitlocation
         sta ($04),y
endprintdigit
         rts
hexlut: 
 byt "0123456789ABCDEF"
printline
         lda #45
         ldy #40
nextchar
         sta ($04),y
         dey
         bne nextchar
         lda #40
         jmp updatetextpos
setscreenpos ;TAB (A,X)
         asl
         tay
         lda screenpositions,y
         sta $04
         lda screenpositions+1,y
         sta $05
         txa
         beq endsetscreen
         clc
         adc $04
         sta $04
         bcc endsetscreen
         inc $05
endsetscreen
         rts
init
         lda #$ff
         ldx #3
         ldy #2
         sta screenpositions
         stx screenpositions+1
initloop 
         clc
         adc #40
         bcc storepos
         inx
storepos
         sta screenpositions,y
         iny
         pha
         txa
         sta screenpositions,y
         pla
         iny
         cpy #50
         bne initloop
         rts
initchartable
         ldx #$00
         txa
         and #$1f 
         asl
         asl
         asl
         sta chartable,x
         txa
         lsr
         lsr
         lsr
         lsr
         lsr
         ora #$d8             ;use lowercase charset  d0=uppercase,d8=lowercase
         sta chartable+256,x
         inx
         bne initchartable+2
         rts
initclockslide
         lda #$c9
         ldx #0
         sta clockslide,x
         inx
         bne *-4
         lda #$c5
         ldx #$ea
         ldy #$60
         sta clockslide+254
         stx clockslide+255
         sty clockslide+256
         rts

checkkeyboard
         lda #$00
         beq keyscanner
         dec checkkeyboard+1
         rts
keyscanner
         lda #$ff
         sta $dc02
         lda #$00
         sta $dc03

         ldy #0
         lda #$fe
sclp1
         sta nextmask
         sta $dc00
         ldx $dc01
         cpx #$ff
         bne checkbit       
         iny
         lda #$00
nextmask=*-1
 ;        sec
         rol
         bcs sclp1
         rts
checkbit
        txa
        ldx #$08
 ;       sec
notfound
        dex
        rol
        bcs notfound
        tya
        asl
        asl
        asl
        asl
        sta rownumber
        txa
        asl
;        clc
        adc #$00
rownumber=*-1
        sta actionkey
        jmp (jumptable)
actionkey=*-2
         rts
         lda keyboardtab+4
         and #$20
         beq keyk
         jmp testkeyl
displayhb
         lda #7
         ldx #28
         jsr setscreenpos
         lda d030set
         and #$fc
         jsr printhex
         rts
delaynextkey
         lda #$06
         nop
         sta checkkeyboard+1
         rts
updatemode
         eor displaymode
         sta displaymode
         jsr setdisplaymode
         jmp delaynextkey
setdisplaymode
         lda #2
         ldx #12
         jsr setscreenpos
         lda #$20
         ldy #27
clearline
         dey
         sta ($04),y
         bne clearline
         lda #$00
displaymode=*-1
         tax
         and #$60
         ora #$1b
         sta d011set
         ldy #$31
         cmp #$40
         bcs ecmvalue
         dey
ecmloc=$0400+(displayctrlline*40)+11
ecmvalue
         sty ecmloc
         ldy #$31
         and #$20
         bne bmmvalue
         dey
bmmloc=ecmloc+13
bmmvalue
         sty bmmloc     
         txa
         ldy #$31
         and #$10
         bne mcmvalue
         dey
mcmvalue
mcmloc=bmmloc+13
         sty mcmloc
         ora #$c8
         sta d016set
         txa
         lsr
         lsr
         lsr
         lsr
         cmp #$4 
         bcc testmode
         beq testmode
         ldx#<illegaltext
         ldy#>illegaltext
         jsr printtext
   
testmode bne testmc
         ldx#<ecmtext
         ldy#>ecmtext
         jmp enddisplaymode
testmc   ror
         bcs mcm
         ldx#<standardtext
         ldy#>standardtext
         jmp testbm 
mcm
         ldx#<multitext
         ldy#>multitext
testbm
         jsr printtext
         ror
         bcs bmm
         ldx#<textmodetext
         ldy#>textmodetext
         jmp enddisplaymode
bmm
         ldx#<bimaptext
         ldy#>bimaptext
        
enddisplaymode      
         jsr printtext 
         rts

;START OF KEYBOARD ACTIONS
keya
         ldx testbitdelay
         bne tb1update
         lda delay256+1
         beq endtb1
         dec delay256+1
tb1update
         dex
         stx testbitdelay
         txa
         jsr printdelay
endtb1   jmp delaynextkey
keyb    
         lda #$20
         jmp updatemode
keyc  
         lda #testbittestline+2
         ldx #37
         jsr setscreenpos
         ldx testbitcolor
         inx
         txa
         and #$0f
         sta testbitcolor
         jsr printhex
         jmp delaynextkey
keyd
         ldx testbitdelay
         cpx #$ff
         bne tb2update
         lda delay256+1
         cmp #$d
         beq endtb2
         inc delay256+1
tb2update
         inx
         stx testbitdelay
         txa
         jsr printdelay
endtb2   jmp delaynextkey
keye    
         lda #$40
         jmp updatemode
keyh    
         lda d030set
         clc
         adc #$04
         sta d030set
         jsr displayhb
         jmp delaynextkey
keyi     inc $3fff
         lda #testbittestline+3
         ldx #37
         jsr setscreenpos
         lda $3fff
         jsr printhex
         jmp delaynextkey
keyk
         lda #$24
         ldy #$30
         cmp delayfast
         bne togglefast
         iny
         lda #$ea
togglefast

         sty slow2fast
         sta delayfast
         jmp delaynextkey
keyl
         lda #$24
         ldy #$30
         cmp delayslow
         bne toggleslow
         iny
         lda #$ea
toggleslow
         sty fast2slow
         sta delayslow
         jmp delaynextkey
keym    
         lda #$10
         jmp updatemode
keyo    
         ldy #$8e 
         cpy disablemethod
         bne methodstx
         ldy #$ce
methodstx
         sty disablemethod
         jsr printmethod
         jmp delaynextkey
keys     
         lda testbitdelay
         clc
         adc cyclesperline
         bcc printincrease
         ldx delay256+1
         cpx #$0d
         beq increaseoverflow
         inc delay256+1
printincrease       
         sta testbitdelay 
         jsr printdelay
ends     jmp delaynextkey
increaseoverflow
         lda testbitdelay
         jmp printincrease
keyw     
         lda testbitdelay
         sec
         sbc cyclesperline
         bcs printdecrease
         ldx delay256+1
         beq decreaseoverflow
         dec delay256+1
printdecrease      
         sta testbitdelay 
         jsr printdelay
         jmp delaynextkey
decreaseoverflow
         lda testbitdelay
         jmp printdecrease
keyx
         lda #15
         ldx #36
         jsr setscreenpos
         lda disabletestbit
         clc
         adc #4
         sta disabletestbit
         jsr printhex
         jmp delaynextkey
keyz
         lda #15
         ldx #31
         jsr setscreenpos
         clc
         lda enabletestbit
         bne setd030
         sec
setd030 
         adc #1
         and #3
         sta enabletestbit
         jsr printhex
         jmp delaynextkey
key1  
         lda #$01
         jmp togglesprite
key2  
         lda #$02
         jmp togglesprite
key3  
         lda #$04
         jmp togglesprite
key4  
         lda #$08
         jmp togglesprite
key5  
         lda #$10
         jmp togglesprite
key6  
         lda #$20
         jmp togglesprite
key7  
         lda #$40
         jmp togglesprite
key8  
         lda #$80
togglesprite
         eor spriteon
         sta spriteon
         jmp delaynextkey
keyplus
         ldx vadjust
         beq endplus
         dex
         stx vadjust
         jsr verticaladjust
endplus
         rts
keyminus
         ldx vadjust
         cpx #30
         beq endminus
         inx
         stx vadjust
         jsr verticaladjust
endminus
         rts
keycomma  
         ldx delaycorrection
         inx
         beq endcomma
endcomma
         jmp delaynextkey
keyperiod 
         ldx delaycorrection
         beq endperiod
         dex
endperiod
         jmp delaynextkey
undefined
         rts
       
printmethod
         lda #8
         ldx #28
         jsr setscreenpos
         ldy disablemethod
         cpy #$8e
         beq methodisstx
         ldx #<dectext
         ldy #>dectext
         jmp printtext
methodisstx 
         ldx #<stxtext
         ldy #>stxtext
         jmp printtext
barlocation=(21*40) 
colorbox
         ldx #0
nextcolor
         lda #160
colorlocation=(19*40)+8 
         sta $400+colorlocation,x
         sta $400+colorlocation+40,x
         sta $400+colorlocation+1,x
         sta $400+colorlocation+41,x
         txa 
         lsr
         sta $d800+colorlocation,x
         sta $d800+colorlocation+1,x
         sta $d800+colorlocation+40,x
         sta $d800+colorlocation+41,x
         inx
         inx
         cpx #$20
         bne nextcolor
         rts
printdelay
         lda #14
         ldx #15
         jsr setscreenpos
         lda delay256+1
         ldy #$00
         jsr printdigit
         lda testbitdelay
         jsr printhex
         rts
reset
         ldx #$ff
         txs
         lda #$35    ;switch in IO
         sta $01
         jsr initstableraster
         lda #$00
         sta displaymode
         sta disabletestbit
         sta enabletestbit
         sta spriteon
         sta vadjust
         lda #200
         sta $d000
         lda #$01
         sta d030set
         lda #$05
         sta testbitcolor
         lda #$8e
         sta disablemethod
         lda #$24
         sta delayfast
         sta delayslow
         lda #$00
         sta $3fff
         jsr init
         jsr initclockslide
         jsr initchartable
         jsr set2mhztext
         lda #$7f    ;Disable CIA IRQ's
         sta $dc0d
         sta $dd0d
detectntscpal
         lda $d012
         bne detectntscpal           ; wait for rasterline 0 or 256
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
         clc
         ror
         ror       
         sta palflag
         jsr clrscreen
         jsr printscreentext
         jsr setdisplaymode
         jsr inittest1
         lda #<nmi  ;Install RASTER NMI
         ldx #>nmi  ;into Hardware
         sta $fffa   ;Interrupt Vector
         stx $fffb
 
         lda #$01    ;Enable RASTER IRQs
         sta $d01a
         lda #stableraster
         sta $d012
         lda #$1b    ;High bit (lines 256-311)
         sta $d011   ;NOTE double IRQ cannot be on or around a BAD LINE!(Fast Line)
 
         lda #bordercolor   ;Set Background
         sta $d020   ;and Border colors
         lda #backgroundcolor 
         sta $d021
         lda #$00
         sta $d015   ;turn off sprites
 
         asl $d019   ;Ack any previous
         bit $dc0d   ;IRQ's
         bit $dd0d
         lda #0+32
         ldy #12
         ldx palflag
         bne noadjust
         lda #(312-262)+32
         ldy #22
noadjust
         sta palntscvadjust
         sta clockslide2a
         sty raisescreen
         jsr verticaladjust
         lda ciatimerset,x
         sta $dc04
         lda ciatimerset+1,x
         sta $dc05
         lda #$ff
         sta $dc06
         sta $dc07
         ldy #$10
spritesetup
         lda spritepos,y
         sta $d000,y
         dey
         bpl spritesetup

         ldy #$07
spritedatasetup
         lda spritedata,y
         sta 2040,y
         lda spritecolors,y
         sta $d027,y
         dey
         bpl spritedatasetup
         lda #$ff
         ldx #63
sprdata
         sta spritepage*64,x
         dex
         bpl sprdata
         cli         ;Allow IRQ's
         jmp *       ;Endless Loop
spritepos
         byt 96,228,120,228,144,228,168,228,192,228,216,228,240,228,8,228,128
spritedata
         byt spritepage,spritepage,spritepage,spritepage,spritepage,spritepage,spritepage,spritepage
spritecolors
         byt 0,1,2,3,4,5,6,7
verticaladjust
         lda #00
vadjust=*-1
         clc
         adc #00
palntscvadjust =*-1
         sta clockslide1
         lda #224-32
         sec
         sbc vadjust
         sta clockslide2
         rts
delayfromcode=13;30;30+9
                ; 
ntscframetime=65*(263+ntscframepos-stableraster2)-1
palframetime=63*(palframepos-stableraster2)-1

lastframetime byt 0,0
config                 ; NTSC
vblankraster byt <ntscvblank
ciatimerset  word ntscframetime
framepos     byt <ntscvblank,128*(>ntscvblank)
calcpos      byt <ntscframepos,128*(>ntscframepos)
*=config+$80           ; PAL
             byt <palvblank
             word palframetime
             byt <palvblank,128*(>palvblank)
             byt <palframepos,128*(>palframepos)
align $100
jumptable
        ;row0
word undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined
        ;row1
word key3,keyw,keya,key4,keyz,keys,keye,undefined
        ;row2
word key5,undefined,keyd,key6,keyc,undefined,undefined,keyx
        ;row3
word key7,undefined,undefined,key8,keyb,keyh,undefined,undefined
        ;row4
word undefined,keyi,undefined,undefined,keym,keyk,keyo,undefined
        ;row5
word keyplus,undefined,keyl,keyminus,keyperiod,undefined,undefined,keycomma
        ;row6
word undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined
        ;row7
word key1,undefined,undefined,key2,undefined,undefined,undefined,undefined
align $100
demotext  byt "0-BLACK 2-RED   9-BROWN ",95,95,105,105,32,95,95,105,105,32,95,95,105,105,32,32
democolor byt 0,0,0,0,0,0,0,0,2,2,2,2,2,2,2,2,9,9,9,9,9,9,9,9,0,0,0,0,0,2,2,2,2,2,9,9,9,9,9,0
cyclesperline byt 0

title        byt 26,"VICIIe D030 TEST (V2.0) - "
paltext      byt 3,"PAL"
ntsctext     byt 4,"NTSC"
standardtext byt 9,"Standard "
multitext    byt 11,"Multicolor "
ecmtext      byt 4,"ECM "
textmodetext byt 5,"Text "
bimaptext    byt 7,"Bitmap "
modetext     byt 4,"Mode"
illegaltext  byt 8,"Illegal "
fasttesttext byt 13,"2 MHZ BIT - "

d030bitstext byt 27,"   H - D030 unused bits   :"
disablefast  byt 27,"   O - 2Mhz Disable method:"
modecontrol  byt 37,"   E - ECM:     B - BMM:     M - MCM:"
delaycontrol byt 31," K/L - Delay set/reset    : 0/0"
testbittext  byt 35,"TEST BIT: Lines cut:   Cycles Lost:"
testbitline1 byt 5,$20,$6f,$6f,$6f,$20
testbitline2 byt 5,$6a," W ",$65
tbline2col2  byt 19,"  C - BGD color: 05"
testbitline3 byt 17,$6a,"A+D",$65,"- DELAY :000"
tbline3col2  byt 19,"  I - Idle data: 00"
testbitline4 byt 14,$6a," S ",$65,"  Raster:"
tbline4col2  byt 18,"Z/X - D030 00==>00"
testbitline5 byt 5,$20,$77,$77,$77,$20
tbline5col2  byt 18,"+/- - Vertical Pos"
tbline6col2  byt 19,"1-8 - Toggle sprite"
dectext      byt 3,"DEC"
stxtext      byt 3,"STX"
tbcontrol    byt 31," Z/X - D030 ON/OFF value: 00/00"
adcontrol    byt 28," Delay: A-D W-S  1/63 cycles"
wscontrol    byt 29," W-S - 63 cycles"


clockslide=(*+$ff)&$ff00        ; jsr clockslide+(255-x) =14+x cycles  257 bytes total
screenpositions=clockslide+257  ; 50 bytes
chartable=clockslide+512
drawcode=chartable+512