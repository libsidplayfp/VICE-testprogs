
BORDERCOLOR = $d020
SCREENCOLOR = $d021
DEBUGREG = $d7ff

!if CART=0 {
            * = $1c01
            !word eol,0
            !byte $9e, $37,$31,$38,$31, 0 ; SYS 7181
eol:        !word 0
} else {
            * = $8000
            JMP start       ; cold-start vector
            JMP start       ; warm-start vector
            !byte 1             ; identifier byte. 1 = Autostart immediately.
            !byte $43,$42,$4D   ; "CBM" string
}

start:
; usually we want to SEI and set background to black at start
            sei
!if CART=1 {
            ldx #$ff
            txs
            cld
            lda #$e3
            sta $01
            lda #$37
            sta $00

            lda #%00001010     ; BIT 0   : $D000-$DFFF (0 = I/O Block)
                                ; BIT 1   : $4000-$7FFF (1 = RAM)
                                ; BIT 2/3 : $8000-$BFFF (10 = External ROM)
                                ; BIT 4/5 : $C000-$CFFF/$E000-$FFFF (00 = Kernal ROM)
                                ; BIT 6/7 : RAM used. (00 = RAM 0)
            sta $ff00          ; MMU Configuration Register

            jsr $ff8a          ; Restore Vectors
            jsr $ff84          ; Init I/O Devices, Ports & Timers
            jsr $ff81          ; Init Editor & Video Chips
}
            lda #0
            sta BORDERCOLOR
            sta SCREENCOLOR
; when a test starts, the screen- and color memory should be initialized
            ldx #0
lp1:
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
            bne lp1
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
            !scr "c128-fail                               "
            } else {
            !scr "c128-pass                               "
            }

waitframes:
            jsr waitframes2
waitframes2:
            lda $d011
            bpl *-3
            lda $d011
            bmi *-3
            rts
