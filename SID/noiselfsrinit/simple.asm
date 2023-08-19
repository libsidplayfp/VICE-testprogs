sid_freq_lo     = $d400
sid_freq_hi     = $d401
sid_pw_lo       = $d402
sid_pw_hi       = $d403
sid_control     = $d404
sid_ad          = $d405
sid_sr          = $d406

voice3          = 14

*= $0801
            !word f00
            !word 0
            !byte $9e
            !text "2064"
f00:        !byte 0,0,0

*= $0810
start:      jsr clearInterrupts     ; Clear interrupts to not disturb timing in initSid
            lda #$35
            sta $01
            jsr initScreen
loop:
            jsr clearSid
            ldx #3                  ; Wait a couple of frames just to be sure sid is cleared (probably not needed)
            jsr waitFrames
            inc $d020               ; Here we are at the border to avoid bad lines in initSid
            jsr initSid
            dec $d020
            jsr printNoiseLevel
            jsr waitSpace
            jmp loop

initSid:
            lda #$00
            sta sid_freq_hi+voice3
            sta sid_freq_lo+voice3
            jsr initNoise
            ldy #0
            lda #$f8
            sta sid_freq_hi+voice3
uww:        iny
            cpy #2
            bne uww
            bit $ea
            nop
            nop
            nop
            lda #$40
            sta sid_freq_hi+voice3
            bit $ea
            nop
            nop
            nop
            nop
            nop
            lda #0
            sta sid_freq_hi+voice3  ; Here we should be at a specific hard coded phase accu
            rts

initNoise:
            ldx #7                  ; In theory shouldn't 3 times be enough here? See comment in initNoise in scan.asm
y1:         lda #$f8                ; Shift in zeroes
            sta sid_control+voice3
            lda #$80
            sta sid_control+voice3
            dex
            bne y1
            ldx #$11                ; Clock LFSR an arbitrary nr of times to get a specific value before starting the oscillator
y2:         lda #$88
            sta sid_control+voice3
            lda #$80
            sta sid_control+voice3
            dex
            bne y2
            rts

printNoiseLevel:
            lda #$81
            sta sid_control+voice3
            lda $d41b

            pha
            ldx #10 ; red
            ldy #$ff; failure
            cmp #$7f ; correct value
            bne +
            ldx #13 ; green
            ldy #0  ; success
+
            stx $d020
            sty $d7ff
            pla

            pha
            lsr
            lsr
            lsr
            lsr
            jsr printDigit
            pla
            and #$0f
            jsr printDigit
            inc scrPtr+1
            inc scrPtr+1
            beq initScreen
            rts

printDigit:
            cmp #$0a
            bcs    alpha
            clc
            adc #$30
            jmp scrPtr
alpha:      sec
            sbc #$09
scrPtr:     sta $0400
            inc scrPtr+1
            rts

clearInterrupts:
            lda #$08
            sta $dd0e
            sta $dd0f

            lda #<bare
            sta $fffa
            lda #>bare
            sta $fffb

            lda #$7f
            sta $dc0d
            sta $dd0d

            lda $dc0d
            lda $dd0d

            lda #$00
            sta $d01a
            rts
bare:
            rti

waitFrames:
nextFrm:    bit $d011
            bmi *-3
            bit $d011
            bpl *-3
            dex
            bne nextFrm
            rts

clearSid:
            ldx #$00
            lda #$00
rs:         sta $d400,x
            inx
            cpx #$19
            bne rs
            rts

initScreen:
            ldx #0
wgw:        lda #1
            sta $d800,x
            lda #$20
            sta $0400,x
            inx
            bne wgw
            rts

waitSpace:
            lda $dc01
            and #$10
            bne *-5
            rts
end:
