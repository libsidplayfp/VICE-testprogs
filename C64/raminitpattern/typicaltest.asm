
; test related to "typical/beyond force" (bug #570)
;
; the original program reads from open I/O ($df00) and checks for repeating
; values. effectively it would "randomly" fail depending on the value present
; in $3fff, which is unitialized RAM. since the original behaviour is very hard
; to reproduce in a simple test program, we dont even try to do so, but make
; a table of valid values and check the memory directly.

;-------------------------------------------------------------------------------
            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0
;-------------------------------------------------------------------------------
            jmp start

start:
            ldx $3fff
            lda idleref,x
            bmi failed
            bne passed

failed:
            lda #10
            sta $d020
            lda #$ff
            sta $d7ff
            jmp *

passed:
            lda #5
            sta $d020
            lda #$00
            sta $d7ff
            jmp *

; FIXME: this table is not complete
; 1   - "typical" works
; 0   - undefined (test will fail)
; $ff - "typical" will crash or reset
idleref:
            !byte $01, $01, $01, $00, $00, $00, $00, $01,  $01, $00, $00, $00, $00, $00, $00, $ff
            !byte $00, $00, $00, $00, $00, $00, $00, $00,  $00, $00, $00, $00, $00, $00, $00, $00
            !byte $01, $00, $00, $00, $00, $00, $00, $00,  $00, $00, $00, $00, $00, $00, $00, $01
            !byte $00, $00, $00, $00, $00, $00, $00, $00,  $00, $00, $00, $00, $00, $00, $00, $01
            !byte $00, $00, $00, $00, $00, $00, $00, $00,  $00, $00, $00, $00, $00, $00, $00, $00
            !byte $00, $00, $00, $00, $00, $01, $00, $00,  $00, $00, $00, $00, $00, $00, $00, $00
            !byte $00, $00, $00, $00, $00, $00, $00, $00,  $00, $00, $00, $00, $00, $00, $00, $00
            !byte $00, $00, $00, $00, $00, $00, $00, $00,  $00, $00, $00, $00, $00, $00, $00, $00

            !byte $01, $00, $00, $00, $00, $00, $00, $00,  $00, $00, $00, $00, $00, $00, $00, $01
            !byte $00, $00, $00, $00, $00, $00, $00, $00,  $00, $00, $00, $00, $00, $00, $00, $00
            !byte $00, $00, $00, $00, $00, $00, $00, $00,  $00, $00, $00, $00, $00, $00, $00, $00
            !byte $00, $00, $00, $00, $00, $00, $00, $00,  $00, $00, $00, $00, $00, $00, $00, $00
            !byte $00, $00, $00, $00, $00, $00, $00, $00,  $00, $00, $00, $00, $00, $00, $00, $00
            !byte $00, $00, $00, $00, $00, $00, $00, $00,  $00, $00, $00, $00, $00, $00, $00, $00
            !byte $00, $00, $00, $00, $00, $00, $00, $00,  $00, $00, $00, $00, $00, $00, $00, $00
            !byte $01, $00, $00, $00, $00, $00, $00, $00,  $01, $ff, $ff, $01, $01, $ff, $ff, $ff

;-------------------------------------------------------------------------------
; original code extracted from "typical/beyond force" (bug #570)
;
; original demo uses Video $2000, Charset $0800 (RAM) (idle fetch at $3fff)
;
; this loop fills $2000 - $27ff with $20
;.C:4240  A0 08       LDY #$08
;.C:4242  A2 00       LDX #$00
;.C:4244  A9 20       LDA #$20
;i4246:
;i4248 = * + 2
;.C:4246  9D 00 28    STA $2000,X
;.C:4249  E8          INX
;.C:424a  D0 FA       BNE i4246
;.C:424c  EE 48 42    INC i4248
;.C:424f  88          DEY
;i4251 = * + 1
;.C:4250  D0 F4       BNE i4246          ; branch that is modified by check
;
;.C:413f  9A          TXS
;i4141 = * + 1
;.C:4140  A9 00       LDA #$00           ; changed to 1 when test passed
;.C:4142  F0 01       BEQ i4145
;.C:4144  60          RTS
;
; this is the actual test...
;i4145:
;.C:4145  AD 00 DF    LDA $DF00          ; load from $df00 (io2)
;i4149 = * + 1
;.C:4148  C9 EA       CMP #$EA
;.C:414a  F0 09       BEQ i4155          ; if same as in last iteration, then go to fuckup code
;.C:414c  8D 49 41    STA i4149          ; remember value for next round
; change the branch in above loop to jump to $4242
;.C:414f  A9 F0       LDA #$F0
;.C:4151  8D 51 42    STA i4251
;i4154:
;.C:4154  60          RTS
;i4155:
; fuckup code
;.C:4155  EE 51 42    INC i4251          ; increment branch target addr
;.C:4158  D0 FA       BNE i4154
;
;.C:415a  A9 01       LDA #$01           ; flag that the test passed
;.C:415c  8D 41 41    STA i4141
;.C:415f  60          RTS
;
