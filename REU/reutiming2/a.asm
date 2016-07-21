
		*= $0801
		.dsection code
		.section code
		.word +,2016
		.null $9e,^start
+		.word 0
		.send

		.dsection data
		.dsection bss

start		.section code
		sei
		ldx #63
-		dex
		txa
		sta tmp,x
		bne -
		.section data
reu1		.byte %10010000
		.word tmp
off		.long 0
		.word 63
		.byte 0
		.byte 0
		.send data
		ldy #201
lp		ldx #10
-		lda reu1-1,x
		sta $df00,x
		dex
		bne -
		lda off
		clc
		adc #63
		sta off
		bcc +
		inc off+1
+		dey
		bne lp
		ldx #0
		lda #$f0
-		sta $400+range(4)*256,x
		inx
		bne -
		lda #3
		sta $dd00
		lda #8
		sta $d016
		lda #29
		sta $d018
		lda #59
		sta $d011
		lda #255
		sta $d015
		sta $d017
		sta $d01b
		sta $d01d
		lda #0
		sta $d010
		sta $d01c
		ldx #8
-		dex
		sta $d027,x
		bne -
		ldx #16
-		dex
		txa
		asl a
		asl a
		ora #128
		sta $d000,x
		lda #0
		dex
		sta $d000,x
		bne -
loop		lda $d011
		bpl *-3
		lda $d011
		bmi *-3
		.page
		ldy #40
-		lda $d012
		cmp $d012
		bne e
e		ldx #8
s		dex
		bne s
		cmp (0,x)
		dey
		bne -
		.endp
		nop
		nop
		nop
		.section data
reu2		.byte %10010001
		.word $d020
		.long 0
		.word 63*188+1
		.byte 0
		.byte 128
		.send data
		ldx #10
-		lda reu2-1,x
		sta $df00,x
		dex
		bne -
		jmp loop

		*=$2000
                .binary "a.hpi",2

		.section bss
tmp		.fill 63
		.send bss

		.send code
