
all: quotemode.prg printertest.prg

quotemode.prg: quotemode.bas
	petcat -w2 -o quotemode.prg < quotemode.bas
printertest.prg: printertest.asm
	acme -f cbm -o printertest.prg printertest.asm