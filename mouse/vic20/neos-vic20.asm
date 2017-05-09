; Mouse driver for NEOS mouse on Vic-20

; Uses tape buffer and accurate irq timings to change 4 bytes on screen 
; by remapping them to low memory (useable tape buffer memory is $334-$3ff):
; spritegfx: $334-$36c
; bytes 123,124,125,126 ($3d8-$3f7)

; assemble using ACME:
;
; acme -Dexpanded=0 -f cbm -o neos0k.prg Neos0k.asm
;
; acme -Dexpanded=1 -f cbm -o neos8k.prg Neos0k.asm

; for testing use something like this:
; xvic -memory all -controlport1device 4 -mouse neos8k.prg

; TODO:
;       - fix NTSC timing
;       - fix memory placement so driver can coexist with BASIC
;         - disable cursor during load to prevent breaking LOAD

DEBUG = 1

NTSCTIMING = 0  ; set to 1 for NTSC (currently broken)
showvalues = 1  ; set to 1 to show mouse coordinates in first line of the screen
ignorejoy3 = 1  ; set to 1 to ignore joy3 bit, which conflicts with the keyboard

!if (expanded=1) {
    basicstart = $1201      ; expanded
    screenmem  = $1000
    colormem   = $9400
} else {
    basicstart = $1001      ; unexpanded
    screenmem  = $1e00
    colormem   = $9600
}

;-------------------------------------------------------------------------------

        * = basicstart
        !word basicstart + $0c
        !byte $0a, $00
        !byte $9e
!if (expanded=1) {
        !byte $34, $36, $32, $32
} else {
        !byte $34, $31, $31, $30
}
        !byte 0,0,0

        * = basicstart + $0d
;start:
;        jmp mouseinit

;-------------------------------------------------------------------------------

mouseinit:
        ldx     #55
-
        lda     spritegfx,x
        sta     $334,x
        dex
        bne     -

        ; FIXME
        lda     #$18
        sta     $38     ;basic ends here!
        lda     #$dd
        sta     $37     ;basic ends here!

        lda     #$7f
        sta     $912e     ; disable and acknowledge interrupts
        sta     $912d

        ;synchronize with the screen
        ldx     #128       ; wait for this raster line (times 2)
-
        cpx     $9004
        bne     -

        ldy     #9
        bit     $24
resync:
        ldx     $9004
        txa
        bit     $24
!if (NTSCTIMING = 0) {
        ldx     #24
} else {
        bit     $24
        ldx     #21
}
-       dex
        bne     -           ; first spend some time (so that the whole

        cmp     $9004       ; loop will be 2 raster lines)
        bcs     +           ; save one cycle if $9004 changed too late
+       dey
        bne     resync

        lda     #$40        ; enable Timer A free run of both VIAs
        sta     $911b
        sta     $912b

        lda     #<$0236     ; length of timer low byte
        ldx     #>$0236     ; length of timer high byte
        sta     $9116       ; load the timer 1 low byte
        sta     $9126       ; load the timer low byte counter

!if (NTSCTIMING = 0) {
        ldy     #7          ; make a little delay to get the raster effect to the
-       dey                 ; right place
        bne     -
        nop
        nop
} else {
        ldy     #6
-       dey
        bne     -
        bit     $24
}
        stx     $9125       ; start the IRQ timer A (high byte latch)
        ldy     #10         ; spend some time
-       dey                 ; before starting the reference timer
        bne     -
        stx     $9115       ; start the reference timer

        lda     #<mouseirq  ; set the raster IRQ routine pointer
        sta     $314
        lda     #>mouseirq
        sta     $315
        lda     #$c0
        sta     $912e       ; enable Timer A underflow interrupts
        lda     #$ff
        jmp     mousestart2

spritegfx:
        !byte 0,0,0,0,0,0,0,0
        !byte %10000000
        !byte %11000000
        !byte %10100000
        !byte %10010000
        !byte %10001000
        !byte %10100100
        !byte %10110010
        !byte %10101001
        !byte %10100100
        !byte %10101001
        !byte %10110010
        !byte %10000010
        !byte %10010001
        !byte %10101001
        !byte %11001010
        !byte %00000100
        !byte 0,0,0,0,0,0,0,0
        !byte %00000000
        !byte %00000000
        !byte %00000000
        !byte %00000000
        !byte %00000000
        !byte %00000000
        !byte %00000000
        !byte %00000000
        !byte %10000000
        !byte %00000000
        !byte %00000000
        !byte %00000000
        !byte %00000000
        !byte %00000000
        !byte %00000000
        !byte %00000000
        !byte 0,0,0,0,0,0,0,0

