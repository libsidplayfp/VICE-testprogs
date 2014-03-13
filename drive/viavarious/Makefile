
all: via1.prg via2.prg via3.prg via3a.prg

COMMON=common.asm ../framework.asm ../framework-drive.asm

via1.prg: via1.asm $(COMMON)
	acme via1.asm
via2.prg: via2.asm $(COMMON)
	acme via2.asm
via3.prg: via3.asm $(COMMON)
	acme via3.asm
via3a.prg: via3a.asm $(COMMON)
	acme via3a.asm

test: all
	x64sc -truedrive -autostartprgmode 2 via3.prg
 
clean:
	rm -f *~
	rm -f via1.prg
	rm -f via2.prg
	rm -f via3.prg
	rm -f via3a.prg
	rm -f via4.prg
	rm -f via5.prg
	rm -f via6.prg
	rm -f via7.prg
	rm -f via8.prg
	rm -f via9.prg
	rm -f via10.prg
	rm -f via11.prg
	rm -f via12.prg
	rm -f via13.prg
	rm -f via14.prg
