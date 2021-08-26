; from https://sourceforge.net/p/vice-emu/bugs/1531/

; in desboot.prg the Hart cartridge is checked for on 3 addresses:
; $D71B, $DE1B and $DF1B

; The routine checks for a 8250 UART by writing $03 to the Line Control Register
; and expecting the same value when reading back the register.

*=$1c01

    ; SYS line
    !byte $0B, $1C, $CE, $07, $9E, $37, $31, $38
    !byte $31, $00, $00, $00

    ldx #0
-
    lda #$20
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
    sta $d020
    sta $d021
    lda #$01
    sta $d800,x
    sta $d900,x
    sta $da00,x
    sta $db00,x
    inx
    bne -

    lda #$03
    sta $3fff

    lda  #$0E
    sta  $FF00                        ; MMU CR

    lda #$1b
    sta $fb

    ; on 2Mhz
    lda #$01
    sta $d030

-   bit $d011
    bpl -
-   bit $d011
    bmi -

    lda #$d7
    sta $fc
    jsr HartDetect
    lda #'0'
    adc #0
    sta $0428

    lda #$de
    sta $fc
    jsr HartDetect
    lda #'0'
    adc #0
    sta $0429

    lda #$df
    sta $fc
    jsr HartDetect
    lda #'0'
    adc #0
    sta $042a

    lda #$00
    sta $d030

-   bit $d011
    bpl -
-   bit $d011
    bmi -

    ; on 1Mhz first
    lda #$d7
    sta $fc
    jsr HartDetect
    lda #'0'
    adc #0
    sta $0400

    lda #$de
    sta $fc
    jsr HartDetect
    lda #'0'
    adc #0
    sta $0401

    lda #$df
    sta $fc
    jsr HartDetect
    lda #'0'
    adc #0
    sta $0402

    jmp *

;This routine is called 3 times
;with $FB/$FC containing $D718, $DE18 and $DF18

HartDetect:
      ldy  #$03
      lda  #$03
      sta  ($FB),y
      lda  ($FB),y
      cmp  #$03
      beq  chk2pass
      clc
      rts

chk2pass:
      sec
      rts
