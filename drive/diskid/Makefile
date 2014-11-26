all: diskid1.prg diskid.d64

diskid1.prg: diskid1.asm
	acme diskid1.asm

diskid.d64: diskid1.prg
	c1541 -format "diskid,ax" d64 diskid.d64 -write "diskid1.prg" "diskid1"
	
test: diskid1.prg diskid.d64
#	x64sc -truedrive -autostartprgmode 2 diskid1.prg
	x64sc -truedrive diskid.d64
 
clean:
	rm -f *~
	rm -f diskid1.prg
	rm -f diskid.d64
	