;-------------------------------------------------------------------------------

irqno   !byte 0
irqmps  !byte 0

mouseirq:

!if (DEBUG = 1) {
        inc     $900f
}
        ;estimate irqno (corresponds to screenline number+4)
        lda     $9004       ; rasterline/2
        lsr                 ;/4
        lsr                 ;/8
        sta     irqno

        cmp     #13         ; can put mousepointer bytes onto screen until this line
        bcs     irqsync
        lda     irqmps
        cmp     #0
        bne     irqsync
        inc     irqmps      ; set marker that mousepointer bytes have been set

        jsr     mousesetpointer

irqsync:
        ldy     irqno
        cpy     #60         ; pointer can trigger up to irq21, so prevent conflict.
        bne     irqreset    ; irq/screen update (mouse+kernal takes up to 3 periods)

!if (DEBUG = 1) {
        dec     $900f
}
        jmp     $eb15
        ;-----------------------------------------------------------------------

irqreset:
        sty     irqno       ; irqno=character line number
ycomp:  cpy     #13         ; sync this with rasterline below
        beq     screensync

!if (DEBUG = 1) {
        dec     $900f
}
        jmp     $eb15
        ;-----------------------------------------------------------------------

screensync:
        sty lastirq

        ldx     #24         ; number of screen lines needed for cursor (8 or 16..)
        stx     scrlcnt
        lda     $9005
        sta     scresto+3
        ora     #$08
        sta     scresto+1
ycora:  ldx     #29+52      ; wait for this raster line (times 2) until we start first irq look.
scresync:
        cpx     $9004
        bne     scresync
        ldy     #9
        bit     $24
scresync2:
        ldx     $9004
        txa
        bit     $24
!if (NTSCTIMING = 0) {
        ldx     #24
} else {
        bit     $24
        ldx     #21
}
-       dex
        bne     -           ; first spend some time (so that the whole
        cmp     $9004       ; loop will be 2 raster lines)
        bcs     +           ; save one cycle if $9004 changed too late
+       dey
        bne     scresync2

        ldx     #27         ; 24=start at 0 column. Add 1 for each double
scresync3:
-       dex
        bne     -
        clc
        clc

scxcol: bcc     *+22
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop

scresto:
        lda     #00
        ldx     #$08
scrbyte:
        sta     $9005
        nop
        stx     $9005
        ldy     #9
-       dey
        bne     -

        bit     $24         ;bit $24 or dey depending on pagecrossing
        bit     $24
        dec     scrlcnt
        bne     scrbyte

        jmp     mousestart  ; sprite displayed, so go and remove screen bytes + adjust gfx

scrlcnt: !byte 0
lastirq: !byte 0

mousestart:                 ; Routine to read NEOS mouse data

        LDA     #0
mousestart2:
        STA     irqmps      ;Reset mousepointer marker

        lda     #'.'
        sta     screenmem+20

        ; get the mouse button
        LDA     $9008       ; Paddle POTX
        BPL     nobutton

        lda     #'*'
        sta     screenmem+20

; ??? - this seems very wrong
;         LDA     $9111
;         AND     #32         ;=#32 for NEOS or #16 in VICE
;         CMP     #0
;         BNE     nobutton

;         LDA     $CE         ; get character under cursor
;         LDX     $0287       ; get colour under cursor
;         LDY     #$00        ; clear Y
;         STY     $CF         ; clear cursor blink phase
;         JSR     $EAA1       ; Write character A
;         LDY     lastx
;         LDX     lasty
;         JSR     $E50C       ; Set new cursor positions

nobutton:

        LDA     $9111           ; VIA1 PA
        PHA
        LDA     $9113           ; VIA1 DDR PA
        PHA

        LDA     #0
        STA     $3
        STA     $4
        STA     $0

        LDA     $9113           ; VIA1 DDR PA
        AND     #%11000000      ; Bit 5 output
        ORA     #%00100000      ; Bit 5 output
        STA     $9113           ; Set direction
        LDX     #8

mouseloop:

        LDA     $9111           ; VIA1 PA
        AND     #%11011111      ; Clear bit 5
        STA     $9111           ; Trigger NEOS mouse
        JSR     waitsome

        LDX     #$7F
        STX     $9122           ; Set VIA2 to listen for joystickport
