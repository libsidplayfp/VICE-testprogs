
!if CIA = 1 {
    CIABASE = $dc00
}
!if CIA = 2 {
    CIABASE = $dd00
}

         *= $0801

         !byte $0b,$08,$00,$00
         !byte $9e,$32,$30,$36
         !byte $31,$00,$00,$00

         *= $080d

         sei
         cld

         lda #$35
         sta $01

         ldx #<irq
         lda #>irq
!if CIA = 1 {
         stx $fffe
         sta $ffff
}
!if CIA = 2 {
         stx $fffa
         sta $fffb
}
         lda #$00
         sta $d020
         sta $d021

         ldx #$00
clear:
         lda #$20
         sta $0400,x
         sta $0500,x
         sta $0600,x
         sta $0700,x
         lda #$01
         sta $d800,x
         sta $d900,x
         sta $da00,x
         sta $db00,x

         inx
         bne clear

         lda #$00
         sta $0400
         sta $0401

         lda #$7f
         sta CIABASE + $d
         bit CIABASE + $d

         lda #$08
         sta CIABASE + $e
         sta CIABASE + $f

         lda #$00
         sta CIABASE + $4
         sta CIABASE + $6
         lda #$10
         sta CIABASE + $5
         sta CIABASE + $7

!if TIMER = 1 {
         lda #$81
}
!if TIMER = 2 {
         lda #$82
}
         sta CIABASE + $d

         lda #$11
         sta CIABASE + $e
waittimera:
         lda CIABASE + $5
         cmp #$08
         bcs waittimera

         lda #$11
         sta CIABASE + $f

!if CIA = 1 {
         cli
}
loop:
         bit CIABASE + $d
         jmp loop
irq:
         pha

         lda CIABASE + $d
         lsr
         bcc nottimera
         inc $0400
nottimera:
         lsr
         bcc nottimerb
         inc $0401
nottimerb:
         pla
         rti


