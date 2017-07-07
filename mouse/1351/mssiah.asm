
val_adc1_1 = $02
val_adc2_1 = $03
val_adc1_2 = $04
val_adc2_2 = $05

*=$0801
; BASIC stub: "1 SYS 2061"
!byte $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00

        sei

        ldx #0
-
        lda #1
        sta $d800,x
        sta $d900,x
        sta $da00,x
        sta $db00,x
        lda #$20
        sta $0400,x
        sta $0500,x
        sta $0600,x
        sta $0700,x
        inx
        bne -
        
mainlp:
        inc $d020
        jsr readmouse
        dec $d020
       
        lda val_adc1_1
        lsr
        lsr
        lsr
        lsr
        tax
        lda hextab,x
        sta $0400+0
        lda val_adc1_1
        and #$0f
        tax
        lda hextab,x
        sta $0400+1
       
        lda val_adc2_1
        lsr
        lsr
        lsr
        lsr
        tax
        lda hextab,x
        sta $0400+3
        lda val_adc2_1
        and #$0f
        tax
        lda hextab,x
        sta $0400+4
       
       
        lda val_adc1_2
        lsr
        lsr
        lsr
        lsr
        tax
        lda hextab,x
        sta $0400+6
        lda val_adc1_2
        and #$0f
        tax
        lda hextab,x
        sta $0400+7
       
        lda val_adc2_2
        lsr
        lsr
        lsr
        lsr
        tax
        lda hextab,x
        sta $0400+9
        lda val_adc2_2
        and #$0f
        tax
        lda hextab,x
        sta $0400+10
       
        jmp mainlp

hextab:
    !scr "0123456789abcdef"

readmouse:
                LDA     #$C0
                STA     $DC02  

                ; port 2 selektieren
                LDA     #$40
                STA     $DC00  

                ; ~240*5 = 1200 cycles warten
                LDX     #$F0
loc_245B:
                DEX
                BNE     loc_245B

                ; ADCs lesen
                LDA     $D419
                STA     val_adc1_1 
                LDA     $D41A
                STA     val_adc2_1 

                ; port 1 selektieren
                LDA     #$80
                STA     $DC00  

                ; ~240*5 = 1200 cycles warten
                LDX     #$F0
loc_2471:
                DEX
                BNE     loc_2471

                ; ADCs lesen
                LDA     $D419
                STA     val_adc1_2 
                LDA     $D41A
                STA     val_adc2_2 

                rts
