i0BE9 = $04e9
i0BEA = $04ea   ; loop counter for c64->reu transfers
i0BEB = $04eb   ; bank nr, multiply by 64 after test to get detected size

i8000 = $0500

result = $04ec

;------------------------------------------------------------------------------
*= $0800

        !byte $00,$0c,$08,$0a,$00,$9e,$32,$30,$36,$32,$00,$00,$00,$00
;------------------------------------------------------------------------------
*= $080e
        lda #1
        sta $0286
        sta $d021
        lda #$93
        jsr $ffd2

        lda #0
        sta $d020
        sta $d021

        ldx #0
-
        lda #$20
        sta $0400,x
        sta $0500,x
        sta $0600,x
        sta $0700,x
        lda #1
        sta $d800,x
        sta $da00,x
        lda #12
        sta $d900,x
        sta $db00,x
        inx
        bne -

        jsr i85AC

        ldx #5
        ldy #0
        
        lda i0BEB
        !if TESTSIZE = 128 {
        cmp #2
        }
        !if TESTSIZE = 256 {
        cmp #4
        }
        !if TESTSIZE = 512 {
        cmp #8
        }
        !if TESTSIZE = 1024 {
        cmp #16
        }
        !if TESTSIZE = 2048 {
        cmp #32
        }
        !if TESTSIZE = 4096 {
        cmp #64
        }
        !if TESTSIZE = 8192 {
        cmp #128
        }
        !if TESTSIZE = 16384 {
        cmp #0
        }
        !if TESTSIZE = 0 {
        lda #0
        }
        beq +
        ldx #10
        ldy #$ff
+
        stx $d020
        sty $d7ff
        
        lda i0BEB
        sta result+1
        lda #0
        sta result+0

        lsr result+1
        ror result+0
        lsr result+1
        ror result+0

        lda result+1
        ldx result+0
        jsr $bdcd

        jmp *

;------------------------------------------------------------------------------
i85AC:

    LDA #$00
    STA i0BEB
    STA $DF09  ; ICR
    STA $DF04  ; REU Base Address - Low-Byte
    STA $DF05  ; REU Base Address - High-Byte
    STA $DF06  ; REU Base Address - Bank-Number
    STA $DF02  ; C64 Base Address - Low-Byte

    LDA #>i8000
    STA $DF03  ; C64 Base Address - High-Byte
    LDA #$40   ; fixed REU Address
    STA $DF0A  ; Address Control Register

    JSR i8646
    PHA
    LDA #$00
    JSR i8673
lp:
    INC i0BEB
    INC i0BEB
    LDA i0BEB
    STA $DF06  ; REU Base Address - Bank-Number
    JSR i8646
    STA i0BE9

    LDA i0BEB
    JSR i8673
    JSR i8637
    JSR i8646
    CMP i0BEB
    BNE skp
    JSR i8637
    PHA
    LDA i0BE9
    JSR i8673
    PLA
    BEQ lp
skp:
    LDA #$00
    STA $DF06  ; REU Base Address - Bank-Number
    PLA
    JSR i8673
    RTS
;------------------------------------------------------
i8637:
    LDA #$00
    STA $DF06  ; REU Base Address - Bank-Number
    JSR i8646
    LDX i0BEB
    STX $DF06  ; REU Base Address - Bank-Number
    RTS
;------------------------------------------------------
; transfer $0100 bytes from REU to C64 (-> i8000) multiple times
; checks if first byte in the buffer is the same as all other bytes in the
; buffer.

i8646:  ; do 256 transfers
    LDA #$00
i8648:  ; number of transfers to do in Akku
    STA i0BEA

    ; transfer length is $0100 bytes
    LDY #$01
    STY $DF08  ; Transfer-Length - High-Byte
    DEY
    STY $DF07  ; Transfer Length - Low-Byte

lp4:
    LDA #$B1   ; start REU -> C64 (autoload, transfer config)
    STA $DF01  ; command
lp2:
    ; wait for DMA to finish
    BIT $DF00  ; status
    BVC lp2

    LDA i8000
    LDX #$00
lp3:
    INX
    BEQ skp2    ; if all $0100 bytes were the same, exit with A=first byte in buffer

    CMP i8000,X
    BEQ lp3

    DEC i0BEA
    BNE lp4

    LDA #$FF    ; $ff in akku indicates error
skp2:
    RTS
;------------------------------------------------------
; transfer 1 byte (in Akku) to REU
i8673:
    LDY #$00
lp5:
    ; transfer length is 1 byte
    LDX #$00
    STX $DF08    ; Transfer-Length - High-Byte
    INX
    STX $DF07    ; Transfer Length - Low-Byte

    STA i8000
    PHA          ; remember stored value

    LDA #$B0     ; start C64 -> REU (autoload, transfer config)
    STA $DF01    ; command
    ; wait for DMA to complete
wait:
    BIT $DF00    ; status
    BVC wait

    LDA #$01
    JSR i8648
    BNE skp3    ; BUG: stack misalignment

    PLA          ; get back stored value
    CMP i8000
    BEQ skp4
skp3:
    DEY
    BNE lp5
    INY

skp4:
    RTS

;.C:869e  20 61 87    JSR $8761
 
