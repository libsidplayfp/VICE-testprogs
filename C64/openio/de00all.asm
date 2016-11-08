
; de00all.prg - originally written by marko makela (and/or andreas boose?)
;
; this program shows how code can run entirely in the I/O space
;
; when working correctly, the program shows some pattern, the border color can
; be switched from black to white by pressing space

vram = $4400
bitmap = $6000

            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0
            jmp start
;-------------------------------------------------------------------------------

     * = $0900
start:

    SEI
    CLC
    LDA #$06       ; vbank 2, 4000-8000
    STA $DD00
    LDA #$3B       ; bitmap mode
    STA $D011
    LDA #$18       ; vram to 4400, bitmap to 6000
    STA $D018

    lda #$f0
    ldx #0
-
    sta vram,x
    sta vram+$100,x
    sta vram+$200,x
    sta vram+$300,x
    inx
    bne -

    ; copy code fragments to bitmap
    LDA #<bitmap
    STA $F7
    LDA #>bitmap
    STA $F8
iC019:
    LDX #$00
iC01B:
    LDY #$07
    LDA iC08E,X
iC020:
    STA ($F7),Y
    DEY
    BPL iC020

    LDA $F7
    ADC #$08
    STA $F7
    BCC iC02F
    INC $F8
iC02F:
    INX
    CPX #$28
    BNE iC01B

    DEC $F8
    LDY #$F7
    LDA #$A1
    STA ($F7),Y
    INC $F8
    LDX $F8
    CPX #$7F
    BNE iC019

    STA $7FFF  ; A=$A1 idle fetches go here
    LDA #$EA
    STA $7FF8

    LDX #$07
iC04E:
    LDA iC081,X
    STA $47F8,X
    LDA iC089,X
    STA $7F5B,X
    DEX
    BPL iC04E

    LDA #$60
    STA $7ECF
    LDA #$B5
    STA $7EFF
    STA $7F37
    LDA #$00
    STA $01C1
    LDA #$DE
    STA $01C2
    LDX #$C0
    TXS
    LDA #$20
iC079:
    CMP $D012
    BNE iC079
    JMP $DE00  ; jump right into I/O space

;-------------------------------------------------------------------------------

iC081:  ; fragments go to sprite pointers
    TXS
    RTS
    NOP
    LDA $B5
    BRK
    LDA $B5
iC089:  ; fragments go to bitmap
    LDA $EA
    LDA $B5
    NOP
iC08E:  ; fragments go to bitmap ($28 bytes)
    LDA #$00
    LDX #$D0
    TXS
    BRK
    LDY $DC01
    BRK
    CPY #$EF
iC09A:
    BEQ iC09A
    PHA
    LDA #$01
    STA $D020
    BRK
    JMP $DE00

    LDA #$A1
    STA $47F9
    BRK
    LDA #$A1
    STA $47FC
    BRK
    LDX #$C0
    NOP
    BRK
    BRK
    BRK
    BRK
