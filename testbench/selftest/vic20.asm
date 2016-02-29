
SCREENCOLOR = $900f
DEBUGREG = $9fff        ; FIXME -> http://sleepingelephant.com/ipw-web/bulletin/bb/viewtopic.php?f=2&t=7763&p=84058#p84058

            * = $1001
            !word eol,0
            !byte $9e, $34,$31,$30,$39, 0 ; SYS 4109
eol:        !word 0

start:
; usually we want to SEI and set background to black at start
            sei
            lda #$08
            sta SCREENCOLOR
; when a test starts, the screen- and color memory should be initialized
            ldx #0
lp1:
            lda #$00
            sta $9600,x
            sta $9700,x
            lda #$20
            sta $1e00,x
            sta $1f00,x
            inx
            bne lp1

            ldx #21
lp2:
            lda testname,x
            sta $1e00+(22*22),x
            dex
            bpl lp2

; when a test has finished, it should set the border color to red or green
; depending on failure/success
            ldx #$02|$10  ; red
            !if FAIL=1 {
                lda #1
            } else {
                lda #0
            }
            bne fail1
            ldx #$05|$10  ; green
fail1:
            stx SCREENCOLOR
; additionally when a test is done, write the result code to the debug register
; (0 for success, $ff for failure). this part has no effect on real hw or when
; the debug register is not available
            lda SCREENCOLOR
            and #$0f

            ldx #$ff    ; failure
            cmp #5      ; green
            bne fail2
            ldx #0      ; success
fail2:
            stx DEBUGREG

            jmp *

testname:
            !if FAIL=1 {
                 ;1234567890123456789012
            !scr "vic20-fail            "
            } else {
            !scr "vic20-pass            "
            }
