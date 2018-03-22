; Mouse test for 1351-like mouse on Vic-20

; note that this program does not actually work with the original 1351 mouse -
; it requires some sort of adapter/mouse that works the same, but provides the
; correct timing for POTX/POTY (which is different on C64 and VIC20).

; this is a stripped version of the original program, which will work on NTSC

DEBUG = 0

showvalues = 1  ; set to 1 to show mouse coordinates in first line of the screen

!if (expanded=1) {
    basicstart = $1201      ; expanded
    screenmem  = $1000
    colormem   = $9400
    charset    = $1c00
    firstchar  = 0
} else {
    basicstart = $1001      ; unexpanded
    screenmem  = $1e00
    colormem   = $9600
    charset    = $1c00
    firstchar  = 0
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

        ; get POT values
        lda     $9008
        sta     oldx+1
        lda     $9009
        sta     oldy+1

        lda     #0
        sta     $3
        sta     $4

        lda     #$7f
        sta     $912e     ; disable and acknowledge interrupts
        sta     $912d

        lda #$10        
        sta $900f       
                
        ldx #0
-
        lda #$10
        sta colormem,x
        sta colormem+$100,x
        lda #$20
        sta screenmem,x
        sta screenmem+$100,x
        inx
        bne -
                
        lda $9005
        sta restorescrn+1
       

mainlp:
       
!if (NTSCTIMING=1) {
        lda #$10
} else {
        lda #$1d
}
- 
        cmp $9004
        bcs -

        inc $900f       

        jsr     mousesetpointer

        dec $900f       

!if (expanded=1) {
        lda #$cf ;screen: $1000, Char: $1c00
}else {
        lda #$ff ;screen: $1e00, Char: $1c00
}
        sta $9005

!if (NTSCTIMING=1) {
        lda #$10+(13*8)
} else {
        lda #$1d+(13*8)
}
-   
        cmp $9004
        bne -

        inc $900f       

        jsr     mousestart

        dec $900f       

restorescrn:
        lda #0
        sta $9005

        jmp mainlp
        
        

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


mousestart:                 ; Routine to read 1351 mouse data

        lda     #'.'
        sta     screenmem+16
        sta     screenmem+17
        sta     screenmem+19
        sta     screenmem+20
        sta     screenmem+21

        ; get the mouse button
        LDA     $9111       ; Joy UP (RMB)
        and     #$04
        bne     norightbutton

        lda     #'*'
        sta     screenmem+21

norightbutton:

        LDA     $9111       ; Joy DOWN (MMB)
        and     #$08
        bne     nomidbutton

        lda     #'*'
        sta     screenmem+20

nomidbutton:

        LDA     $9111       ; FIRE (LMB)
        AND     #$20
        bne     noleftbutton

        lda     #'*'
        sta     screenmem+19

noleftbutton:

        LDA     $9111       ; Joy LEFT (wheel up)
        and     #$10
        bne     +
        lda     #'*'
        sta     screenmem+16
+
        lda     $9122
        pha

        and     #$7f
        sta     $9122

        LDA     $9120       ; Joy RIGHT (wheel down)
        and     #$80
        bne     +
        lda     #'*'
        sta     screenmem+17
+
        pla
        sta     $9122

        lda     $9008           ; POT X
oldx:   ldy     #0
        jsr     MoveCheck
        sta     $4
        sty     oldx+1

        lda     $9009           ; POT Y
oldy:   ldy     #0
        jsr     MoveCheck
        sta     $3
        sty     oldy+1

        ; use delta values to calculate new postitions

        clc
        lda     xval        ;low byte
        adc     $4          ;add delta x (signed)
        sta     xval

        sec
        lda     yval        ;low byte
        sbc     $3          ;add delta y (signed)
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
        STA     charset+$3B0-$3b0,Y ; zero
        LDA     $34C,X ; spritegfx
        STA     charset+$3C8-$3b0,Y ; zero
        LDA     #0
        STA     charset+$3E0-$3b0,Y ; zero
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

        LSR     charset+$3b0-$3b0,X      ; rotate column 1 ($76-$78)
        ROR     charset+$3c8-$3b0,X      ; rotate column 2 ($79-$7b)
        ROR     charset+$3e0-$3b0,X      ; rotate column 3 ($7c-$7e)
sml4:
        TYA
        BNE     sml3
        TXA
        BNE     sml2

mouseirqend:
        rts


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
        ORA     charset+$3b0-$3b0,X
        STA     charset+$3b0-$3b0,X
smpt2:  LDA     $8000,X
        ORA     charset+$3b8-$3b0,X
        STA     charset+$3b8-$3b0,X
smpt3:  LDA     $8000,X
        ORA     charset+$3c0-$3b0,X
        STA     charset+$3c0-$3b0,X
smpt4:  LDA     $8000,X
        ORA     charset+$3c8-$3b0,X
        STA     charset+$3c8-$3b0,X
smpt5:  LDA     $8000,X
        ORA     charset+$3d0-$3b0,X
        STA     charset+$3d0-$3b0,X
smpt6:  LDA     $8000,X
        ORA     charset+$3d8-$3b0,X
        STA     charset+$3d8-$3b0,X
smpt7:  LDA     $8000,X
        ORA     charset+$3e0-$3b0,X
        STA     charset+$3e0-$3b0,X
smpt8:  LDA     $8000,X
        ORA     charset+$3e8-$3b0,X
        STA     charset+$3e8-$3b0,X
smpt9:  LDA     $8000,X
        ORA     charset+$3f8-$3b0,X
        STA     charset+$3f0-$3b0,X
        TXA
        BNE     smptlo

        LDX     newx

        LDA     #firstchar+$76-$76
smd1:   STA     screenmem+$0,X
        LDA     #firstchar+$79-$76
smd2:   STA     screenmem+$1,X
        LDA     #firstchar+$77-$76
smd4:   STA     screenmem+$16,X
        LDA     #firstchar+$7a-$76
smd5:   STA     screenmem+$17,X
        LDA     #firstchar+$78-$76
smd7:   STA     screenmem+$2C,X
        LDA     #firstchar+$7b-$76
smd8:   STA     screenmem+$2D,X
        LDY     xval8
        CPY     #20
        BEQ     nocharc3
        LDA     #firstchar+$7c-$76
smd3:   STA     screenmem+$02,X
        LDA     #firstchar+$7d-$76
smd6:   STA     screenmem+$18,X
        LDA     #firstchar+$7e-$76
smd9:   STA     screenmem+$2E,X

nocharc3:
; $76 $79 $7c
; $77 $7a $7d
; $78 $7b $7e

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

; --------------------------------------------------------------------------
;
; Move check routine, called for both coordinates.
;
; Entry:        y = old value of pot register
;               a = current value of pot register
; Exit:         y = value to use for old value
;               x/a = delta value for position
;

MoveCheck:
        sty     OldValue
        sta     NewValue
        ldx     #$00

        sec
        sbc     OldValue                ; a = mod64 (new - old)
        and     #%01111111
        cmp     #%01000000              ; if (a > 0)
        bcs     .L1                     ;
        lsr                             ;   a /= 2;
        beq     .L2                     ;   if (a != 0)
        ldy     NewValue                ;     y = NewValue
        sec
        rts                             ;   return

.L1:    ora     #%11000000              ; else, "or" in high-order bits
        cmp     #$FF                    ; if (a != -1)
        beq     .L2
        sec
        ror                             ;   a /= 2
        dex                             ;   high byte = -1 (X = $FF)
        ldy     NewValue
        sec
        rts

.L2:    txa                             ; A = $00
        clc
        rts
      
OldValue:
        !byte 0
NewValue:
        !byte 0
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
       RTS

sval:    !byte 0
star:    !byte 0

;-------------------------------------------------------------------------------

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
