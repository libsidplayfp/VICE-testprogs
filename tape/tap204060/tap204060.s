
; this program writes tap pulses spaced apart (8*$20), (8*$40), (8*$60), (8*$40)
; cycles.

; see https://sourceforge.net/p/vice-emu/bugs/1917/

    * =  $0801
    !byte $b, 8, $e7, $07 , $9e, $32, $30, $36, $31, 0, 0, 0

;------------------------------------------------------------------------------

start:

    jsr $e5a0         ; vic reset (only for testing)
    sei
    jsr $f838         ; press record & play on tape

    lda #$7f
    sta $dc0d
    sta $dd0d
    lda $dc0d
    lda $dd0d

    lda #$0b
    sta $d011
    sta $d020

    ; initial state of write line
!if (INVERT = 0) {
    lda #$05          ; start tape motor, output = 0
} else {
    lda #$0d          ; start tape motor, output = 1
}
    sta $01

    ; produce a long(er) pause
    ldx #20
-
    jsr w16tap      ; 6 + 113 = 119
    dex
    bne -

!if (INVERT = 0) {
    ; normal
    ldx #$d     ; write = 1
    lda #$5     ; write = 0
} else {
    ; inverted
    ldx #$5     ; write = 0
    lda #$d     ; write = 1
}

loop:

; $20
                    ; inverted           inverted
                    ; --------------    -----------
    stx $1          ; 2 output = 0      (509 (tap:$40) cycles since last falling edge, writes long pause on first iteration)

    jsr slide+21    ; 6+113+7 = 126

    sta $1          ; 2 output = 1

    jsr slide+21    ; 6+113+7 = 126

; $40

    stx $1          ; 2 output = 0      (252 (tap:$20)  cycles since last falling edge)

    jsr w16tap      ; 6+113    = 119
    jsr slide+11    ; 6+113+17 = 136

    sta $1          ; 2 output = 1

    jsr w16tap      ; 6+113    = 119
    jsr slide+11    ; 6+113+17 = 136


; $60

    stx $1          ; 2 output = 0      (508 (tap:$40) cycles since last falling edge)

    jsr w16tap      ; 6 + 113 = 119
    jsr w16tap      ; 6 + 113 = 119
    jsr slide+1     ; 6+113+27= 127

    sta $1          ; 2 output = 1

    jsr w16tap      ; 6 + 113 = 119
    jsr w16tap      ; 6 + 113 = 119
    jsr slide+1     ; 6+113+27= 127

; $40

    stx $1          ; 2 output = 0      (764 (tap:$60) cycles since last falling edge)

    jsr w16tap      ; 6+113    = 119
    jsr slide+11    ; 6+113+17 = 136

    sta $1          ; 2 output = 1

    jsr w16tap      ; 6+113    = 119
    jsr slide+14    ; 6+113+14 = 133

    jmp loop        ; 3

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

