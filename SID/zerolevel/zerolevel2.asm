
            *=$0801
            !word bend
            !word 10
            !byte $9e
            !byte "2","0","6","1", 0
bend:       !word 0    

        jmp start

        * = $0900
start:
        lda #0
        ldx #$1f
-
        sta $d400,x
        dex
        bpl -

        lda #$08
        sta $d412
        lda #$0b
        sta $d417
        lda #$0f
        sta $d418
        lda #$f0
        sta $d414
        lda #$21
        sta $d412
        lda #$01
        sta $d40e

        ldx #$00
        lda #$38        ; Tweak this to find the "zero" level
-       cmp $d41b
        bne -
        stx $d40e        ; Stop frequency counter - freeze waveform output
        
-
        inc $d020
        jmp -
 
