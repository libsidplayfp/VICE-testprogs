
; from https://sourceforge.net/p/vice-emu/bugs/1531/

*=$1c01

SYSLine:
      !byte $0B, $1C, $CE, $07, $9E, $37, $31, $38
      !byte $31, $00, $00, $00
MainStart:
      lda #$03
      sta $3fff

      ldx  #$FF
      lda  #$0E
      sta  $FF00                        ; MMU CR
      lda  #$00
      sta  $D020                        ; Border
      sta  $D021                        ; Background
      lda  #$08
      sta  $D011
      lda  #$01
      sta  $D030                        ; Processor Clock Register



HartDetect:
      lda  #$03
      sta  $D71B
      lda  $D71B
      cmp  #$03
      bne  HartDetect
      inc  $D020
      jmp  HartDetect 
