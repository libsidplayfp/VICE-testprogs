;Clock-Test #2e: 50/60Hz counter sync test (PAL only). Source for 64TASS (Cold Sewers)

;find out if changing the input frequency while the clock is running
;will reset the 50/60Hz-Counter

;slight code improvement: first result should be valid now

frame           = $02           ;frame counter
color           = $fb

* = $801
                .word eol,2192
                .byte $9e,$32,$30,$34,$39,0
eol             .word 0

                lda #<text      ;print what this test is all about
                ldy #>text
                jsr $ab1e

                lda #$7f        ;disable any CIA interrupts
                sta $dc0d
                sta $dd0d

                lda #$80
                sta $dd0e       ;input freq = 50Hzish
                lda #$00
                sta $dd0f       ;writes = ToD
                sei             ;just for safety's sake

                ldx #$00        ;init test pass counter

again           stx $dd08       ;to stabilize 1st pass: start clock
                cpx $dd08
                bne again       ;in case of latch bug
                cpx $dd08       ;else just wait on first .1 tick
                beq *-3

set             lda #$80
                sta $dd0e       ;set input freq to 50Hzish
                lda #$01
                sta color
                lda #$00
                jsr sync
                sta $dd0b       ;at raster #$100, Tod := 0:00:00.0
                sta $dd0a
                sta $dd09
                sta $dd08
                ora $dd0b
                ora $dd0a
                ora $dd09
                ora $dd08
                beq latchgood   ;if time read = time written

                asl color       ;else signal latch error
                lda #0

latchgood       sta frame       ;reset frame counter
                jsr sync        ;wait for 3 frames
                jsr sync        ;what should be roughly 2 frames
                jsr sync        ;before the .1 secs get inc'ed again

                sta $dd0e       ;change input freq to 60hzish

wait4change     inc frame       ;repeat frame count++
                jsr sync        ;wait another frame
                lda $dd08
                beq wait4change ;until .1 secs change

                lda frame       ;current frame #
                ora #$30        ;+ offset screencode "0"
                sta $400,x      ;put on screen:
                lda color       ;white if valid result, red if latch bug struck
                sta $d800,x

                inx             ;test 256 times in a row
                bne set

                cli             ;reenable timer1 irqs
                lda #$81
                sta $dc0d
                rts             ;return to basic interpreter

sync            ldy #$ff        ;wait til raster #$100
                cpy $d012
                bne *-3
                cpy $d012
                beq *-3
                rts

text            .byte 147,13,13,13,13,13,13,13
                .text "tod input frequency counter test:",13
                .text "1-4 = free running",13
                .text "5-7 = synced to freq. changes",0