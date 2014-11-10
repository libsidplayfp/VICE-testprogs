
; SHX RDY/DMA test by ninja/the dreams

; acme -f cbm -o shx-t2.prg shx-t2.asm

spx           = $64
spy           = $65

spr_act       = $02

            * = $0801

            !word $080b,1
            !byte $9e
            !text "2061"
            !byte 0,0,0

            sei
            lda #$35
            sta $01

            lda #1
            sta spr_act
            lda #$55
            sta $3fff

            lda #spx
            sta $d000
            lda #spy
            sta $d001
            lda #1
            sta $d027
            lda #$40
            sta $07f8
endless:
            lda <spr_act
            sta $d015
            sta $d017

            ldx #$0e
            ldy #0

            lda #spy-1
            cmp $d012
            bne *-3
            nop
            nop
            dec $dc03
            inc $dc03
            lda $d013
            lsr
            lsr
            lsr
            sta timeit+1
timeit:     bpl *
            !byte $ea,$ea,$ea,$ea
            bcc *+2

            lda #0
            sta $d020
            sta $d021

delay_mod:  jsr delay+$1f
fld_loop:
            lda #4
            sta $d021
            lda #0
            sta $d021
            !byte $9e, $20, $d0         ; shx $d020,y
            sta $0400
            stx $0401
            sty $0402
            lda <spr_act
            bne no_delay
            nop
            nop
            nop
no_delay:
            nop
            nop
            nop
            lda $d012
            cmp #spy+42
            and #7
            eor #$1c
            sta $d011
            bcc fld_loop

            tsx
            stx $0403
            lda #$1b
            sta $d011

            lda #14
            sta $d020
            lda #6
            sta $d021


            lda $dc01
            lsr
            bcc key_1
            lsr
            bcs no_key
            lda #0
            !byte $2c
key_1
            lda #1
            sta <spr_act
no_key:
            lda delay_mod+1
            sec
            sbc #<(delay)
            ldx #0
            jsr hexout
            jmp endless

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
            sbc #$39
ho_l1:
            sta $0400,x
            inx
            rts

delay:
            !for n, 61 {
            !byte $a9
            }
            !byte $24,$ea
            rts
