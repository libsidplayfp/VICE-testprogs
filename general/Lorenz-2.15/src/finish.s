
; original file: n/a
;-------------------------------------------------------------------------------

           *= $0801
         .byte $4c,$16,$08,$00,$97,$32
         .byte $2c,$30,$3a,$9e,$32,$30
         .byte $37,$30,$00,$00,$00,$a9
         .byte $01,$85,$02

         jsr print
         .byte 13
         .text "test suite 2.15+ completed"
         .byte 13
         .byte 0


         lda #$00
         sta $d7ff

         rts

;-------------------------------------------------------------------------------

print    pla
         sta print0+1
         pla
         sta print0+2
         ldx #1
print0   lda 1234,x
         beq print1
         jsr $ffd2
         inx
         bne print0
print1   sec
         txa
         adc print0+1
         sta print2+1
         lda #0
         adc print0+2
         sta print2+2
print2   jmp 1234


