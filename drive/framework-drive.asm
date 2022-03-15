.bin2ser:
         !byte %1111, %0111, %1101, %0101, %1011, %0011, %1001, %0001
         !byte %1110, %0110, %1100, %0100, %1010, %0010, %1000, %0000
;-------------------------------------------------------------------------------

snd_init:
!ifdef VC1571 {
        ; switch to 1Mhz
;        lda #%00000000
;        sta $1801
}
        lda #%01111010
        sta $1802
        lda #%00000000 ; CLOCK = 0 DATA = 0
        sta $1800
        rts

;-------------------------------------------------------------------------------

snd_start:
!ifdef VC1571 {
        ; switch to 1Mhz
;        lda #%00000000
;        sta $1801
}
        ; signal transfer start
        lda #%00001010  ; CLOCK = 1 DATA = 1
        sta $1800       ; 4

!ifdef VC1571 {
        bit $eaea       ; +4
}
        ; wait for acknowledge from C64
.poll2:
        bit $1800       ; 4 wait while ATN = 0
        bpl .poll2      ; 2/3

!ifdef VC1571 {
        bit $eaea       ; +4
        bit $eaea       ; +4
}
        lda #%00000000  ; 2 CLOCK = 0 DATA = 0
        sta $1800       ; 4
        rts

;-------------------------------------------------------------------------------
;!ifdef VC1571 {
!if 1 = 0 {
snd_1byte:
        stx .xtmp+1

        ldx #$0f
        ;sbx #$00   ; x = A & X
        
        lsr
        lsr
        lsr
        lsr
        sta .y1+1

        ; switch to 1Mhz
;         lda #%00000000
;         sta $1801

        ; signal transfer start
        lda #%00001010  ; CLOCK = 1 DATA = 1
        sta $1800       ; 4

        bit $eaea       ; +4
        bit $eaea       ; +4

        lda .bin2ser,x  ; 4/5
        ; wait for acknowledge from C64
.poll1:
        bit $1800       ; 4 wait while ATN = 0
        bpl .poll1      ; 2/3

        bit $eaea       ; +4
        nop             ; +2
;        bit $eaea

        sta $1800       ; 4

        asl             ; 2
        and #$0a        ; 2
        bit $eaea       ; +4
        bit $eaea       ; +4

        sta $1800       ; 4

.y1:    lda .bin2ser    ; 4
        bit $eaea       ; +4
        bit $eaea       ; +4

        sta $1800       ; 4

        asl             ; 2
        and #$0a        ; 2
        bit $eaea       ; +4
        bit $eaea       ; +4
;        bit $ea

        sta $1800       ; 4

        bit $eaea       ; +4
        bit $eaea       ; +4
        bit $eaea       ; +4
        nop             ; 2
        nop             ; 2
        nop             ; 2
        lda #%00000000  ; 2  CLOCK = 0 DATA = 0

        sta $1800       ; 4

.xtmp:  ldx #0
        rts
} else {
snd_1byte:
        stx .xtmp+1

        ldx #$0f
        sbx #$00
        lsr
        lsr
        lsr
        lsr
        sta .y1+1

!ifdef VC1571 {
        php
        sei
        ; switch to 1Mhz
        lda $1801
        sta .restore1801+1
        and #%11011111
        sta $1801
}
        ; signal transfer start
        lda #%00001010 ; CLOCK = 1 DATA = 1
        sta $1800

        lda .bin2ser,x
        ; wait for acknowledge from C64
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

        nop
        nop
        nop
        lda #%00000000 ; CLOCK = 0 DATA = 0
        sta $1800

!ifdef VC1571 {
        ; switch to 2Mhz
.restore1801: lda #0
        sta $1801
        plp
}

.xtmp:  ldx #0


        rts
}
