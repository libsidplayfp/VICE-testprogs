
all: b1c64victest.prg b1c128victest.prg

b1c128victest.prg: b1c128victest.asm
	acme -f cbm -o b1c128victest.prg b1c128victest.asm
b1c64victest.prg: b1c64victest.asm
	acme -f cbm -o b1c64victest.prg b1c64victest.asm

clean:
	$(RM) b1c64victest.prg b1c128victest.prg
