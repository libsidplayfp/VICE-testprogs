all: rpm1.prg rpm.d64

rpm1.prg: rpm1.asm
	acme rpm1.asm

rpm.d64: rpm1.prg
	c1541 -format "rpm,00" d64 rpm.d64 -write "rpm1.prg" "rpm1"
	
test: rpm1.prg rpm.d64
#	x64sc -truedrive -autostartprgmode 2 rpm1.prg
	x64sc -truedrive rpm.d64
 
clean:
	rm -f *~
	rm -f rpm1.prg
	rm -f rpm.d64
	