!if (ignorejoy3 = 1) {
        LDA     #0
} else {
        LDA     $9120
        AND     #$80            ; S3
        LDX     #$FF
        STX     $9122           ; Set VIA2 to listen for keyboard again
}
        STA     $3
        LDA     $9111           ; VIA1 PA
        AND     #%00011100      ; S2, S1, S0
        ASL
        ASL
        ORA     $3              ; Add bit 7
        STA     $3

!if (ignorejoy3 = 1) {
        LDX     #$FF
        STX     $9122           ; Set VIA2 to listen for keyboard again
}
        LDA     $9111
        ORA     #%00100000      ; set bit 5
        STA     $9111           ; Trigger NEOS mouse
        LDX     #8
        JSR     waitsome

        LDX     #$7F
        STX     $9122           ; Set VIA2 to listen for joystickport
!if (ignorejoy3 = 1) {
        LDA     #0
} else {
        LDA     $9120
        AND     #$80            ; S3
}
        LDX     #$FF
        STX     $9122           ; Set VIA2 to listen for keyboard again
        LSR
        LSR
        LSR
        LSR
        ORA     $3
        STA     $3
        LDA     $9111           ; VIA1 PA
        AND     #%00011100      ; S2, S1, S0
        LSR
        LSR
        ORA     $3              ; Add other bits
!if (ignorejoy3 = 0) {
        STA     $3
} else {
; set negative bit without joy3 signal:
        asl
        clc
        bpl     +
        sec                ;compensate for missing bit7
        ora     #%00010000 ;compensate for missing bit3
+       ror
        sta     $3

        LDX     #$FF
        STX     $9122   ; Set VIA2 to listen for keyboard again
}
        LDX     $0
        CPX     #0
        BNE     mousecalc
        INC     $0
        STA     $4      ;x-value here
        LDX     #5
        JMP     mouseloop

mousecalc:                  ; use delta values to calculate new postitions
        PLA
        STA     $9113
        PLA
        STA     $9111

        sec
        lda     xval        ;low byte
        sbc     $4          ;add delta x (signed)
        sta     xval

        sec
        lda     yval        ;low byte
        sbc     $3          ;add delta x (signed)
        sta     yval

mouseprint:                 ;Routine to put mouse x&y on screen

!if (showvalues = 1) {
        LDA     xval
        STA     sval
        LDA     #0
        STA     star
        LDA     #24     ;"X"
        JSR     showvalue
        LDA     yval
        STA     sval
        LDA     #6
        STA     star
        LDA     #25     ;"Y"
        JSR     showvalue
}

checkmouse:                 ;Check mouse boundaries (coordinates)
        LDA     xval
        CMP     #210        ;>210 (e.g. less than zero)?
        BCC     +           ; no, ok
        LDA     #0          ; else keep at 0
+
        CMP     #167        ;<167?
        BCC     *+4         ; yes, ok
        LDA     #167
        STA     xval
        LSR
        LSR
        LSR                 ;/8
        CMP     #20         ;<=20?
        BCC     *+4         ; yes, ok
        LDA     #20         ; no, keep at 20
        STA     xval8

        LDA     yval
        CMP     #210        ;>210 (e.g. less than zero)?
        BCC     *+4         ; no, ok
        LDA     #0          ; else keep at 0

        CMP     #168        ;<168?
        BCC     *+4         ; yes, ok
        LDA     #168
        STA     yval
        LSR
        LSR
        LSR                 ;/8
        CMP     #20         ;<23?
        BCC     *+4         ; yes, ok
        LDA     #20
        STA     yval8

        ; store next location trigger for gfx character showing
        lda     yval8       ; line number to "display"
        tay
        clc
        adc     #4
        sta     ycomp+1
        tya
        asl
        asl
        clc
        adc     #28
        sta     ycora+1

        lda     xval8
        sta     $3
        lda     #20
        sec
        sbc     $3
        sta     scxcol+1


        ; always restore screen bytes so that input routine doesn't read mouse char bytes
showmousebytes:  ; new location, so restore screen bytes
        LDY     lasty
        CPY     #-1
        BNE     shmbc
        JMP     nombytesrestore ; First time, nothing to restore
