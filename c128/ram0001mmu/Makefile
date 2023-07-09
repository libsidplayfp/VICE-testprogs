
all: \
	c128modezp0001.prg \
	c128modebank0001.prg

c128modezp0001.prg: c128modezp0001.asm
	acme -f cbm -o c128modezp0001.prg c128modezp0001.asm

c128modebank0001.prg: c128modebank0001.asm
	acme -f cbm -o c128modebank0001.prg c128modebank0001.asm

clean: rm -f *.prg
