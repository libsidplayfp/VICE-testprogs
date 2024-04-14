
DEBUGREG = $daff

!if CART = 0 {
            ; the BASIC program is loaded to bank 1

            * = $0003
            !word eol,0
            ; BASIC stub copies the ml code to bank 15
            !byte $81, $49, $b2, $31, $30, $32, $34, $a4, $32, $30, $34, $37, $3a ; FOR I = 1024 TO 2047
            !byte $dc, $31, $3a                                                   ;  BANK 1
            !byte $4e, $b2, $c2, $28, $49, $29, $3a                               ;  N = PEEK(I)
            !byte $dc, $31, $35, $3a                                              ;  BANK 15
            !byte $97, $49, $2c, $4e, $3a                                         ;  POKE I,N
            !byte $82, $3a                                                        ; NEXT
            !byte $9e, $31, $30, $32, $34, 0                                      ; SYS 1024
eol:        !word 0
} else {
            * = $2000

            jmp start
            jmp start
            !byte $43, $c2, $cd, $32, $00
}

start:
!if CART = 0 {
            ; SYS always executes code in bank 15

            * = $400
            sei

            ;lda #1     ; switch to bank 1
            ;sta 0
} else {
            ; FIXME: the cartridge startup code really should be revised and
            ;        cleaned up by somehow who knows what he is doing. The
            ;        following was blindly copied from the only existing autostart
            ;        cartridge i found, and may only work by chance.
            ; TODO: disable the cursor
            sei
            jsr $f9fb   ; io init

            LDA #$00
            LDY #$08
            STA $0700
            STY $0701
            JSR $FF7B

            LDA #$F0
            STA $C1
            JSR $FF7E

            LDA #$00
            TAX
-
            ;STA $0002,X
            !byte   $9D,$02,$00     ; STA $0002,X - no zeropage mode to avoid rewriting $00/$01
            STA $0200,X
            STA $02F8,X
            INX
            BNE -

            LDX #$04
            JSR $FADA
            JSR $FBA2
            JSR $FF7E
}

; usually we want to SEI and set background to black at start
            sei

; when a test starts, the screen- and color memory should be initialized
            ldx #0
lp1:
            lda #$20
            sta $d000,x
            sta $d100,x
            sta $d200,x
            sta $d300,x
            sta $d400,x
            sta $d500,x
            sta $d600,x
            sta $d700,x
            inx
            bne lp1
; preferably show the name of the test on screen
            ldx #39
lp2:
            lda testname,x
            sta $d000+(24*80),x
            dex
            bpl lp2

; when a test has finished, it should set the border color to red or green
; depending on failure/success
            ldx #10     ; light red
            !if FAIL=1 {
                lda #1
            } else {
                lda #0
            }
            bne fail1
            ldx #5      ; green
fail1:
            stx BORDERCOLOR

; additionally when a test is done, write the result code to the debug register
; (0 for success, $ff for failure). this part has no effect on real hw or when
; the debug register is not available
            lda BORDERCOLOR
            and #$0f

            ldx #$ff    ; failure
            cmp #5      ; green
            bne fail2
            ldx #0      ; success
fail2:

            jsr wait

            stx DEBUGREG

            jmp *

wait:
            pha
            txa
            pha
            tya
            pha

            ldy #0
--          ldx #0
-           bit $eaea
            bit $eaea
            bit $eaea
            inx
            bne -
            iny
            bne --

            pla
            tay
            pla
            tax
            pla
            rts

testname:
            !if FAIL=1 {
                 ;1234567890123456789012345678901234567890
            !scr "cbm610-fail                             "
            } else {
            !scr "cbm610-pass                             "
            }


!if CART = 0 {
BORDERCOLOR: !byte 0
} else {
BORDERCOLOR = $02   ; must be in RAM
}

!if CART=1 {
    !align $1fff,0
}