shmbc:
; If some screen scrolling was done, then we need to put x,y,zbyte were appropriate
; First check scrollup (e.g. byte shifts )
smc0x:  LDX     #0        
smc0:   LDA     screenmem+0,X ; This should be $76 if no scroll
        CMP     #$77
        BNE     shnosc1
        ;scrolled one line up
        DEY
shnosc1:
        CMP     #$78
        BNE     shnosc2
        ;scrolled two lines up
        DEY
        DEY
shnosc2:
        TYA
        JSR     mult11      ;(23*11<255)
        ASL                 ;*2 and set carry
        TAX                 ;=lasty*22
        BCS     *+5
        ADC     lastx       ; So must check that we can add lastx (sets carry if overflow)
        LDA     #(>screenmem)/2
        ROL                 ; Rotate and add carry (=$1E or $1F)

        STA     smb1+2
        STA     smb2+2
        STA     smb3+2
        STA     smb4+2
        STA     smb5+2
        STA     smb6+2
        STA     smb7+2
        STA     smb8+2
        STA     smb9+2
        TXA
        ADC     lastx
        TAX

        ; We do not check for screen scroll or other such movements (but can be added here)

        LDA     xbyte1
smb1:   STA     screenmem+$0,X
        LDA     ybyte1
smb2:   STA     screenmem+$1,X
        LDA     zbyte1
smb3:   STA     screenmem+$2,X

        LDA     xbyte2
smb4:   STA     screenmem+$16,X
        LDA     ybyte2
smb5:   STA     screenmem+$17,X
        LDA     zbyte2
smb6:   STA     screenmem+$18,X

        LDA     xbyte3
smb7:   STA     screenmem+$2C,X
        LDA     ybyte3
smb8:   STA     screenmem+$2D,X
        LDA     zbyte3
smb9:   STA     screenmem+$2E,X

nombytesrestore:         ; bytes have been restored

showmouse:    ; Bytes $76-$7e to be placed on screen, so put gfx there

        LDA     yval8
        ASL
        ASL
        ASL
        STA     $5
        LDA     yval
        SEC
        SBC     $5
        STA     $5
        LDA     #$20
        SEC
        SBC     $5
        TAX
        LDY     #$18
sml1:   DEX
        DEY
        LDA     $334,X ; spritegfx
        STA     $3B0,Y ; zero
        LDA     $34C,X ; spritegfx
        STA     $3C8,Y ; zero
        LDA     #0
        STA     $3E0,Y ; zero
        TYA
        BNE     sml1

        LDA     xval8
        ASL
        ASL
        ASL
        STA     $5
        LDA     xval
        SEC
        SBC     $5
        STA     $5
        LDX     #$18
sml2:   DEX
        LDY     $5
        CPY     #0
        BEQ     sml4    ; in case of no rotation

sml3:   DEY

; $76 $79 $7c
; $77 $7a $7d
; $78 $7b $7e

        LSR     $3b0,X      ; rotate column 1 ($76-$78)
        ROR     $3c8,X      ; rotate column 2 ($79-$7b)
        ROR     $3e0,X      ; rotate column 3 ($7c-$7e)
sml4:
        TYA
        BNE     sml3
        TXA
        BNE     sml2

mouseirqend:
!if (DEBUG = 1) {
        dec     $900f
}

        lda     #$ff
        cmp     irqmps
        beq     firstend

        JMP     $eabf       ; return to normal IRQ
firstend:
        inc irqmps
        JSR     $E45B       ; initialise BASIC vector table
        ;JSR     $E3A4       ; initialise BASIC RAM locations
        JSR     $E404       ; print start up message and initialise memory pointers
        LDX     #$FB        ; value for start stack
        TXS                 ; set stack pointer
        ;RTS
        
!if (showvalues = 1) {
        ldx     #21
-
        lda     #$20
        sta     screenmem,x
        lda     #0
        sta     colormem,x
        dex
        bpl     -
}

        JMP     $C474


