; DASM Macro Assembler V2.20.07-iAN-rev-O (C)1988-2018
		
port = $dc00
ddr = $dc02
dest = $0400
        
        * = $0801
        
        !byte $0B, $08, $0a, $00, $9E
        !byte $32, $30, $36, $31 ; "2061"
        !byte $00, $00, $00

        * = $080d
        
        sei
        lda #<domouse
        sta $314
        lda #>domouse
        sta $315
        cli
        rts
        
DELTA_Y !byte $00
        
domouse lda #%00010000
        sta ddr         ;line 4 in read/write mode, the rest read only
        
        ; clock = 0
        lda #%11101111
        sta port
        
        ; long delay
        ldx #$08
        jsr delay
        
        ; read DELTA_X (skipped)
        ; lda port
        
        ; clock = 1
        lda #%00010000
        sta port
        
        ; short delay
        ldx #$05
        jsr delay
        
        ; read DELTA_X (skipped)
        ; lda     port
        
        ; clock = 0
        lda #%11101111
        sta port
        
        ; short delay
        ldx #$05
        jsr delay
        
        ; read 4 bits from lines 0...3
        ; and shift them into bits 4...7
        ; (DELTA_Y)
        lda port
        asl
        asl
        asl
        asl
        sta DELTA_Y
        
        ; clock = 1
        lda #%00010000
        sta port
        
        ; short delay
        ldx #$05
        jsr delay
        
        ; read 4 bits from lines 0...3
        ; and OR them into bits 0...3
        ; (DELTA_Y)
        lda port
        and #$0F
        ora DELTA_Y
        sta DELTA_Y
        
        ; check right mousebutton through potx
        ; uncomment this to make it work in VICE
        ;lda $D419

        lda #$ff
        sta ddr         ; set all lines to read/write mode

        lda dest
        clc
        adc DELTA_Y
        sta dest

        jmp $ea81


delay   nop
        nop
        nop
        dex
        bne delay
        rts 
