
all: test7a.prg test8a.prg

test7a.prg: test7a.asm bitmap7a.prg
	acme -f cbm -o test7a.prg test7a.asm
test8a.prg: test8a.asm bitmap8a.prg
	acme -f cbm -o test8a.prg test8a.asm

clean:
	$(RM) test7a.prg
	$(RM) test8a.prg
