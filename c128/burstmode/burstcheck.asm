
; 10 SYS7181
*=$1c01  
	!byte  $0c,$08,$0a,$00,$9e,$37,$31,$38,$31,$00,$00,$00
*=$1c0d 
	jmp start

start:
    lda #8
    jsr $ffb1
    
    lda $0a1c
    sta $0400
!if BURST=0 {
    ; expect burst disabled, fail if burst detected
    bne failed
} else {
    ; expect burst enabled, fail if no burst detected
    beq failed
}
    lda #13
    sta $d020
    lda #$00
    sta $d7ff

    jmp *
    
failed:
    lda #10
    sta $d020
    lda #$ff
    sta $d7ff
    jmp *
