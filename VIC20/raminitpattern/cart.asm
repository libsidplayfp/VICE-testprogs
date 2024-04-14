
SCREENCOLOR = $900f
DEBUGREG = $910f        ; http://sleepingelephant.com/ipw-web/bulletin/bb/viewtopic.php?f=2&t=7763&p=84058#p84058

; by default, VIC20 tests should run on +8K expanded VIC20
!if EXPANDED = 1 {
SCREENRAM = $1000
COLORRAM = $9400
} else {
SCREENRAM = $1e00
COLORRAM = $9600
}

            * = $a000

            !word start
            !word start
            !byte $41, $30, $c3, $c2, $cd

start:
; usually we want to SEI and set background to black at start
            sei
            ldx #$ff
            txs
            cld

            ; first do the actual test
            ldx #0 ; fail
            !if TEST=0 {
            lda $288
            cmp #$ff
            bne fail
            }
            !if TEST=1 {
            lda $1046
            cmp #$ff
            bne fail
            }
            ldx #1 ; pass
fail:
            txa
            pha

            JSR $FD8D ; initialise and test RAM
            JSR $FD52 ; restore default I/O vectors
            JSR $FDF9 ; initialize I/O registers
            JSR $E518 ; initialise hardware

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
            pla
            cmp #0 ; fail
            beq fail1
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
            !if TEST=0 {
            !scr "ae                    "
            }
            !if TEST=1 {
            !scr "jelly monsters        "
            }
