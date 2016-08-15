
all: progs disk

progs: colorram.prg dmacolortest.prg

colorram.prg: colorram.asm
	acme -f cbm -o colorram.prg colorram.asm

dmacolortest.prg: dmacolortest.asm
	acme -f cbm -o dmacolortest.prg dmacolortest.asm

disk: progs
	c1541 -format "reu test,00" d64 colorram.d64 \
		-write colorram.prg colorram \
		-write dmacolortest.prg dmacolortest

clean:
	rm -f dmacolortest.prg colorram.prg
	rm -f colorram.d64
