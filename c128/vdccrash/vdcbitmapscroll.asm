

HLWord .union
    .word ?
.struct
    lo .byte ?
    hi .byte ?
.ends
.endu

        *= $02
ZPPointer1  .dunion HLWORD
ZPPointer2  .dunion HLWORD
ZPPointer3  .dunion HLWORD
ZPPointer4  .dunion HLWORD
ZPPointer5  .dunion HLWORD
ZPPointer6  .dunion HLWORD
ZPPointer7  .dunion HLWORD
ZPPointer8  .dunion HLWORD
ZPPointer9  .dunion HLWORD
ZPTemp1     .byte ?
ZPTemp2     .byte ?
ZPTemp3     .byte ?
ZPTemp4     .byte ?

        *= $1c01
        .word (+), 10
        .null $9e, "7181"
+       .word 0

        *= 7181

        sei
        lda #$7f
        sta $dc0d		 ;turn off all types of cia irq/nmi.
        sta $dd0d
        lda $dc0d
        lda $dd0d
        lda #$ff
        sta $D019
        lda #$00
        sta $D01a
        sta $dc0e
        sta $dc0f
        sta $dd0e
        sta $dd0f
        lda $d01e
        lda $d01f
        
        LDX #$00
        JSR INIT80VDCRegs            ;$E1DC Set Up CRTC Registers
        
        LDA $D600
        AND #$07
        BEQ bE18A
        LDX #$3B
        JSR INIT80VDCRegs            ;$E1DC Set Up CRTC Registers
bE18A

        ; we need to loook at the map, and build a 640 byte buffer in VDC format

        lda #<buffer
        sta ZPPointer1
        lda #>map
        sta ZPPointer2+1
        lda #<map
        sta ZPPointer2
        lda #>buffer
        sta ZPPointer1+1

        ldy #0
        sty ZPTemp1
-
        ldy ZPTemp1
        lda (ZPPointer2),y
        ; this is the map tile
        asl a
        asl a ; x4 to get the char
        asl a
        asl a
        asl a ; x8 to get the ram location This will need to go to 16 bit at some point
        clc
        adc #<bitmapTiles
        sta ZPPointer3.lo
        lda #>bitmapTiles
        adc #0
        sta ZPPointer3.hi
        jsr plotCharToBuffer
        clc
        lda ZPPointer3
        adc #8
        sta ZPPointer3
        bcc +
        inc (ZPPointer3)+1
+
        clc
        lda ZPPointer1
        adc #1
        sta ZPPointer1
        bcc +
        inc (ZPPointer1)+1
+
        jsr plotCharToBuffer
        clc
        lda ZPPointer3
        adc #8
        sta ZPPointer3
        bcc +
        inc (ZPPointer3)+1
+
        lda ZPPointer1
        clc
        adc #<(320-1)
        sta ZPPointer1
        lda ZPPointer1+1
        adc #>(320-1)
        sta ZPPointer1+1
        jsr plotCharToBuffer
        clc
        lda ZPPointer3
        adc #8
        sta ZPPointer3
        bcc +
        inc (ZPPointer3)+1
+
        clc
        lda ZPPointer1
        adc #1
        sta ZPPointer1
        bcc +
        inc (ZPPointer1)+1
+
        jsr plotCharToBuffer
        lda ZPPointer1
        sec
        sbc #<(320-1)
        sta ZPPointer1
        lda (ZPPointer1)+1
        sbc #>(320-1)
        sta (ZPPointer1)+1
        inc ZPTemp1
        lda ZPTemp1
        cmp #40
        bne -

;set up 40 col bitmap
        ldx #0
        lda #63
        jsr writeVDCReg
        ldx #1
.if CRASH = 1
        lda #80; 40
.else
        lda #40
.endif
        jsr writeVDCReg
        ldx #2
        lda #55
        jsr writeVDCReg
        ldx #3
        lda #69
        jsr writeVDCReg
        ldx #22
        lda #$89
        jsr writeVDCReg
        ldx #25
        lda #215 ; enable bitmap
        jsr writeVDCReg
        ldx #27
        lda #80-8 ;40
        jsr writeVDCReg
        ldx #34
        lda #63
        jsr writeVDCReg
        ldx #35
        lda #52
        jsr writeVDCReg
        ldx #20
        lda #>40 ; $2000
        jsr writeVDCReg
        ldx #21
        lda #<40 ;$2000
        jsr writeVDCReg ; set the attribute memory to $2000
        ldx #12
        lda #00
        jsr writeVDCReg
        ldx #13
        lda #00
        jsr writeVDCReg ; set bitmap to 0
        
        ; now we need to copy the char data into VDC memory
        lda #>0
        sta ZPPointer2+1
        lda #<0
        sta ZPPointer2
        lda #<buffer
        sta ZPPointer1
        lda #15
        sta ZPTemp2
        lda #>buffer
        sta ZPPointer1+1
        
_copyRow
        lda #39
        sta ZPTemp1
        ldx #18
        lda ZPPointer2.hi
        jsr writeVDCReg
        ldx #19
        lda ZPPointer2.lo
        jsr writeVDCReg ; set current pointer to $0000
        ldy #0
        sty ZPTemp3
_copyBuffer
_BREAK3
        ldy ZPTemp3
        lda (ZPPointer1),y
        ldx #31
        jsr writeVDCReg
        inc ZPTemp3
        dec ZPTemp1
        bpl _copyBuffer
        clc
        lda ZPPointer1
        adc #40
        sta ZPPointer1
        bcc +
        inc (ZPPointer1)+1
+
        clc
        lda ZPPointer2
        adc #80
        sta ZPPointer2
        bcc +
        inc (ZPPointer2)+1
