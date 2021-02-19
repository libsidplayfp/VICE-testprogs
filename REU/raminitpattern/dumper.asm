
    * = $0801
    !byte $0c, $08, $00, $00, $9e, $20, $34, $30, $39, $36
    !byte 0,0,0

    * = $1000

    sei
    ldx #0
    stx $d020
    stx $d021
-
    lda #$20
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
    lda #$01
    sta $d800,x
    sta $da00,x
    lda #$0c
    sta $d900,x
    sta $db00,x
    inx
    bne -

    jsr openfile

    ldx #512/64
--
    txa
    pha

    ldx #64
-
    txa
    pha

    dec $d020

    ; copy 1kb
    JSR copyREUtoC64

    jsr writeblock

    inc $d020

    clc
    lda pageaddr
    adc #4
    sta pageaddr
    bcc +
    inc bankaddr
+

    pla
    tax
    dex
    bne -

    pla
    tax
    dex
    bne --

    jsr closefile

-
    inc $d020
    jmp -

;------------------------------------------------------------------------------

bankaddr:   !byte 0
pageaddr:   !byte 0

copyREUtoC64:                  ; REU -> C64

    ; C64 addr
    LDA #$04
    STA $DF03
    LDA #$00
    STA $DF02

    ; REU addr
    LDA #$00
    STA $DF04
    LDA pageaddr
    STA $DF05
    LDA bankaddr
    STA $DF06

    ; length
    LDA #$04
    STA $DF08
    LDA #$00
    STA $DF07

    LDA #$00
    STA $DF09   ; IMR
    STA $DF0A   ; ACR
    LDa #$91
    STa $DF01   ; Command
    RTS

;------------------------------------------------------------------------------


file_start = $0400
file_end   = $0800

openfile:
        LDA #fname_end-fname
        LDX #<fname
        LDY #>fname
        JSR $FFBD     ; call SETNAM

        LDA #$02      ; file number 2
        LDX $BA       ; last used device number
        BNE skip
        LDX #$08      ; default to device 8
skip:   LDY #$02      ; secondary address 2
        JSR $FFBA     ; call SETLFS

        JSR $FFC0     ; call OPEN
        BCS error     ; if carry set, the file could not be opened

        ; check drive error channel here to test for
        ; FILE EXISTS error etc.

        LDX #$02      ; filenumber 2
        JSR $FFC9     ; call CHKOUT (file 2 now used as output)

        rts

writeblock:
        LDA #<file_start
        STA $AE
        LDA #>file_start
        STA $AF

        LDY #$00
loop:   JSR $FFB7     ; call READST (read status byte)
        BNE werror    ; write error
        LDA ($AE),Y   ; get byte from memory
        JSR $FFD2     ; call CHROUT (write byte to file)
        INC $AE
        BNE skip2
        INC $AF
skip2:
        LDA $AE
        CMP #<file_end
        LDA $AF
        SBC #>file_end
        BCC loop      ; next byte

        rts

closefile:
close:
        LDA #$02      ; filenumber 2
        JSR $FFC3     ; call CLOSE

        JSR $FFCC     ; call CLRCHN
        RTS
error:
        ; Akkumulator contains BASIC error code

        ; most likely errors:
        ; A = $05 (DEVICE NOT PRESENT)

        ;... error handling for open errors ...
        JMP close    ; even if OPEN failed, the file has to be closed
werror:
        ; for further information, the drive error channel has to be read

        ;... error handling for write errors ...
        JMP close

fname:
        !pet "dumpfile,p,w"  ; ,P,W is required to make this an output file!
fname_end:
