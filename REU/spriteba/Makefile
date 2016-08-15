
all: progs disk

progs: spriteba.prg

spriteba.prg: spriteba.asm
	acme -f cbm -o spriteba.prg spriteba.asm

disk: progs
	c1541 -format "reu test,00" d64 spriteba.d64 \
		-write spriteba.prg spriteba

clean:
	rm -f spriteba.prg
	rm -f spriteba.d64
