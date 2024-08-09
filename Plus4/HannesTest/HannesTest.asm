MAXSLOTS = 64

H_TED_BANKS = 0
H_TED_MONOBANK = (1 << 6)

H_BOUNDARY_1000 = 0
H_BOUNDARY_4000 = (1 << 7)

!addr {
	HANNES_CTL = $fd16

	BORDER = $ff19

	PRIMM = $ff4f
	CHROUT = $ffd2

	TEST_PAGE_BASE = $4000
	
	NBANKS = $0057
	RESULT = $0058			; Zero if failure
	TEMP = $0059
}

COLOR_DEFAULT = %11101110	; Default BASIC border color
COLOR_TESTING = %01110111	; Yellow
COLOR_OK = %01010101		; Nice green
COLOR_FAIL = %00010010		; Dark red

; BASIC launcher
* = $1001 ; 10 SYS 4109 ($100d)
!zone launcher {
	!word .nextline, 0      ; second word is line number
	!byte $9e          		; SYS
	!pet "4109"        		; Address (in string format)
	!byte 0            		; End of instruction
.nextline:
	!byte 0, 0         		; End of BASIC program
}

* = 4109
	jmp start

start:
	lda #COLOR_DEFAULT
	sta BORDER

	; Preload successful test result :)
	lda #1
	sta RESULT

	; Detect number of 64 kB banks
	jsr detect

	; Show how many we found
	lda #(H_BOUNDARY_4000 | H_TED_MONOBANK)		; Back to bank 0
	sta HANNES_CTL

	jsr PRIMM
	!pet "detected $", $00

	lda TEST_PAGE_BASE
	sta NBANKS
	jsr $fb05

	jsr PRIMM
	!pet "memory bank(s)", $0d, $00

	; Start test
	lda #COLOR_TESTING
	sta BORDER
	
	jsr fill
	jsr check

	lda NBANKS
	cmp #1
	beq .setborder
	
	jsr fillrev
	jsr check

.setborder:
	lda RESULT
	beq .fail
	
.ok:
	lda #COLOR_OK
	sta BORDER
	jmp .end

.fail:
	lda #COLOR_FAIL
	sta BORDER
	
.end:
	rts


fill:
!zone fill {
	ldy #0
-	tya
	ora #(H_BOUNDARY_4000 | H_TED_MONOBANK)
	sta HANNES_CTL							; Set bank Y

	jsr PRIMM
	!pet "filling bank $", $00
	tya
	jsr $fb05
	lda #$0d
	jsr CHROUT
	
	tya
	jsr fillpage
	iny
	cpy NBANKS
	bne -

	rts

check:
	ldy #0
-	tya
	ora #(H_BOUNDARY_4000 | H_TED_MONOBANK)
	sta HANNES_CTL							; Set bank Y

	jsr PRIMM
	!pet "checking bank ", $00
	tya
	jsr $fb05

	jsr PRIMM
	!pet "... ", $00

	jsr checkpage
	bcc .ok
	jsr PRIMM
	!pet "fail", $0d, $00
	lda #0
	sta RESULT
	jmp .next

.ok:
	jsr PRIMM
	!pet "ok", $0d, $00

.next:
	iny
	cpy NBANKS
	bne -

	rts
}

;-----
fillrev:
!zone fillrev {
	ldy NBANKS
	dey
-	tya
	ora #(H_BOUNDARY_4000 | H_TED_MONOBANK)
	sta HANNES_CTL							; Set bank Y

	jsr PRIMM
	!pet "filling bank $", $00
	tya
	jsr $fb05
	lda #$0d
	jsr CHROUT
	
	tya
	jsr fillpage
	dey
	cpy #$ff
	bne -

	rts

detect:
	ldx #0
-	txa
	sta TEMP
	ora #(H_BOUNDARY_4000 | H_TED_MONOBANK)
	sta HANNES_CTL							; Set bank X
	
	sec
	lda #MAXSLOTS
	sbc TEMP
	sta TEST_PAGE_BASE
	
next:
	inx
	cpx #MAXSLOTS
	bne -
ret:
	rts
}	

; Enter with fill value in A
fillpage:
!zone fillpage {
	ldx #0
-	sta TEST_PAGE_BASE, x
	inx
	cpx #0
	bne -
	rts
}

; Enter with check value in Y
checkpage:
!zone checkpage {
	ldx #0
-	tya
	cmp TEST_PAGE_BASE, x
	bne .fail
	inx
	cpx #0
	bne -
	clc
	jmp .end

.fail:
	sec

.end:
	rts
}
