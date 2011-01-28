  processor 6502

  .org $801
basic:
  .word 0$      ; link to next line
  .word 1995    ; line number
  .byte $9E     ; SYS token

; SYS digits

  .if (* + 8) / 10000
  .byte $30 + (* + 8) / 10000
  .endif
  .if (* + 7) / 1000
  .byte $30 + (* + 7) % 10000 / 1000
  .endif
  .if (* + 6) / 100
  .byte $30 + (* + 6) % 1000 / 100
  .endif
  .if (* + 5) / 10
  .byte $30 + (* + 5) % 100 / 10
  .endif
  .byte $30 + (* + 4) % 10

0$:
  .byte 0,0,0   ; end of BASIC program


start:
  lda #<greet_msg
  ldy #>greet_msg
  jsr $ab1e
  jsr clrscr

restart:
  lda #$00
  sta $fa
nexttest:
  lda #$00
  sta $dc0e
  sta $dc0f
  sta $dd0e
  sta $dd0f
  lda $dc0d
  lda $dd0d
  ldx $fa
  lda icr,x
  sta useirc+1
  lda cr,x
  sta usecr+1
  lda tlow,x
  sta usetlow+1
  lda cianr,x
  sta usecia11+2
  sta usecia12+2
  sta usecia13+2
  sta usecia14+2
  sta usecr+2
  sta usetlow+2
  eor #$01
  sta usecia21+2
  sta usecia22+2
  sta usecia23+2
  sta usecia24+2
  txa
  asl
  tax
  lda out+1,x
  tay
  lda out,x
  sta output0+1
  sty output0+2
  clc
  adc #40
  sta output1+1
  bcc nr1
  iny
nr1:
  sty output1+2
  clc
  adc #40
  sta output2+1
  bcc nr2
  iny
nr2:
  sty output2+2
  clc
  adc #40
  sta output3a+1
  sta output3b+1
  bcc nr3
  iny
nr3:
  sty output3a+2
  sty output3b+2
  clc
  adc #40
  sta output4a+1
  sta output4b+1
  bcc nr4
  iny
nr4:
  sty output4a+2
  sty output4b+2

  sei
  lda #$35
  sta $01
  lda #$00
  sta $fffe
  lda #$0e
  sta $ffff
  lda #$00
  sta $fffa
  lda #$0e
  sta $fffb
  lda #$7f
  sta $dc0d
  sta $dd0d
useirc:
  lda #$80
usecia11:
  sta $dc0d
  cli
  jsr test
  inc $fa
  lda $fa
  cmp #$08
  bne nrst
  jmp restart
nrst:
  jmp nexttest


end:
  jmp end

test:
  lda $d011
  bpl test

  ldx #$10
  lda $dc0d
  lda $dd0d
  lda #$00
  sta $dc04
  sta $dc06
  sta $dd04
  sta $dd06
  lda #$01
  sta $dc05
  sta $dc07
  sta $dd05
  sta $dd07
usecia21:
  inc $dd04
  lda #$11
usecr:
  sta $dc0f
usecia22:
  sta $dd0e

lp0:
  lda #$20
output3a:
  sta $0478,x
output4a:
  sta $04a0,x
  ldy #$1a
lp1:
  dey
  bne lp1

  lda #$80
  sec
usecia23:
  sbc $dd04
  jsr delay
usetlow:
  lda $dc06
  sec
  sbc #$15
output0:
  sta $0400,x
usecia12:
  lda $dc0d
output1:
  sta $0428,x
usecia13:
  lda $dc0d
output2:
  sta $0450,x

  dex
  bne lp0

  rts


  .org $0e00
  pha
usecia14:
  lda $dc0d
output3b:
  sta $0478,x
usecia24:
  lda $dd04
  clc
  adc #$10
output4b:
  sta $04a0,x
  pla
intexit:
  rti  
  
clrscr:
  ldx #$00
clrlp:
  lda #$01
  sta $d800,x
  sta $d900,x
  sta $da00,x
  sta $db00,x
  inx
  bne clrlp
  rts
  .org $1000
delay:              ;delay 80-accu cycles, 0<=accu<=64
    lsr             ;2 cycles akku=akku/2 carry=1 if accu was odd, 0 otherwise
    bcc waste1cycle ;2/3 cycles, depending on lowest bit, same operation for both
waste1cycle:
    sta smod+1      ;4 cycles selfmodifies the argument of branch
    clc             ;2 cycles
;now we have burned 10/11 cycles.. and jumping into a nopfield 
smod:
    bcc *+10
  .byte $EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA
  .byte $EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA
  .byte $EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA
  .byte $EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA
    rts             ;6 cycles


icr:
  .byte $80,$81,$80,$82,$80,$81,$80,$82

cr:
  .byte $0e,$0e,$0f,$0f,$0e,$0e,$0f,$0f

tlow:
  .byte $04,$04,$06,$06,$04,$04,$06,$06

cianr:
  .byte $dc,$dc,$dc,$dc,$dd,$dd,$dd,$dd  
  
out:
  .word $0450,$0518,$0464,$052c,$0608,$06d0,$061c,$06e4

greet_msg:
  dc.b 147,"CIA-TIMER R02 / RUBI",13,13,0
