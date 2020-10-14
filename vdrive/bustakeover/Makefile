

all: bustakeover.prg bustakeover.d64

bustakeover.prg: bustakeover.asm
	acme -f cbm -o bustakeover.prg bustakeover.asm
	
bustakeover.d64: bustakeover.prg
	c1541 -format "test,00" d64 bustakeover.d64 \
		-write bustakeover.prg "test" \
		-write bustakeover.prg "testseq,s,w"
	
clean:
	$(RM) bustakeover.prg
	$(RM) bustakeover.d64
