### Replace BASIC header
1,/\.byte 0/ c\
\
		#include "1541-tests.inc"\
\
		* = $0300\
\
		.start_test\
		ldx #$40\
		stx $1c0e

### Replace error routines
### must be before 'end of test' because of /jsr print/...!
/^error/,$ c\
error\
		pla\
		pla\
error_nopla\
		lda pb\
		sta test_errcode\
errcode		lda #$ff\
		jmp test_exit

/^ste/,/jsr wait/ c\
ste\
		dec errcode+1\
		jmp error_nopla

### Skip border checks
/^waitborder/,/^i\?s\?border/ d

### Drop TASS commands
/\.block/ d
/\.bend/ d

### Move loop parameters (if present)
/^count/ H
/^opcodes/,/^$/ H
/^sr/ G

### Fix sources for branches

/lda #<break/,/^next/ c\
		ldx #0\
		lda #$02\
fill		sta jmp_page-$7e,x\
		sta jmp_page+$82,x\
		inx\
		bne fill\
next\
		clc\
		ldy cmd+2\
		lda db\
		bpl *+3\
		dey\
		adc cmd+1\
		bcc *+4\
		iny\
		clc\
		adc #2\
		bcc *+3\
		iny\
		sta tmp_zp1\
		sty tmp_zp1+1\
		ldy #0\
		lda #$60\
		sta (tmp_zp1),y\
\
		lda db

/^break/,/jsr wait/ c\
		php\
		sta aa\
		stx xa\
		sty ya\
		pla\
		sta pa\
		tsx\
		stx sa\
		ldy #0\
		lda #$02\
		sta (tmp_zp1),y\
		bne noerr\
berr\
		dec errcode+1\
		jmp error_nopla\

s/$1082/jmp_page-$7e/
s/$1182/jmp_page+$82/

### Fix end of test
/jsr print/,/jmp \$e16f/ c\
		lda #0\
test_exit\
		sta test_result\
		ldx #$c0\
		stx $1c0e\
		cli\
		.end_test

### TMPview bugs on bit!
s/\(bit .*\),x/\1/

### noc is an opcode in dreamass
s/noc/no_c/

### Label yet unknown memory locations
s/$\([0-9a-f]\{4\}\)/label_\1/
s/^\(mem.*=\).*/\1 tmp_page+$ff/

