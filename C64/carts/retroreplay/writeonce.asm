
; If not in Flash mode, bits 1, 2 and 6 of $de01 can only be written once. 
; Bit 1: AllowBank  (1 allows banking of RAM in $df00/$de02 area)
; Bit 2: NoFreeze   (1 disables Freeze function)
; Bit 6: REU compatibility bit. 0=standard memory map (ROM/RAM in IO2) 
;                               1=REU compatible memory map (ROM/RAM in IO1)
;                  

            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0

;-------------------------------------------------------------------------------

    * = $080d

    sei
    
    ldx #0
    stx $d020
    stx $d021
-
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
    bne -

    ; read first register value
    ldx $de01   
    
    txa
    sta $0400
    
    txa
    and #%00000010   ; allow bank
    sta $0400+1
    
    txa    
    and #%01000000   ; REU mapping
    sta $0400+2

    ; write changed value
    txa
    eor #%11011010   ; invert both bits, and banking bit 15,14,13
    sta $de01
    
    ; read back register
    ldx $de01   
    
    txa
    sta $0400+40
    
    txa
    and #%00000010   ; allow bank
    sta $0400+41
    
    txa    
    and #%01000000   ; REU mapping
    sta $0400+42
    
    ; write changed value
    txa
    eor #%11011010   ; invert both bits, and banking bit 15,14,13
    sta $de01
    
    ; read back
    ldx $de01   
    
    txa
    sta $0400+80
    
    txa
    and #%00000010   ; allow bank
    sta $0400+81
    
    txa    
    and #%01000000   ; REU mapping
    sta $0400+82
    
    ; compare first and second value. when these are the same, the register bits
    ; were already "locked" by the cartridge ROM
    ldx #'L'-$40
    lda $0400+1
    cmp $0400+41
    beq +
    ldx #'C'-$40
+    
    stx $0400+44

    ldx #'L'-$40
    lda $0400+2
    cmp $0400+42
    beq +
    ldx #'C'-$40
+    
    stx $0400+45
    
    ; compare second and third value. those must always be the same
    
    ldx #'L'-$40
    lda $0400+41
    cmp $0400+81
    beq +
    ldx #'C'-$40
+    
    stx $0400+84

    ldx #'L'-$40
    lda $0400+42
    cmp $0400+82
    beq +
    ldx #'C'-$40
+    
    stx $0400+85
    
    ; the first comparison kann be C or L, but both must be the same
    ldx #13 ; pass
    lda $0400+44
    cmp $0400+45
    beq +
    ldx #10
    inc fail
+
    stx $d800+44
    stx $d800+45
    
    ; the second comparison must be L, and both must be the same
    ldx #13 ; pass
    lda $0400+84
    cmp #'L'-$40
    beq +
    ldx #10
    inc fail
+
    stx $d800+84

    ldx #13 ; pass
    lda $0400+84
    cmp $0400+85
    beq +
    ldx #10
    inc fail
+
    stx $d800+85
    
    ldx #13
    ldy #$00
fail=*+1
    lda #0
    beq +
    ldx #10
    ldy #$ff
+
    stx $d020
    sty $d7ff
    
    jmp *
