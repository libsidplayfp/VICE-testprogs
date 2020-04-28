
all: simple.prg simple.bin

simple.prg: simple.asm
	acme -f cbm -o simple.prg simple.asm
simple.bin: simple.asm
	acme -f plain -o simple.bin simple.asm
