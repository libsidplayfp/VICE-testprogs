
; this program writes tap pulses:
;
; normal:    <pause> <$20> <$40> <$60> | <$20> <$40> <$60> |
; inverted:  <pause> <$30> <$50> <$50> | <$30> <$50> <$50> |

; see https://sourceforge.net/p/vice-emu/bugs/1917/

    * =  $0801
    !byte $b, 8, $e7, $07 , $9e, $32, $30, $36, $31, 0, 0, 0

;------------------------------------------------------------------------------

start:

    jsr $e5a0         ; vic reset (only for testing)
    jsr $f838         ; press record & play on tape

    sei

    lda #$7f
    sta $dc0d
    sta $dd0d
    lda $dc0d
    lda $dd0d

    lda #$0b
    sta $d011
    sta $d020

    ;                 cycles        normal      inverted
    ;                 --------      ----------  ----------

    ; NOTE: usually, before running the program, $01 would be = $37, ie
    ; motor: off,                   write = 0   write = 0

    ; initial state of write line, start tape motor
!if (INVERT = 0) {
    lda #$05        ; 2 (write = 0)
} else {
    lda #$0d        ; 2 (write = 1)
}
    sta $01         ; 2             write = 0   write = 1           <- tap starts here

    ; produce a long(er) pause (about 2 seconds)
    lda #$3e
    sta $02
--
    tya
    pha

    ; 31743us = 31.743ms
    ldx #0          ; 2
-
    jsr w16tap      ; 6 + 113 = 119
    dex             ; 2
    bne -           ; 3 / 2

    dec $02
    bne --
    dec $d020

!if (INVERT = 0) {
    ; normal
    ldx #$d         ; 2 (write = 1)
    lda #$5         ; 2 (write = 0)
} else {
    ; inverted
    ldx #$5         ; 2 (write = 0)
    lda #$d         ; 2 (write = 1)
}

loop:

; $20
                    ; cycles          normal      inverted
                    ; -------------   ---------   ---------
    stx $1          ; 2               write=1(*)  write=0      (512 (tap:$40) cycles since last falling edge, writes long pause on first iteration)

    jsr slide+21    ; 6+113+7 = 126

    sta $1          ; 2               write=0     write=1(*)   (384 (tap:$30) cycles since last falling edge, writes long pause on first iteration)

    jsr slide+21    ; 6+113+7 = 126

; $40

    stx $1          ; 2               write=1(*)  write=0      (256 (tap:$20) cycles since last falling edge)

    jsr w16tap      ; 6+113    = 119
    jsr slide+12    ; 6+113+16 = 135

    sta $1          ; 2               write=0     write=1(*)   (384 (tap:$30) cycles since last falling edge)

    jsr w16tap      ; 6+113    = 119
    jsr slide+12    ; 6+113+16 = 135


; $60

    stx $1          ; 2               write=1(*)  write=0      (512 (tap:$40) cycles since last falling edge)

    jsr w16tap      ; 6 + 113 = 119
    jsr w16tap      ; 6 + 113 = 119
    jsr slide+3     ; 6+113+25= 144

    sta $1          ; 2               write=0     write=1(*)   (640 (tap:$50) cycles since last falling edge)

    jsr w16tap      ; 6 + 113 = 119
    jsr w16tap      ; 6 + 113 = 119
    jsr slide+3     ; 6+113+25= 144

; $40

    stx $1          ; 2               write=1(*)  write=0      (768 (tap:$60) cycles since last falling edge)

    jsr w16tap      ; 6+113    = 119
    jsr slide+12    ; 6+113+16 = 135

    sta $1          ; 2               write=0     write=1(*)   (640 (tap:$50) cycles since last falling edge)

    jsr w16tap      ; 6+113    = 119
    jsr slide+15    ; 6+113+13 = 132

!if LOOP = 1 {
    jmp loop        ; 3
} else {
    inc $d020
    jmp *
}

;---------------------------------------------------------------------------

    !align 255,0

slide:
    !byte $c9, $c9    ; + 0:28  c9  c9  cmp #$c9 ; 2
    !byte $c9, $c9    ; + 2:26  c9  c9  cmp #$c9 ; 2
    !byte $c9, $c9    ; + 4:24  c9  c9  cmp #$c9 ; 2
    !byte $c9, $c9    ; + 6:22  c9  c9  cmp #$c9 ; 2
    !byte $c9, $c9    ; + 8:20  c9  c9  cmp #$c9 ; 2
    !byte $c9, $c9    ; +10:18  c9  c9  cmp #$c9 ; 2
    !byte $c9, $c9    ; +12:16  c9  c9  cmp #$c9 ; 2
    !byte $c9, $c9    ; +14:14  c9  c9  cmp #$c9 ; 2
    !byte $c9, $c9    ; +16:12  c9  c9  cmp #$c9 ; 2
    !byte $c9, $c9    ; +18:10  c9  c9  cmp #$c9 ; 2
    !byte $c9, $c9    ; +20: 8  c9  c9  cmp #$c9 ; 2
    !byte $c9, $c9    ; +22: 6  c9  c9  cmp #$c9 ; 2
    !byte $c9, $c5    ; +24: 4  c9  c5  cmp #$c5 ; 2
    !byte $ea         ; +26: 2  ea      nop      ; 2

w16tap:     ; 113 cycles

    ldy #21       ; 2
-
    dey           ; 2
    bne -         ; 3 (2)
    rts           ; 6

