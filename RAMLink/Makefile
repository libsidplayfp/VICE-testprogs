
all: rlhwtest.d64

rlhw64.prg: rlhw64.asm
	xa -o rlhw64.prg rlhw64.asm
	
rlhw128.prg: rlhw128.asm
	xa -o rlhw128.prg rlhw128.asm
	
rlhwtest.d64: rlhw64.prg rlhw128.prg
	c1541 -format "rlhwtest,00" d64 rlhwtest.d64 \
		-write "rlhw64.prg" "rlhw64" \
		-write "rlhw128.prg" "rlhw128"

clean:
	$(RM) rlhw64.prg
	$(RM) rlhw128.prg
	$(RM) rlhwtest.d64
