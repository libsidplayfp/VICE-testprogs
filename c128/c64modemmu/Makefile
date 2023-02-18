
all: \
	c64modemmu-00.prg \
	c64modemmu-01.prg \
	c64modemmu-02.prg

c64modemmu-00.prg: c64modemmu-00.asm
	acme -f cbm -o c64modemmu-00.prg c64modemmu-00.asm

c64modemmu-01.prg: c64modemmu-01.asm
	acme -f cbm -o c64modemmu-01.prg c64modemmu-01.asm

c64modemmu-02.prg: c64modemmu-02.asm
	acme -f cbm -o c64modemmu-02.prg c64modemmu-02.asm

clean:
	rm -f c64modemmu-*.prg
