;-------------------------------------------------------------------------------
            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0
;-------------------------------------------------------------------------------

VOICE1 = $d400
VOICE2 = $d407
VOICE3 = $d40e

videoram = $0400
colorram = $d800

buffer = $0400

ptr      = $f7
rptr     = $f9

wave     = $fb
currtest = $fc
res      = $fd

start
                SEI
                ldx #$ff
                txs

                lda #$17
                sta $d018
                lda #$35
                sta $01

                ldx #0
                stx currtest
                stx wave
-
                lda #$20
                sta videoram,x
                sta videoram+$0100,x
                sta videoram+$0200,x
                sta videoram+$0300,x
                lda #1
                sta colorram,x
                sta colorram+$0100,x
                sta colorram+$0200,x
                sta colorram+$0300,x
                inx
                bne -

                ldx #3
-
                lda testname,x
                sta $0400+(40*24)+35,x
                dex
                bpl -

                jsr initsid

                lda #WAVE
                sta currtest
testloop:
                lda currtest
                asl
                asl
                asl
                asl
                sta wave

                lda currtest
                jsr showbits

                jsr doonetest

                jsr updateinfo

                !if (INTERACTIVE=1) {
                
                inc currtest
                lda currtest
                cmp #$10
                bne testloop

                lda #0
                sta currtest
                jsr showbits
mainloop:

again:
                jsr getkey
                ;cmp #0
                beq skip
                ;sta $0700
                cmp #$41
                bcc skip
                ;sta $0701
                cmp #$41 + $10
                bcs skip

                ;sta $0702
                sta videoram+ (8*40)+20
                sec
                sbc #$41
                sta currtest

                jsr showbits

skip
                jsr doonetest

                jsr updateinfo

                jmp mainloop
                
                } else {
                lda res
                sta $d020
                
                ldy #0      ; success
                lda $d020
                and #$0f
                cmp #5
                beq +
                ldy #$ff    ; failure
+
                sty $d7ff

                jmp *
                }
                
;-------------------------------------------------------------------------------

showbits:
                ;sta $0703
                tax
                asl
                asl
                asl
                asl
                sta wave

                lda hextab,x
                sta videoram+ (8*40)+22

                lda wave
                tax
                and #$80
                ora #$2e
                sta videoram+ (8*40)+24

                txa
                asl
                and #$80
                ora #$2e
                sta videoram+ (8*40)+25

                txa
                asl
                asl
                and #$80
                ora #$2e
                sta videoram+ (8*40)+26

                txa
                asl
                asl
                asl
                and #$80
                ora #$2e
                sta videoram+ (8*40)+27
                rts

getkey
                lda #$36
                sta $01
                cli
                jsr $ff9f
                jsr $ffe4
                pha
                sei
                lda #$35
                sta $01
                pla
                rts

doonetest:
                ;lda #$40
                ;sta wave
                jsr dotest

                clc
                lda currtest
                adc #>cmpbuffer
                sta ptr+1
                lda #<cmpbuffer
                sta ptr+0

                ldy #0
-
                lda buffer,y
                sta (ptr),y
                iny
                bne -

                clc
                lda currtest
                adc #>refbuffer
                sta rptr+1
                lda #<refbuffer
                sta rptr+0

                ldy #0
-
                lda (rptr),y
                sta videoram+ (10*40),y
                iny
                bne -

                ldx #5
                stx res
                ldy #0
-
                ldx #5
                lda buffer,y
                cmp (rptr),y
                beq +
                ldx #10
                stx res
+
                txa
                sta colorram,y
                iny
                bne -
                rts

updateinfo:
                ldx currtest
                inx
                txa
                sta videoram + (8*40),x

                ;ldx currtest
                ;inx
                lda res
                sta colorram + (8*40),x
                rts

;-------------------------------------------------------------------------------

hextab: !scr "0123456789abcdef"

!macro startsampling {
                inc $d020

                jsr setup

                lda     #$08
                STA     VOICE3+4 ; testbit on to reset/stop oscillator

                ; the noise waveform needs a while to reset, so if
                ; noise is selected, wait for a second...

                ; NOTE: the emulation uses 0x8000 cycles delay - however in
                ;       reality the requires delay can apparently be much
                ;       more, which suggests the register is not actually
                ;       cleared, but the bits slowly "fade" to "1"

                lda     wave
                and     #$80
                beq     +

                tya
                pha
                eor #$07
                clc
                adc #'0'
                sta $0400+(24*40)

    ldy #$10
---
    ldx #$00
--
    lda #$ff
-
    cmp $d012
    bne -
    dex
    bne --
    dey
    bne ---
                pla
                tay
+

                lda     #>$ffff
                STA     VOICE3+1 ; freq hi
                lda     #<$ffff
                STA     VOICE3+0 ; freq lo

                LDA     #$01     ; gate on
                ora     wave
;                lda     wave
                STA     VOICE3+4
}

!macro endsampling {
                inc $d020

                jsr sample
                iny
                dec $d020
                dec $d020
}
                !align 255, 0
dotest

                ldx #$fe
-               cpx $d012
                bne -
-               ldx $d012
                bne -

                stx $d020

                ldy #0

                ; sample 1
                +startsampling
                nop     ; 2
                +endsampling

                ; sample 2
                +startsampling
                bit $ea     ; 3
                +endsampling

                ; sample 3
                +startsampling
                nop     ; 2
                nop     ; 2
                +endsampling

                ; sample 4
                +startsampling
                nop     ; 2
                bit $ea     ; 3
                +endsampling

                ; sample 5
                +startsampling
                nop     ; 2
                nop     ; 2
                nop     ; 2
                +endsampling

                ; sample 6
                +startsampling
                nop     ; 2
                nop     ; 2
                bit $ea     ; 3
                +endsampling

                ; sample 7
                +startsampling
                nop     ; 2
                bit $ea ; 3
                bit $ea     ; 3
                +endsampling

                ; sample 8
                +startsampling
                bit $ea     ; 3
                bit $ea     ; 3
                bit $ea     ; 3
                +endsampling


                rts

;-------------------------------------------------------------------------------
initsid:
                ; init sid
                LDA     #0
                LDX     #$17

-
                STA     $D400,X
                DEX
                BPL     -

                LDA     #$F
                STA     $D418

                ; SR
                LDA     #$F0
                STA     VOICE1+6
                STA     VOICE2+6
                STA     VOICE3+6
                ; Pulsewidth hi
                lda     #$08
                STA     VOICE1+3
                STA     VOICE2+3
                STA     VOICE3+3
                rts

sample:
                !for i, 256 / 8 {
                lda $d41b           ; 4
                sta buffer          ; 4
                }
                rts

setup:
                tya
                pha
                clc
                adc #<buffer
                tay

                !for i, 256 / 8 {
                tya
                sta sample+4+((i-1)*6)
                clc
                adc #8
                tay

                }

                pla
                tay
                rts

testname:
            !if NEWSID = 0 {
                !scr "6581"
            }
            !if NEWSID = 1 {
                !scr "8580"
            }

                * = $4000
refbuffer:
            !if NEWSID = 0 {
                !binary "ref6581.prg", $1000, 2
            }
            !if NEWSID = 1 {
                !binary "ref8580.prg", $1000, 2
            }

                * = $5000
cmpbuffer:
