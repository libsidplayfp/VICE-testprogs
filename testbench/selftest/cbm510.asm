
BORDERCOLOR = $d820
SCREENCOLOR = $d821
DEBUGREG = $daff

            ; the BASIC program is loaded to bank 0

            * = $0003
            !word eol,0
            ; BASIC stub copies the ml code to bank 15
            !byte $81, $49, $b2, $31, $30, $32, $34, $a4, $32, $30, $34, $37, $3a ; FOR I = 1024 TO 2047
            !byte $dc, $30, $3a                                                   ;  BANK 0
            !byte $4e, $b2, $c2, $28, $49, $29, $3a                               ;  N = PEEK(I)
            !byte $dc, $31, $35, $3a                                              ;  BANK 15
            !byte $97, $49, $2c, $4e, $3a                                         ;  POKE I,N
            !byte $82, $3a                                                        ; NEXT
            !byte $9e, $31, $30, $32, $34, 0                                      ; SYS 1024
eol:        !word 0

            ; SYS always executes code in bank 15

            * = $400
            sei
            lda #1
            sta BORDERCOLOR
            sta SCREENCOLOR

            ;lda #0     ; switch to bank 0
            ;sta 0

start:
; usually we want to SEI and set background to black at start
            sei
            lda #0
            sta BORDERCOLOR
            sta SCREENCOLOR

; when a test starts, the screen- and color memory should be initialized
            ldx #0
lp1:
            lda #1
            sta $d400,x
            sta $d500,x
            sta $d600,x
            sta $d700,x
            lda #$20
            sta $d000,x
            sta $d100,x
            sta $d200,x
            sta $d300,x
            inx
            bne lp1
; preferably show the name of the test on screen
            ldx #39
lp2:
            lda testname,x
            sta $d000+(24*40),x
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
            !scr "cbm510-fail                             "
            } else {
            !scr "cbm510-pass                             "
            }

waitframes:
            jsr waitframes2
waitframes2:
            lda $d811
            bpl *-3
            lda $d811
            bmi *-3
            rts
