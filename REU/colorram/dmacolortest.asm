

         *= $0801

         !byte $0b,$08,$00,$00
         !byte $9e,$32,$30,$36
         !byte $31,$00,$00,$00

         *= $080d

         sei
         cld

         lda #$00
         lda $d020
         sta $d021

         ldx #$00
clear
         lda #$a0
         sta $0400,x
         sta $0500,x
         sta $0600,x
         sta $0700,x
         sta $d800,x
         sta $d900,x
         sta $da00,x
         sta $db00,x

         inx
         bne clear

         lda #$00
         sta $df04
         sta $df05
         sta $df06
         sta $df09
         sta $df0a

         lda #$8f
         sta $df07
         lda #$01
         sta $df08

         lda #$fb
         sta line
         lda #$00
         sta color
loop
         bit $d011
         bmi *-3
         lda line
         cmp $d012
         bne loop

         lda #$00
         sta $df02
         lda #$d8
         sta $df03

         lda #$01
         sta $d020

         lda #%10110000
         sta $df01

         lda #$00
         sta $d020

         lda #$01
         sta $df02
         lda #$d8
         sta $df03

         lda #$0d
         sta $d020

         lda #%10110001
         sta $df01

         lda #$06
         sta $d020

         inc color
         lda color
         sta $d800
         sta $d828
         sta $d850
         sta $d878
         sta $d8a0
         sta $d8c8
         sta $d8f0
         sta $d918
         sta $d940
         sta $d968

         lda $dc00
         lsr
         bcs *+5
         dec line
         lsr
         bcs *+5
         inc line

         jmp loop
line
         !byte $00
color
         !byte $00


