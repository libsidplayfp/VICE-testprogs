
; de00int.prg - originally written by marko makela (and/or andreas boose?)

bitmap1 = $0000
bitmap2 = $4000
vram1 = $0400
vram2 = $4400

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

    ldx #0
-
    lda #$53
    sta vram1,x
    sta vram1+$100,x
    sta vram1+$200,x
    sta vram1+$2e8,x
    lda #$74
    sta vram2,x
    sta vram2+$100,x
    sta vram2+$200,x
    sta vram2+$2e8,x
    lda #$02
    sta $d800,x
    sta $d900,x
    sta $da00,x
    sta $db00,x
    lda #$00
    sta bitmap2,x
    sta bitmap2+$0100,x
    sta bitmap2+$0200,x
    sta bitmap2+$0300,x
    inx
    bne -

    sei
    LDA #$7F
    STA $DC0D

    LDA #<iC03F
    STA $0314
    LDA #>iC03F
    STA $0315

    LDX #$1F
iC014:
    TXA
    ASL ; * 8
    ASL
    ASL
    TAY
    LDA iC094,X
    STA $4001,Y
    DEX
    BPL iC014
iC022:
    LDA $D012
    BNE iC022

    LDA #$3B       ; bitmap mode
    STA $D011
    LDA #$2F
    STA $D012
    LDA $D019
    STA $D019
    LDA #$81
    STA $D01A
    cli

    JMP *

;-------------------------------------------------------------------------------

iC03F:
    ; set up for double-irq stable raster
    LDA #<iC061
    STA $0314
    LDA #$06      ; vbank 2 (4000-7FFF)
    STA $DD00
    LDX $D012
    INX
    INX
    STX $D012
    DEC $D019
    CLI
    LDX #$0A
iC057:
    DEX
    BNE iC057
    NOP
    NOP
    NOP
    NOP
    JMP $EA81

iC061:
    LDA #<iC03F
    STA $0314
    DEC $D019
    ; stabilize last cycle
    LDA #$2F
    STA $D012
    BIT $FF
    LDA $D012
    CMP $D012
    BNE iC078
iC078:

    LDX #$10
iC07A:
    DEX
    BNE iC07A
    NOP
    NOP
    JSR $DE00  ; call routine in I/O
    LDA #$3B
    STA $D011
    LDX #$50
iC089:
    DEX
    BNE iC089
    LDA #$07
    STA $DD00  ; vbank 3 (0000-3FFF)
    JMP $EA81

;-------------------------------------------------------------------------------
; this will run in I/O space

iC094:
    LDA #$00
    TSX
    BRK
    LDY $DC01
    BRK
    CPY #$EF
    BEQ *
    PHA
    LDA #$01
    STA $D020
    BRK
    TXS
    BRK
    RTS

    BRK
    BRK
    BRK
