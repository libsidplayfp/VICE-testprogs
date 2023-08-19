sid_freq_lo     = $d400
sid_freq_hi     = $d401
sid_pw_lo       = $d402
sid_pw_hi       = $d403
sid_control     = $d404
sid_ad          = $d405
sid_sr          = $d406

voice3          = 14

scan_addr       = $2000

*= $0801
            !word f00
            !word 0
            !byte $9e
            !text "2064"
f00:        !byte 0,0,0

*= $0810
start:      jsr clearInterrupts    ; Clear interrupts to not disturb timing in initSid
            lda #$35
            sta $01
            jsr clearSid
            lda #$0b
            sta $d011
            ldx #3            ; Wait a couple of frames just to be sure sid is cleared (probably not needed)
            jsr waitFrames
            jsr scanSid
            lda #$1b
            sta $d011
            jsr printInfo
            jmp *

scanSid:
            ; Sample the noise register at every $1000th phase accumulator value
            lda #1
            sta hiNybbs+1
            lda #$10
            sta jmpPtr+1
            lda #<scan_addr
            sta scanPtr+1
            lda #>scan_addr
            sta scanPtr+2
nextAccu:   jsr initSid
            jsr storeNoiseLevel

            dec jmpPtr+1
            bne nextAccu
            lda #<min
            sta jmpPtr+1
            inc $d020
            inc hiNybbs+1
            lda hiNybbs+1
            cmp #$80
            bne nextAccu
            rts

initSid:
            lda #$00
            sta sid_freq_hi+voice3
            sta sid_freq_lo+voice3

            jsr initNoise

            lda #$10
            sta sid_freq_hi+voice3

hiNybbs:    ldx #1
er:         nop
            nop
            nop
            nop
            bit $ea
            dex
            bne er
jmpPtr:     jmp (max & $ff00) | $000d

!align 255,0
max:        lda #$a9
            lda #$a9
            lda #$a9
            lda #$a9
            lda #$a9
            lda #$a9
            lda #$a9
            lda #$a9
min:        lda $eaa5
            lda #0
            sta sid_freq_hi+voice3
            lda #0
            sta sid_pw_hi+voice3
            sta sid_pw_lo+voice3
            dec $d020
            rts

initNoise:
            ldx #7
; In theory shouldn't 3 times be enough here since it is the maximum number of bits between outputs
; of the LFSR? 3 does not seem to completely clear the LFSR since the end result then differs
; between runs. However on a real chip, 7 or more times here provides stable result and on 
; VICE 2.4 r31587, 4 or more times is enough, so there is something more to it..
; In VICE 3.7 the result seem totally random no matter how what value you use.

y1:         lda #$f8        ; Shift in zeroes
            sta sid_control+voice3
            lda #$80
            sta sid_control+voice3
            dex
            bne y1
            ldx #$11        ; Clock LFSR an arbitrary nr of times to get a specific value before starting the oscillator
y2:         lda #$88
            sta sid_control+voice3
            lda #$80
            sta sid_control+voice3
            dex
            bne y2
            rts

storeNoiseLevel:
            lda #$81
            sta sid_control+voice3
            lda $d41b
scanPtr:    sta scan_addr,y
            iny
            bne *+5
            inc scanPtr+2
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

printInfo:

            ldx #0
            txa
-
            sta scan_addr+$7f0,x
            dex
            bne -

            ldy #8
--
            ldx #0
-

inf0=*+2
            lda scan_addr,x
            sta $0400,x
inf1=*+2
            cmp reference,x
            beq +
            lda #$ff
            sta failed1
            lda #10
            sta failed2
+
            inx
            bne -
            dey
            bne --

failed1=*+1
            lda #0
            sta $d7ff
failed2=*+1
            lda #13
            sta $d020

            rts

!align 255,0
;$2000-$2061: $3F
;$2062-$2261: $7F
;$2262-$2561: $ff
;$2562-$2761: $fe
;$2762-$27ef: $fc
reference:
            !binary "reference.bin"
            !fill $100, 0

