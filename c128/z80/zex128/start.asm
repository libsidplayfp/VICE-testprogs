	.word *+2 ;start address

crc	= $fa
z80go	= $500

basicstart
        .word basicend ; link to next line
	.word 10 ; line number
	.byte $9e ; sys token
; generate sys value
	.byte start/1000+$30
	.byte start/100-(start/1000)*10+$30
	.byte start/10-(start/100)*10+$30
	.byte start-(start/10)*10+$30
	.byte 0 ;end of line
basicend
	.word 0

; this is an entry point for the previous tests loader

error
	bcc start
	jsr $ff7d
	.byte "load error"
	.byte 0
	jmp *
	
; entry point from basic

start

; print out the tester decription which is encoded in the Z80 code

	ldy #0
loop
	lda fname,y
	cmp #'$'
	beq loop0
	cmp #$40	; compensate for ASCII characters
	bcc print
	eor #$20
print
	jsr $ffd2
	iny
	bne loop
loop0
	cpy #40		; fill reset of the 40 chars with spaces
	bcs loop1
	lda #" "
	jsr $ffd2
	iny
	bne loop0

; Prepare for tests

loop1
	lda #$0b	; turn off VIC
	sta $d011
	ldy #$00	; set 1 MHz mode
	sty $d030
	sty $dc0e	; disable timers
	sty $dc0f
	sty $d01a	; disable VIC IRQs
	sty $ffef	; set lower Z80 entry point
	sty $fc		; set lower copy vector
	lda #$7f	; disable timers
	sta $dc0d
	lda #$ff	; clear any pending VIC IRQs
	sta $d019
	sei 
	lda #$3e	; Switch to RAM0
	sta $ff00

; copy z80 code to 500 in bank 1
; ZEX needs its "machine state before test" to be at $103 for the CRCs to
;  match. Since the 128 Z80 maps ROM at $0-$fff in bank 0, we have to put
;  the code in bank 1. Page 0 and Page 1 will still be mapped to bank 0.

	lda #$fc	; use the kernal's copy function
	sta $2b9
	lda #<z80start	; destination
	sta $fa
	lda #>z80start
	sta $fb
	lda #>z80go	; high page of source
	sta $fd
	sta $fff0	; set the Z80 jump location too
copy
	ldx #$7e	; set the Z80 MMU config
	stx $ffd2
	lda ($fa),y	; read and copy data
	jsr $2af
	iny
	bne copy
	lda $fb		; copy at least one page more of data
	cmp $af
	beq copy0
	inc $fb
	inc $fd
	bne copy

copy0
	lda #8		; set the MMU so the 1K of top and bottom is shared
	sta $d506
	lda #<return	; set the return address from the Z80
	sta $ffdd
	lda #>return
	sta $ffdd+1
	lda #$c3	; have the Z80 jump to the new code address
	sta $ffee
	dey
	sty crc		; init crc's to $ff
	sty crc+1
	sty crc+2
	sty crc+3
	iny
	jmp $ffd0	; transfer control to the Z80 using the stock switcher

return
	lda #4		; set the MMU back to default sharing
	sta $d506
	lda #$cf	; put back in the RST instuction
	sta $ffee
	sty $ff00	; y=0 from above - set default MMU config
	lda #$1b	; turn VIC back on
	sta $d011
	jsr $ff84	; reset the IO devices
	cli 

	lda crc		; check the resulting CRC
	cmp crcgood
	bne bad
	lda crc+1
	cmp crcgood+1
	bne bad
	lda crc+2
	cmp crcgood+2
	bne bad
	lda crc+3
	cmp crcgood+3
	bne bad

good
; all good, say "OK" and load next module

	jsr $ff7d
	.byte "ok"
	.byte 13,0
	lda #5
	ldx #0

next
	sta $d020
	stx $d7ff

; load next module

	lda fnext
	cmp #"-"
	beq done

	lda #0
	tax
	jsr $ff68

	lda #fend-fnext
	ldx #<fnext
	ldy #>fnext
	jsr $ffbd

; use past device parameters
;	lda #0
;	ldx #8
;	ldy #1
;	jsr $ffba

; set entry point after local completes
	lda #>(error-1)
	pha
	lda #<(error-1)
	pha

	lda #0
	jmp $ffd5
	
bad
; CRCs don't match, output result and expected

	ldx crc
	lda crc+1
	jsr $b89f
	ldx crc+2
	lda crc+3
	jsr $b89f
	jsr $ff7d
	.byte "not "
	.byte 0
	ldx crcgood
	lda crcgood+1
	jsr $b89f
	ldx crcgood+2
	lda crcgood+3
	jsr $b89f
	jsr $ff7d
	.byte 13,0

; signal failure
	lda #2
	ldx #1
	bne next

done
; report tests are done
	jsr $ff7d
	.byte "done"
	.byte 0
	rts

fnext
; next file name is stored here; makefile generates it
	.byte NEXT
fend

z80start

; z80 code is concatenated after this

; location of data in Z80 code

crcgood	= z80start+3+20+20+20
fname	= z80start+3+20+20+20+4

