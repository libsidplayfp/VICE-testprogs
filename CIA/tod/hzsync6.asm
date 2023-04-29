;Clock-Test #6: 50Hz counter divider test (PAL only). Source for 64TASS (Cold Sewers)

; Find out if we can make the 50/60Hz divider skip 1/10 sec if we switch the
; set input frequency at the right time.
; The theory is that switching from 60 to 50 Hz when the ring counter is 5
; would skip an increment of the .1sec. The counter would then wrap from 5 to 0
; and match again after 4. That would make 6+5 power supply ticks between
; increments of the 1/10 sec.
; This program assumes that the video frame frequency matches the power supply
; tick frequency, for timing simplicity.

frame           = $02           ;frame counter

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

                lda #$00
                sta $dd0f       ;writes = ToD
                sei             ;just for safety's sake

                ldy #5
                sty $d020

                ldx #$00        ;init test pass counter

set             lda $d020
                pha
set2
                lda #$00
                jsr sync
                sta $d020       ;black border to indicate write/re-read phase of test pass
                sta $dd0e       ;input freq = 60Hzish
                sta $dd0b       ;at raster #$100, Tod := 0:00:00.0
                sta $dd0a
                sta $dd09
                sta $dd08
                ora $dd0b
                ora $dd0a
                ora $dd09
                ora $dd08
                bne set2         ;try again if time read != time written

                sta frame       ;reset frame counter
                dec $d020
                jsr sync        ;wait for 5 frames
                jsr sync        ;what should be slightly less than 1 frame
                jsr sync        ;before the .1 secs get inc'ed again
		jsr sync
		jsr sync
                lda #$80
                sta $dd0e       ;input freq = 50Hzish

                pla
                sta $d020

wait4change     inc frame       ;repeat frame count++
                jsr sync        ;wait another frame
                lda $dd08
                beq wait4change ;until .1 secs change

                lda frame       ;current frame #
                ora #$30        ;+ offset screencode "0"
                sta $400,x      ;put on screen in white

                ldy #5
                cmp #$36
                beq ok1
                cmp #$37
                beq ok1
		lda failcnt
		beq fail1
		dec failcnt	; allow some failures, not too many
		bne ok1

fail1
                ldy #10
                sty $d020

ok1
                tya
                sta $d800,x

                inx             ;test 256 times in a row
                bne set

                cli             ;reenable timer1 irqs
                lda #$81
                sta $dc0d

                lda $d020
                and #$0f
                ldx #0 ; success
                cmp #5
                beq nofail
                ldx #$ff ; failure
nofail:
                stx $d7ff

                jmp *

sync            ldy #$ff        ;wait til raster #$100
                cpy $d012
                bne *-3
                cpy $d012
                beq *-3
                rts

text            .byte 147,13,13,13,13,13,13,13
                .text "hzsync6",13,13
                      ;1234567890123456789012345678901234567890
                .text "make .1sec skip its increment by",13
                .text "toggling the input frequency bit.",13
                .text "expected: most 6s, maybe some 7s.",13
                .text "a few 1s (fails) are tolerated."
                .byte 0

failcnt		.byte 6	; allow this many - 1 failures
