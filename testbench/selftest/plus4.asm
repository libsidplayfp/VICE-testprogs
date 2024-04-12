
BORDERCOLOR = $ff19
SCREENCOLOR = $ff15
DEBUGREG = $fdcf        ; http://plus4world.powweb.com/forum.php?postid=31417#31429

!if CART = 0 {
            * = $1001
            !word eol,0
            !byte $9e, $34,$31,$30,$39, 0 ; SYS 4109
eol:        !word 0
} else {
            * = $8000
            jmp start
            jmp start
            !byte $01, $43, $42, $4d     ; module-nr., "CBM"
}

start:
; usually we want to SEI and set background to black at start
            sei
!if CART = 1 {
            lda $fb
            pha
            ldx #$02       ; cartrige 1 lo, kernal
            sta $fdd0,x
            jsr $ff84      ; Initialize I/O devices
            jsr $ff87      ; RAM Test
            pla
            sta $fb
            jsr $ff8a      ; Restore vectors to initial values
            jsr $ff81      ; Initialize screen editor
            lda #<cartrige ; cartridge jump in
            sta $02fe
            lda #>cartrige
            sta $02ff
            lda #$f1       ; irq -> banking-routines
            sta $0314
            lda #$fc
            sta $0315
            cli
            jmp *
cartrige:
            lda #$ff
            sta $ff0c
            sta $ff0d           ; hide cursor
}
            lda #0
            sta BORDERCOLOR
            sta SCREENCOLOR
; when a test starts, the screen- and color memory should be initialized
            ldx #0
lp1:
            lda #$71
            sta $0800,x
            sta $0900,x
            sta $0a00,x
            sta $0b00,x
            lda #$20
            sta $0c00,x
            sta $0d00,x
            sta $0e00,x
            sta $0f00,x
            inx
            bne lp1
; preferably show the name of the test on screen
            ldx #39
lp2:
            lda testname,x
            sta $0c00+(24*40),x
            dex
            bpl lp2

; when a test has finished, it should set the border color to red or green
; depending on failure/success
            ldx #2      ; red
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

            jsr waitframe
            jsr waitframe
            jsr waitframe

            stx DEBUGREG

            jmp *

waitframe:
            pha
-           lda $ff1c
            and #1
            beq -
-           lda $ff1c
            and #1
            bne -
            pla
            rts

testname:
            !if FAIL=1 {
                 ;1234567890123456789012345678901234567890
            !scr "plus4-fail                              "
            } else {
            !scr "plus4-pass                              "
            }
