
all: ltkhwtest.d64

ltkhw64.prg: ltkhw64.asm
	xa -o ltkhw64.prg ltkhw64.asm
	
ltkhw128.prg: ltkhw128.asm
	xa -o ltkhw128.prg ltkhw128.asm
	
ltkhwtest.d64: ltkhw64.prg ltkhw128.prg
	c1541 -format "ltkhwtest,00" d64 ltkhwtest.d64 \
		-write "ltkhw64.prg" "ltkhw64" \
		-write "ltkhw128.prg" "ltkhw128"

clean:
	$(RM) ltkhw64.prg
	$(RM) ltkhw128.prg
	$(RM) ltkhwtest.d64
