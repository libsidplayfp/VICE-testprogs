
; SHX page boundary crossing test by ninja/the dreams

; acme -f cbm -o shx-test.prg shx-test.asm

zp_start      = $57
cur_x         = $57
cur_y         = $57 + 1
cur_lo        = $57 + 2
cur_hi        = $57 + 3
cur_res       = $57 + 5
mem_pnt       = $57 + 6
mem_save      = $57 + 8
zp_end        = $57 + 9

            * = $0801

            !word $080d, 2006
            !byte $9e
            !text "2061"
            !byte 0,0,0

            lda #<(msg_start)
            ldy #>(msg_start)
            jsr $ab1e

            sei
            ; clear zp
            lda #0
            ldx #zp_end-zp_start-1
_1:
            sta zp_start,x
            dex
            bpl _1

            lda #<(dummy+1)
            sta cur_lo

            lda #1
            sta cur_x

            lda #$18
            sta $d011

            ldx #<(nmi)
            ldy #>(nmi)
            stx $fffa
            sty $fffb

            bit $d011
            bpl *-3
            bit $d011
            bmi *-3

            lda #$34
            sta $01
mainloop:
            lda cur_hi
            sta shx_pos1+2
            sta shx_pos2+2
            clc
            adc #1
            and cur_x
            sta cur_res

            lda cur_lo
            sta shx_pos1+1
            sta shx_pos2+1
            sta mem_pnt
            clc
            adc cur_y

            ; FIXME: anomaly on page crossing does not seem to work as
            ;        expected
            bcc no_pagecross
            lda cur_res
            !byte $2c                 ; BIT abs
no_pagecross:
            lda cur_hi                ; skipped on page crossing

            ; A=cur_res on page crossing, else =cur_hi
            sta mem_pnt+1

            lda cur_x
            sta $0400+38
            lda cur_res
            sta $0400+39

            ; save current value of location to be tested
            ldy cur_y
            lda (mem_pnt),y
            sta mem_save

            jsr timeit
            ldy #7
            dey
            bne *-1
            bit $ea
            nop

            ldy cur_y

            ldx cur_x
            txa
            eor #$ff
            sta (mem_pnt),y   ; X^$ff to test location

            ; badline begins here, so the SHX turns into STX as the &H+1 drops off
shx_pos1:   !byte $9e, $ff, $ff       ; shx $FFFF,y

            ; check if that is actually the case
            lda (mem_pnt),y
            sta $0428+38
            eor cur_x
            bne eeks1         ; was commented out

resume1:
            ldx cur_x
            lda cur_res
            eor #$ff
            sta (mem_pnt),y   ; cur_res^$ff to test location

            ; not in badline, so value stored is X & H+1
shx_pos2:   !byte $9e, $ff, $ff       ; shx $FFFF,y

            lda (mem_pnt),y
            sta $0428+39
            eor cur_res
            bne eeks2         ; was commented out

resume2:
            ; restore save value of location that was tested
            lda mem_save
            sta (mem_pnt),y

            lda cur_y
            eor #$ff
            sta cur_y
            bne mainloop
            inc cur_x
            bne mainloop
            inc cur_hi
            bne mainloop

            ; all ok!
            lda #<(msg_ok)
            ldy #>(msg_ok)
            ldx #5
            jmp print_ok

            ; error, first test failed
eeks1:
            ; FIXME: on error on page boundary crossing, just inc the value
            ;        on screen and continue
            lda cur_y
            cmp #$ff
            bne sk1
            inc $0400+80+38
            jmp resume1
sk1:

            lda mem_save
            sta (mem_pnt),y
            lda #<(msg_error1)
            ldy #>(msg_error1)
            ldx #2
            jmp print_ok

            ; error, second test failed
eeks2:
            ; FIXME: on error on page boundary crossing, just inc the value
            ;        on screen and continue
            lda cur_y
            cmp #$ff
            bne sk2
            inc $0400+80+39
            jmp resume2
sk2:

            lda mem_save
            sta (mem_pnt),y
            lda #<(msg_error2)
            ldy #>(msg_error2)
            ldx #2
print_ok:
            pha
            lda #$37
            sta $01
            pla
            stx $d020
            jsr $ab1e
            jsr print_info
            cli
            rts

print_info:
            lda cur_x
            ldx #2
            jsr hexout
            lda cur_y
            ldx #8
            jsr hexout
            lda cur_hi
            ldx #16
            jsr hexout
            lda cur_lo
            jmp hexout

dummy:        !byte 0,0

hexout:
            pha
            lsr
            lsr
            lsr
            lsr
            jsr hexout2
            pla
            and #$0f
hexout2:
            clc
            adc #$30
            cmp #$3a
            bcc ho_l1
            adc #7-1
ho_l1:
            sta $0450,x
            inx
            rts

nmi:
            pha
            lda #$37
            sta $01
            pla
            jmp ($fffa)


timeit:
            lda #$35
            sta $01
time_l1:
            ldx $d012
            cpx #$30 - 8
            bcc time_l1
            cpx #$f4 - 8
            bcs time_l2
            bit $d011
            bmi time_l1
            txa
            and #4
            bne time_l1
            txa
            and #$f8
            ora #4
            tax
PalTiming1:
            cpx $d012
            bne *-3
            ldy #9
            dey
            bne *-1
            cmp $60
            nop
            inx
            cpx $d012
            beq PalTiming2
            cmp $60                     ; cmp (),y could point to $DExx
            nop                         ; AR would crash
PalTiming2:
            ldy #9
            dey
            bne *-1
            nop
            nop
            nop
            inx
            cpx $d012
            beq PalTiming4
;rts           = *+1
            cmp $60
PalTiming4:
            ldy #10
            dey
            bne *-1
            nop
            inx
            cpx $d012
            bne PalTiming6
PalTiming6:
            !if >(*)<>>(PalTiming1) {
            !warn "TimeIt possibly misaligned!"
            }
            lda #$34
            sta $01
            rts

time_l2:
            jsr print_info
            jmp time_l1

msg_ok:
            !text "All OK.",13,0
msg_error1:
            !text "Something went unexpectedly! (1)",13, 0
msg_error2:
            !text "Something went unexpectedly! (2)",13, 0
msg_start:
            !text $93,14,13,"SHX-Test V1.0 by Ninja/The Dreams",13
            !text "X:00  Y:00  Mem:0000",13,13,0

