; original source file: n/a
;-------------------------------------------------------------------------------
        * = $0801

        .word link
        .word 2011
        .byte $9e ; SYS
        .byte $32, $30, $36, $31
link
        .byte 0,0,0

;-------------------------------------------------------------------------------

        jsr print
        .byte $0d
        .text "please insert disk "
        .byte $31 + NEXT
        .byte $0d
        .byte 0

wait
        jsr $ffe4
        beq wait

        jsr print
name
.if NEXT = 1
        .text "beqr"
.endif
.if NEXT = 2
        .text "irq"
.endif
namelen  = *-name
         .byte 0

         lda #0
         sta $0a
         sta $b9
         lda #namelen
         sta $b7
         lda #<name
         sta $bb
         lda #>name
         sta $bc
         pla
         pla
         jmp $e16f

;-------------------------------------------------------------------------------

print    pla
         .block
         sta print0+1
         pla
         sta print0+2
         ldx #1
print0   lda !*,x
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
print2   jmp !*
         .bend
