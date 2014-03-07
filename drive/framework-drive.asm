.bin2ser:
         !byte %1111, %0111, %1101, %0101, %1011, %0011, %1001, %0001
         !byte %1110, %0110, %1100, %0100, %1010, %0010, %1000, %0000

snd_1byte:
        ldx #$0f
        sbx #$00
        lsr
        lsr
        lsr
        lsr
        sta .y1+1

        lda .bin2ser,x
.poll1:
        bit $1800      ; wait while ATN = 0
        bpl .poll1

        sta $1800
        asl            ; 2
        and #$0a       ; 2
        sta $1800

.y1:    lda .bin2ser   ; 4

        sta $1800
        asl            ; 2
        and #$0a       ; 2
        sta $1800

        rts

snd_init:
        lda #%01111010
        sta $1802
        lda #%00000000 ; DATA = 0
        sta $1800
        rts

snd_start:
        ; signal transfer start
        lda #%00000010 ; DATA = 1
        sta $1800
        nop
        nop
        lda #%00000000 ; DATA = 0
        sta $1800
        rts

