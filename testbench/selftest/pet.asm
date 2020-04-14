
DEBUGREG = $8bff
CHAROUT = $ffd2

            * = $0401
            !word eol,0
            !byte $9e, $31,$30,$33,$37, 0 ; SYS 1037
eol:        !word 0

start:
; usually we want to SEI and set background to black at start
            sei
; when a test starts, the screen- and color memory should be initialized
            lda #$93
            jsr _CHAROUT
; preferably show the name of the test on screen
            ldx #0
lp2:
            txa
            pha
            lda testname,x
            jsr _CHAROUT
            pla
            tax
            inx
            cpx #40
            bne lp2

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
            
            jsr waitframe
            
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
            stx DEBUGREG

            jmp *

_CHAROUT:
            cli
            jsr CHAROUT
            sei
            rts
            
waitframe:
            ldx #0
-
            jsr waitframe2
            dex
            bne -
waitframe2:
            ldy #0
-
            dey
            bne -
            rts
            
testname:
            !if FAIL=1 {
                 ;1234567890123456789012345678901234567890
            !pet  "pet-fail                                "
            } else {
            !pet  "pet-pass                                "
            }

BORDERCOLOR:    !byte 0
