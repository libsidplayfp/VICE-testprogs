
BORDERCOLOR = $d020
SCREENCOLOR = $d021
DEBUGREG = $d7ff

!if CART = 0 {
            * = $0801
            !word eol,0
            !byte $9e, $32,$30,$36,$31, 0 ; SYS 2061
eol:        !word 0
} else {
            * = $8000

            !word start
            !word start
            !byte $c3, $c2, $cd, $38, $30
}

start:
!if CART = 1 {
            sei
            ldx #$ff
            txs
            cld

            ; we must set data first, then update DDR
            lda #$37
            sta $01
            lda #$2f
            sta $00

            ; enable VIC (e.g. RAM refresh)
            lda #8
            sta $d016

            ; write to RAM to make sure it starts up correctly (=> RAM datasheets)
-
            sta $0100, x
            dex
            bne -

            jsr $ff84   ; Initialise I/O
            jsr $ff87   ; Initialise System Constants
            jsr $ff8a   ; Restore Kernal Vectors
            jsr $ff81   ; Initialize screen editor
}
; usually we want to SEI and set background to black at start
            sei
            lda #0
            sta BORDERCOLOR
            sta SCREENCOLOR
; when a test starts, the screen- and color memory should be initialized
            ldx #0
-
            lda #1
            sta $d800,x
            sta $d900,x
            sta $da00,x
            sta $db00,x
            lda #$20
            sta $0400,x
            sta $0500,x
            sta $0600,x
            sta $0700,x
            inx
            bne -
; preferably show the name of the test on screen
            ldx #39
lp2:
            lda testname,x
            sta $0400+(24*40),x
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

            jsr waitframes

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

testname:
            !if FAIL=1 {
                 ;1234567890123456789012345678901234567890
            !scr "c64-fail                                "
            } else {
            !scr "c64-pass                                "
            }

waitframes:
            jsr waitframes2
waitframes2:
            lda $d011
            bpl *-3
            lda $d011
            bmi *-3
            rts