mousesetpointer:
        ; puts the 3x3 matrix of bytes on screen (CHAR $77-$7e)
        ; to show a 16x16 pixel sprite within the 24x24 pixel "map"
        ; store new bytes

        LDA     xval8
        STA     lastx
        LDA     yval8
        STA     lasty
        JSR     mult11      ; (23*11<255)
        ASL                 ;*2 & set carry
        TAX                 ;=yval8*22
        BCS     *+5         ; If carry set, don't clear it
        ADC     xval8       ; So must check that we can add lastx (sets carry if)
        LDA     #(>screenmem)/2
        ROL                 ; Rotate and add carry (=$1E or $1F)
        STA     smc0+2
        STA     smc1+2
        STA     smc2+2
        STA     smc3+2
        STA     smc4+2
        STA     smc5+2
        STA     smc6+2
        STA     smc7+2
        STA     smc8+2
        STA     smc9+2
        STA     smd1+2
        STA     smd2+2
        STA     smd3+2
        STA     smd4+2
        STA     smd5+2
        STA     smd6+2
        STA     smd7+2
        STA     smd8+2
        STA     smd9+2
        CLC
        ADC     #>(colormem-screenmem)
        STA     sme1+2
        STA     sme2+2
        STA     sme3+2
        STA     sme4+2
        STA     sme5+2
        STA     sme6+2
        STA     sme7+2
        STA     sme8+2
        STA     sme9+2
        TXA
        ADC     xval8
        STA     newx
        TAX
        ; remember bytes under mouse pointer
        STX     smc0x+1
smc1:   LDA     screenmem+$0,X
        STA     xbyte1
smc2:   LDA     screenmem+$1,X
        STA     ybyte1
smc3:   LDA     screenmem+$2,X
        STA     zbyte1
smc4:   LDA     screenmem+$16,X
        STA     xbyte2
smc5:   LDA     screenmem+$17,X
        STA     ybyte2
smc6:   LDA     screenmem+$18,X
        STA     zbyte2
smc7:   LDA     screenmem+$2C,X
        STA     xbyte3
smc8:   LDA     screenmem+$2D,X
        STA     ybyte3
smc9:   LDA     screenmem+$2E,X
        STA     zbyte3

        ; first read the bytes that are to be onscreen and put their gfx into a buffer
        LDA     #0
        STA     $5
        LDA     xbyte1
        ASL
        ROL     $5
        ASL
        ROL     $5
        ASL
        ROL     $5
        STA     smpt1+1
        LDA     #$80
        CLC
        ADC     $5
        STA     smpt1+2

        LDA     #0
        STA     $5
        LDA     xbyte2
        ASL
        ROL     $5
        ASL
        ROL     $5
        ASL
        ROL     $5
        STA     smpt2+1
        LDA     #$80
        CLC
        ADC     $5
        STA     smpt2+2

        LDA     #0
        STA     $5
        LDA     xbyte3
        ASL
        ROL     $5
        ASL
        ROL     $5
        ASL
        ROL     $5
        STA     smpt3+1
        LDA     #$80
        CLC
        ADC     $5
        STA     smpt3+2

        LDA     #0
        STA     $5
        LDA     ybyte1
        ASL
        ROL     $5
        ASL
        ROL     $5
        ASL
        ROL     $5
        STA     smpt4+1
        LDA     #$80
        CLC
        ADC     $5
        STA     smpt4+2

        LDA     #0
        STA     $5
        LDA     ybyte2
        ASL
        ROL     $5
        ASL
        ROL     $5
        ASL
        ROL     $5
        STA     smpt5+1
        LDA     #$80
        CLC
        ADC     $5
        STA     smpt5+2

        LDA     #0
        STA     $5
        LDA     ybyte3
        ASL
        ROL     $5
        ASL
        ROL     $5
        ASL
        ROL     $5
        STA     smpt6+1
        LDA     #$80
        CLC
        ADC     $5
        STA     smpt6+2

        LDA     #0
        STA     $5
        LDA     zbyte1
        ASL
        ROL     $5
        ASL
        ROL     $5
        ASL
        ROL     $5
        STA     smpt7+1
        LDA     #$80
        CLC
        ADC     $5
        STA     smpt7+2

        LDA     #0
        STA     $5
        LDA     zbyte2
        ASL
        ROL     $5
        ASL
        ROL     $5
        ASL
        ROL     $5
        STA     smpt8+1
        LDA     #$80
        CLC
        ADC     $5
        STA     smpt8+2

        LDA     #0
        STA     $5
        LDA     zbyte3
        ASL
        ROL     $5
        ASL
        ROL     $5
        ASL
        ROL     $5
        STA     smpt9+1
        LDA     #$80
        CLC
        ADC     $5
        STA     smpt9+2

        LDX     #8
smptlo:
        DEX
smpt1:  LDA     $8000,X
        ORA     $3b0,X
        STA     $3b0,X
smpt2:  LDA     $8000,X
        ORA     $3b8,X
        STA     $3b8,X
