
    .macpack longbranch
    .export Start

.ifdef SCANFRQ0
scanreg = $d400
scantype = 1
.endif
.ifdef SCANOSC3
scanreg = $d41b
scantype = 0
.endif
.ifdef SCANENV3
scanreg = $d41c
scantype = 0
.endif

VOICE1 = $d400
VOICE2 = $d407
VOICE3 = $d40e

tmp = $02
tmp2 = $04

frameh = $06

Start:
                SEI
                ldx #$ff
                txs

.if (scantype = 0) || (scantype = 1)
                ; init sid
                LDA     #0
                LDX     #$17

loc_90F:
                STA     $D400,X
                DEX
                BPL     loc_90F

                LDA     #$F
                STA     $D418

                ; SR
                LDA     #$F0
                STA     VOICE1+6
                STA     VOICE2+6
                STA     VOICE3+6
.endif

;restart:

                ldx #0
@clr:
                lda #$10
                sta $0400,x
                sta $0500,x
                sta $0600,x
                sta $0700,x
                sta $4400,x
                sta $4500,x
                sta $4600,x
                sta $4700,x

                lda #$00
                .repeat 32,count
                sta $2000+(count*256),x
                sta $6000+(count*256),x
                .endrepeat
                inx 
                jne @clr

                lda #%01010101
                ldx #0
@clr1:
                sta $2000+(8*40*8),x
                sta $2040+(8*40*8),x
                sta $6000+(8*40*8),x
                sta $6040+(8*40*8),x
                inx
                bne @clr1

                ldx #0
@clr2:
                lda colors,x
                .repeat 9,count
                sta $0400+(count*40),x
                sta $4400+(count*40),x
                .endrepeat
                inx
                cpx #40
                bne @clr2

mloop:
                inc frame

                lda #0
                sta framecount
                sta bitcount
                sta tmp + 1
                sta tmp

frame = * + 1
                lda #0
                and #1
                bne @sk1
                lda #$20
                sta frameh
                lda #2
                sta $dd00
                jmp @sk2
@sk1:
                lda #$60
                sta frameh
                lda #3
                sta $dd00
@sk2:

                LDA     #$3B
                STA     $D011
                LDA     #0
                STA     $D015
                LDA     #$18
                STA     $D018

                ; trigger one "8 bit sample"
.if scantype = 0
                LDA     #$11     ; gate on, waveform 1
                STA     VOICE3+4
                LDA     #$09     ; gate on, testbit on, waveform 0
                STA     VOICE3+4

                lda     #$ff
                STA     VOICE3+1 ; freq hi
                LDA     #$01     ; gate on, waveform 0
                STA     VOICE3+4
.endif
                ; trigger simple note
.if scantype = 1
                LDA     #$11     ; gate on, waveform 1
                STA     VOICE1+4
                lda     #$2f
                STA     VOICE1+1 ; freq hi
                lda     #$ff
                STA     VOICE1+0 ; freq lo
                LDA     #$11     ; gate on, waveform 1
                STA     VOICE1+4
.endif

                ; each round takes 20 cycles
                ldx #0
@quicklp1:
                lda scanreg             ; 2
                sta quicksamples,x      ; 5
                nop                     ; 2
                nop                     ; 2
                nop                     ; 2
                inx                     ; 2
                cpx #64*2               ; 2
                bne @quicklp1           ; 2+1

                ldx #0
@quicklp2:
                jsr doquickscan
                inx
                cpx #64*2
                bne @quicklp2

                lda #64*2
                sta tmp
                lda #0
                sta framecount
                sta bitcount

mainloop:

                .repeat  SCANSPD,count

                    lda #(312 / SCANSPD) * count
                    cmp $d012
                    bne *-3

                    inc $d020
                    jsr doscan
                    dec $d020

                .endrepeat
                

                lda #0
                sta $d020
                
                jmp mainloop

restart:
                jsr showpos
                jmp mloop

doscan:
                jsr clearbits

                lda scanreg
                jeq restart
                sta scanregtmp

                jsr showbits

                jsr incpos
                jeq restart

;                jsr showpos
                rts

doquickscan:
                txa
                pha
                lda quicksamples,x
                sta scanregtmp
;                jsr clearbits
                jsr showbits
                jsr incpos
                pla
                tax
                rts

clearbits:
                .repeat 8,count
                ldy #count
                jsr clearbit
                .endrepeat
                rts
showbits:
                .repeat 8,count
                .scope
                clc
                rol scanregtmp
                bcc @skb1

                ldy #count
                jsr showbit

@skb1:
                .endscope
                .endrepeat
                rts

showpos:
                .repeat 8,count
                ldy #count
                jsr showbit
                .endrepeat
                rts


incpos:
                inc framecount
                lda framecount
                and #$07
                sta bitcount
                cmp #0
                bne @skp
                lda #8
                clc
                adc tmp
                sta tmp
                bcc @skp
                inc tmp+1
@skp:
                lda framecount
                rts
                
showbit:
                lda yoffsl,y
                clc
                adc tmp
                sta tmp2
                lda yoffsh,y
                ora frameh
                adc tmp + 1
                sta tmp2 + 1

                ldx bitcount
                ldy #0
                .repeat 8
                lda (tmp2),y
                ora bits,x
                sta (tmp2),y
                iny
                .endrepeat
                rts
                
clearbit:
                lda yoffsl,y
                clc
                adc tmp
                sta tmp2
                lda yoffsh,y
                ora frameh
                adc tmp + 1
                sta tmp2 + 1

                ldx bitcount
                ldy #0
                .repeat 8
                lda (tmp2),y
                and cbits,x
                sta (tmp2),y
                iny
                .endrepeat
                rts

scanregtmp: 
        .byte 0
framecount: 
        .byte 0
bitcount: 
        .byte 0

bits: 
        .byte $80,$40,$20,$10,$08,$04,$02,$01
cbits: 
        .byte <~$80,<~$40,<~$20,<~$10,<~$08,<~$04,<~$02,<~$01

yoffsl:
        .repeat 8,count
            .byte < ($2000 + (8 * 40 * count))
        .endrepeat

yoffsh:
        .repeat 8,count
            .byte > ($2000 + (8 * 40 * count))
        .endrepeat

quicksamples:
        .repeat 256
            .byte 0
        .endrepeat
        
colors:
        .repeat ((64*2)/8)
        .byte $f0
        .endrepeat
        .repeat (SCANSPD * 50) / 8,count
        .byte $10
        .endrepeat
        .repeat (SCANSPD * 50) / 8,count
        .byte $c0
        .endrepeat
        .repeat (SCANSPD * 50) / 8,count
        .byte $10
        .endrepeat