+
        dec ZPTemp2
        bpl _copyRow
        ; give me some visiable attributes
        ldx #24
        lda #00
        jsr writeVDCReg ; set fill
        lda #24
        sta ZPTemp1
        lda #>40
        sta ZPPointer1+1
        lda #<40
        sta ZPPointer1
        ldx #31
        lda #$ce ; black and white
        jsr writeVDCReg ; set fill
_attributes
        ldx #18
        lda ZPPointer1.hi
        jsr writeVDCReg
        ldx #19
        lda ZPPointer1.lo
        jsr writeVDCReg
        ldx #30
        lda #39
        jsr writeVDCReg ; do 40 writes
        clc
        lda ZPPointer1
        adc #80
        sta ZPPointer1
        bcc +
        inc (ZPPointer1)+1
+
        dec ZPTemp1
        bpl _attributes
-  
        jmp -


plotCharToBuffer
        lda ZPPointer1.lo
        sta ZPPointer4.lo
        lda ZPPointer1.hi
        sta ZPPointer4.hi
        lda #0
        sta ZPTemp2
-
        ldy ZPTemp2
        lda (ZPPointer3),y ; get byte
        ldy #0
        sta (ZPPointer4),y ; store it
        clc
        lda ZPPointer4
        adc #40
        sta ZPPointer4
        bcc +
        inc (ZPPointer4)+1
+
        inc ZPTemp2
        lda ZPTemp2
        cmp #8
        bne -
        rts

writeVDCReg
        stx $d600
-	
        ldx $d600
        bpl -
        sta $d601
        rts

INIT80VDCRegs           
        LDY VDCDEFTBL,X
        BMI bE1EE
        INX
        LDA VDCDEFTBL,X
        INX
        STY $D600
        STA $D601
        BPL INIT80VDCRegs
bE1EE                   
        INX
        RTS


VDCDEFTBL               
        .BYTE $00,$7E
        .BYTE $01,$50
        .BYTE $02,$66
        .BYTE $03,$49
        .BYTE $04,$20
        .BYTE $05,$00
        .BYTE $06,$19
        .BYTE $07,$1D
        .BYTE $08,$00
        .BYTE $09,$07
        .BYTE $0A,$20
        .BYTE $0B,$07
        .BYTE $0C,$00
        .BYTE $0D,$00
        .BYTE $0E,$00
        .BYTE $0F,$00
        .BYTE $14,$08
        .BYTE $15,$00
        .BYTE $17,$08
        .BYTE $18,$20
        .BYTE $19,$40,$1A,$F0,$1B,$00,$1C,$20
        .BYTE $1D,$07,$22,$7D,$23,$64,$24
pE32F                   
        .BYTE $05,$16,$78,$FF,$19,$47,$FF,$04
        .BYTE $26,$07,$20,$FF

; .binary "chars.bin"
bitmapTiles
.byte $01, $03, $07, $0e, $07, $0e, $1d, $3a
.byte $80, $c0, $20, $90, $20, $10, $08, $8c, $0d, $1a, $35, $77, $39, $01, $01, $01
.byte $10, $88, $44, $e6, $9c, $80, $80, $80, $10, $10, $10, $18, $09, $09, $09, $0d
.byte $86, $84, $8c, $c8, $98, $10, $18, $8c, $0c, $18, $10, $19, $19, $10, $18, $08
.byte $84, $8c, $98, $98, $8c, $84, $86, $82, $00, $00, $01, $02, $07, $06, $0d, $3a
.byte $00, $00, $00, $80, $80, $40, $40, $a0, $7d, $6e, $d3, $e2, $d1, $e9, $00, $00
.byte $50, $88, $46, $a0, $54, $aa, $00, $00, $00, $20, $50, $20, $00, $00, $00, $10
.byte $00, $00, $00, $10, $28, $10, $00, $00, $28, $10, $00, $00, $08, $14, $08, $00
.byte $00, $40, $a0, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00

; .binary "map.bin"
map
.byte $02, $02, $02, $02, $02, $02, $02, $02
.byte $02, $02, $01, $02, $02, $02, $02, $02, $00, $00, $02, $02, $02, $02, $02, $02
.byte $02, $02, $02, $02, $02, $02, $01, $01, $02, $02, $02, $02, $02, $00, $00, $02
.byte $02, $02, $03, $03, $03, $03, $03, $03, $03, $03, $03, $01, $03, $03, $03, $03
.byte $03, $03, $03, $03, $02, $03, $03, $00, $03, $03, $03, $03, $03, $03, $03, $01
.byte $01, $03, $03, $03, $03, $03, $03, $03, $02, $03, $00, $00, $00, $03, $03, $03
.byte $03, $03, $03, $03, $01, $03, $03, $03, $03, $03, $03, $03, $02, $03, $03, $00
.byte $00, $00, $03, $03, $03, $03, $03, $03, $01, $03, $03, $03, $03, $03, $03, $03
.byte $02, $03, $03, $03, $00, $03, $03, $03, $03, $03, $03, $03, $01, $03, $03, $03
.byte $03, $03, $03, $03, $02, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03
.byte $01, $03, $03, $03, $03, $03, $03, $02, $02, $03, $03, $03, $03, $03, $03, $03
.byte $03, $03, $03, $01, $01, $03, $03, $03, $00, $00, $00, $00, $02, $03, $03, $03
.byte $03, $03, $03, $00, $03, $03, $03, $01, $03, $03, $00, $00, $00, $03, $03, $02
.byte $02, $03, $03, $03, $03, $03, $00, $00, $00, $03, $01, $01, $03, $03, $00, $00
.byte $03, $02, $02, $02, $02, $03, $03, $03, $03, $03, $03, $00, $03, $01, $01, $03
.byte $03, $03, $03, $03, $02, $02, $02, $02

buffer: 
        .fill 640*2