smpt3:  LDA     $8000,X
        ORA     $3c0,X
        STA     $3c0,X
smpt4:  LDA     $8000,X
        ORA     $3c8,X
        STA     $3c8,X
smpt5:  LDA     $8000,X
        ORA     $3d0,X
        STA     $3d0,X
smpt6:  LDA     $8000,X
        ORA     $3d8,X
        STA     $3d8,X
smpt7:  LDA     $8000,X
        ORA     $3e0,X
        STA     $3e0,X
smpt8:  LDA     $8000,X
        ORA     $3e8,X
        STA     $3e8,X
smpt9:  LDA     $8000,X
        ORA     $3f8,X
        STA     $3f0,X
        TXA
        BNE     smptlo

        LDX     newx

        LDA     #$76
smd1:   STA     screenmem+$0,X
        LDA     #$79
smd2:   STA     screenmem+$1,X
        LDA     #$77
smd4:   STA     screenmem+$16,X
        LDA     #$7a
smd5:   STA     screenmem+$17,X
        LDA     #$78
smd7:   STA     screenmem+$2C,X
        LDA     #$7b
smd8:   STA     screenmem+$2D,X
        LDY     xval8
        CPY     #20
        BEQ     nocharc3
        LDA     #$7c
smd3:   STA     screenmem+$02,X
        LDA     #$7d
smd6:   STA     screenmem+$18,X
        LDA     #$7e
smd9:   STA     screenmem+$2E,X
        LDA     #6
sme3:   STA     colormem+$02,X
sme6:   STA     colormem+$18,X
sme9:   STA     colormem+$2E,X

nocharc3:
; $76 $79 $7c
; $77 $7a $7d
; $78 $7b $7e

        LDA     #6
sme1:   STA     colormem+$00,X
sme2:   STA     colormem+$01,X
sme4:   STA     colormem+$16,X
sme5:   STA     colormem+$17,X
sme7:   STA     colormem+$2C,X
sme8:   STA     colormem+$2D,X

        rts

newx:    !byte 0
xval:    !byte 0
yval:    !byte 0
xval8:   !byte 0
yval8:   !byte 0
lastx:   !byte -1
lasty:   !byte -1
xbyte1:  !byte 0
xbyte2:  !byte 0
xbyte3:  !byte 0
ybyte1:  !byte 0
ybyte2:  !byte 0
ybyte3:  !byte 0
zbyte1:  !byte 0
zbyte2:  !byte 0
zbyte3:  !byte 0

waitsome:
        NOP
        NOP
        NOP
        DEX
        BNE     waitsome
        RTS

;-------------------------------------------------------------------------------

!if (showvalues = 1) {
showvalue:               ; shows an integer value
       LDX     star
       STA     screenmem+$0,X
       LDA     #"="
       STA     screenmem+$1,X

       LDA     sval
       JSR     div10
       TAY
       JSR     div10
       TAX
       JSR     mult10
       STA     $6
       TYA
       SEC
       SBC     $6      ; tenths
       CLC
       ADC     #48
       STA     $0      ;temp storage
       TXA
       ADC     #48
       LDX     star
       STA     screenmem+$2,X   ; hundreds
       LDA     $0
       STA     screenmem+$3,X   ; hundreds
       TYA     
       JSR     mult10
       STA     $6
       LDA     sval
       SEC
       SBC     $6
       CLC
       ADC     #48
       LDX     star
       STA     screenmem+$4,X   ; 0-9
       LDA     #2
       STA     colormem+$0,X
       STA     colormem+$1,X
       STA     colormem+$2,X
       STA     colormem+$3,X
       STA     colormem+$4,X
       RTS

sval:    !byte 0
star:    !byte 0

div10:
       lsr
       sta      $5  ;1/2
       lsr
       adc      $5  ;1/4+1/2=3/4
       ror
       lsr
       lsr
       adc      $5  ;3/32+16/32=19/32
       ror
       adc      $5  ;19/64+32/64=51/64
       ror
       lsr
       lsr          ;51/512
       rts

mult10:  ; 2+8
       asl
       sta      $5
       asl
       asl
       clc
       adc      $5
       rts
}
;-------------------------------------------------------------------------------

mult11:  ; (1+2+8)
        sta     $5
        asl
        asl
        asl             ;*8
        clc
        adc     $5      ;+1
        asl     $5
        clc
        adc     $5      ;+2
        rts
