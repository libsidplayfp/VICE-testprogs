
all: vsp-tester.prg

vsp-tester.prg: vsp-tester.asm
	64tass --m6502 -o vsp-tester.prg vsp-tester.asm
	
clean:
	$(RM) vsp-tester.prg
