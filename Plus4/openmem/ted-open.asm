
; Test open address space
; Bitmap 1 at $2000 with attributes at $0800 thick black and white vertical lines
; Bitmap 2 at $A000 with attributes as $8000 thin dark and light green vertical lines
; Use C= key to toggle bitmaps
; RUN/STOP to toggle TED reading bitmap from RAM or ROM
; CTRL to toggle ROM/RAM for CPU and TED attributes in $8000-$FFFF
;
; Border colors:
; Black   = Bitmap at $2000 RAM, ROM mapped in for CPU/attributes in $8000-$FFFF
; Grey    = Bitmap at $2000 RAM, RAM mapped in for CPU/attributes in $8000-$FFFF
; Orange  = Bitmap at $2000 ROM (open space), ROM mapped in for CPU/attributes in $8000-$FFFF
; Yellow  = Bitmap at $2000 ROM (open space), RAM mapped in for CPU/attributes in $8000-$FFFF
;
; Pink    = Bitmap at $A000 RAM, ROM mapped in for CPU/attributes in $8000-$FFFF
; Cyan    = Bitmap at $A000 RAM, RAM mapped in for CPU/attributes in $8000-$FFFF
; Green   = Bitmap at $A000 ROM, ROM mapped in for CPU/attributes in $8000-$FFFF
; Purple  = Bitmap at $A000 ROM, RAM mapped in for CPU/attributes in $8000-$FFFF

    !to "ted-open.prg", cbm

    * = $1001

 	!byte $0C, $10, $E4, $07, $9E, $20, $34, $31, $31, $32, $00	; 10 SYS 4112
	!byte $00, $00

	*= $1010   

    SEI
    JSR fill
    LDA #$40
    STA $FF19       ;Border

    LDA #$08
    STA $FF14       ; Attributes at $0800
    LDA #$08
    STA $FF12       ; Bitmap at $2000 in RAM

    LDA #$3B
    STA $FF06       ; Hires Bitmap mode

-   LDX #$7F
    JSR press
    CMP #$7F        ; RUNSTOP
    BNE +

    LDA $FF12
    EOR #$04
    STA $FF12

    LDA $FF19       ; Toggle bitmap from RAM/ROM
    EOR #$08
    STA $FF19

    LDX #$7F
    JSR release
    BEQ -
+   CMP #$DF        ; C= key
    BNE +
    LDA $FF14       ; Toggle bitmap between $2000 & $A000
    EOR #$88
    STA $FF14
    LDA $FF12
    EOR #$20
    STA $FF12

    LDA $FF19
    EOR #$02
    STA $FF19

    LDX #$7F
    JSR release
    BEQ -
+   CMP #$FB        ; CTRL
    BNE -
.c  STA $FF3F       ; Toggle ROM
    LDA .c+1
    EOR #$01
    STA .c+1

    LDA $FF19
    EOR #$01
    STA $FF19

    LDX #$7F
    JSR release
    BEQ -


press
-   STX $FD30
    STX $FF08
    LDA $FF08
    CMP #$FF
    BEQ -
    RTS

release
-   STX $FD30
    STX $FF08
    LDA $FF08
    CMP #$FF
    BNE -
    RTS


irq:
    LDA #$02
    STA $FF09       ; Clear IRQs
	LDA	#%10100010	; Enable raster interrupt signals from TED, and clear MSB in TED's raster register
	STA	$FF0A

    LDA $FB
	PHA
	LDA #$00
	STA $FB
	PHP
	CLI
	JSR $DB11		; Scan keyboard
	PLP
	PLA
	STA $FB
    JMP $FCBE


fill:
; Fill attributes at $0800 and $8000
    LDY #$FF
    LDX #$00
-   LDA #$01
    STA $0C00,X
    STA $0D00,X
    STA $0E00,X
    STA $0F00,X

    STA $8000,X
    STA $8100,X
    STA $8200,X
    STA $8300,X

    TYA
    STA $0800,X
    STA $0900,X
    STA $0A00,X
    STA $0B00,X

    STA $8400,X
    STA $8500,X
    STA $8600,X
    STA $8700,X
    INX
    BNE -

    LDY #$20
--  LDX #$00
-   LDA #%11110000
.a  STA $2000,X
    LDA #%11001100
.b  STA $A000,X
    INX
    BNE -
    DEY
    BEQ +
    INC .a+2
    INC .b+2
    BNE --

+   RTS