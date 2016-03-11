BORDERCOLOR = $d020
SCREENCOLOR = $d021
DEBUGREG = $d7ff

headerversion   = $0002

cleanimage      = 1     ; does not use memory outside loading range

imagestart      = $1000

;-------------------------------------------------------------------------------

!macro BWORD value {
    !byte (value >> 8) & $ff
    !byte (value >> 0) & $ff
}
!macro BLONG value {
    !byte (value >> 24) & $ff
    !byte (value >> 16) & $ff
    !byte (value >> 8) & $ff
    !byte (value >> 0) & $ff
}
;-------------------------------------------------------------------------------

!if (headerversion > $0001) {
    headerlen = $7c
} else {
    headerlen = $76
}

    * = imagestart - (headerlen + 2)

h00    !byte $50,$53,$49,$44     ;magicID: ``PSID'' or ``RSID''
h04    +BWORD headerversion      ; version
h06    +BWORD headerlen          ; offset to data
h08    +BWORD $0000              ;loadAddress
h0A    +BWORD init               ;initAddress
h0C    +BWORD play               ;playAddress
h0E    +BWORD $01                ;songs
h10    +BWORD $01                ;startSong
h12    +BLONG $00000000          ;speed

;    ``<name>''
h16 !byte $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$30,$31
;    ``<author>''
h36 !byte $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$30,$31
;    ``<released>'' (once known as ``<copyright>'')
h56 !byte $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$30,$31

!if (headerversion = $0002) {
h76    +BWORD $0000     ;flags
h78    !BYTE $00        ;startPage (relocStartPage)
h79    !BYTE $00        ;pageLength (relocPages)
h7A    !BYTE $00        ;secondSIDAddress (v3 only, should be 0)
h7B    !BYTE $00        ;reserved (should be 0)
}
!if (headerversion = $0003) {
h76    +BWORD $0000     ;flags
h78    !BYTE $00        ;startPage (relocStartPage)
h79    !BYTE $00        ;pageLength (relocPages)
h7A    !BYTE $00        ;secondSIDAddress
h7B    !BYTE $00        ;reserved (should be 0)
}
    ; binary load address (if not in header)
    ; not really part of the psid header
    * = (imagestart - 2)
    !word imagestart

;-------------------------------------------------------------------------------

    * = imagestart
    !text "test1234"
init
        jmp start
play
        rts

; NOTE: write vsid tests as if they are running on a C64 - this way they can
;       also be used for checking native .sid players

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
            !scr "vsid-fail                               "
            } else {
            !scr "vsid-pass                               "
            }

waitframes:
            jsr waitframes2
waitframes2:
            lda $d011
            bpl *-3
            lda $d011
            bmi *-3
            rts
