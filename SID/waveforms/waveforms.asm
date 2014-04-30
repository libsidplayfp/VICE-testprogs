;-------------------------------------------------------------------------------
            *=$07ff
            !word $0801
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

                jsr initsid

                lda #0
                sta currtest
-
                lda currtest
                asl
                asl
                asl
                asl
                sta wave

                jsr doonetest
                
                jsr updateinfo
                
                inc currtest
                lda currtest
                cmp #$10
                bne -
                
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
skip
                jsr doonetest
                
                jsr updateinfo
                
                jmp mainloop

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

;                ldx #$fe
;-               cpx $d012
;                bne -
;-               ldx $d012
;                bne -
                
                lda     #$ff
                STA     VOICE3+4 ; testbit on to reset/stop oscillator

                lda     #>$ffff
                STA     VOICE3+1 ; freq hi
                lda     #<$ffff
                STA     VOICE3+0 ; freq lo

;                ldx #$fe
;-               cpx $d012
;                bne -
;                dex
;-               cpx $d012
;                bne -
;                dex
;-               cpx $d012
;                bne -
;                dex
;-               cpx $d012
;                bne -;
;
;-               ldx $d012
;                bne -

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
                ;lda #>buffer
                ;sta ptr+1
                tya
                pha
                clc
                adc #<buffer
                tay
                

;                ldx #0
;-
                !for i, 256 / 8 {
                tya
;                sta sample+4,x
                sta sample+4+((i-1)*6)
;                lda ptr+1
;                sta sample+5,x
                ;lda ptr+0
                clc
                adc #8
                tay
                ;sta ptr+0

                }
;                txa
;                clc
;                adc #6
;                tax

;                cpx #6*(256 / 8)
;                bne -
                
                pla
                tay
                rts

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

                