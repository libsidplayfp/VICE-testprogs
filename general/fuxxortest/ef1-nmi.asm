; emufux0r v1 first NMI test
;-------------------------------------------------------------------------------        

        * = $0801
        
        !word $080b, 0
        !byte $9e
        !text "2560"
        !byte $00,$00,$00

;-------------------------------------------------------------------------------        
        
        * = $0a00
        
        sei

        lda #2
        sta $d020

        lda #$35
        sta $01
        ldx #$ff
        txs
        
        lda #<nmiprotc
        sta $fffa
        lda #>nmiprotc
        sta $fffb

        lda #$01
        sta $dd04
        sta $dd05
        sta $dd0e
        lda #$81
        sta $dd0d

        jmp *

nmiprotc:
        cld
        sei
        ; test passed
        lda #5
        sta $d020
        lda #0
        sta $d7ff
        sta $07e7
        jmp *
