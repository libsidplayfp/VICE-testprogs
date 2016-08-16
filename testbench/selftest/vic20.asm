
SCREENCOLOR = $900f
DEBUGREG = $910f        ; http://sleepingelephant.com/ipw-web/bulletin/bb/viewtopic.php?f=2&t=7763&p=84058#p84058

; by default, VIC20 tests should run on +8K expanded VIC20
;SCREENRAM = $1e00
SCREENRAM = $1000
;COLORRAM = $9600
COLORRAM = $9400

            * = $1201
            !word eol,0
            !byte $9e, $34,$36,$32,$31, 0 ; SYS 4621
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
            sta COLORRAM,x
            sta COLORRAM+$0100,x
            lda #$20
            sta SCREENRAM,x
            sta SCREENRAM+$0100,x
            inx
            bne lp1
; preferably show the name of the test on screen
            ldx #21
lp2:
            lda testname,x
            sta SCREENRAM+(22*22),x
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

; before exiting, wait for at least one frame so the screenshot will actually
; show the last frame containing the result
            ldx #2
--
-           lda $9004
            beq -
-           lda $9004
            bne -
            dex
            bne --

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
