
all: \
	c64modez80.prg \
	c64modemmu-00.prg \
	c64modemmu-01.prg \
	c64modemmu-02.prg \
	c64modemmu-03.prg \
	c64modemmu-04.prg \
	c64modemmu-05.prg \
	c64modemmu-06.prg \
	c64modemmu-07.prg \
	c64modemmu-08.prg \
	c64modemmu-09.prg \
	c64modemmu-10.prg \
	c64modemmu-11.prg \
	c64modemmu-12.prg \
	c64modemmu-13.prg

c64modemmu-00.prg: c64modemmu-00.asm
	acme -f cbm -o c64modemmu-00.prg c64modemmu-00.asm

c64modemmu-01.prg: c64modemmu-01.asm
	acme -f cbm -o c64modemmu-01.prg c64modemmu-01.asm

c64modemmu-02.prg: c64modemmu-02.asm
	acme -f cbm -o c64modemmu-02.prg c64modemmu-02.asm

c64modemmu-03.prg: c64modemmu-03.asm
	acme -f cbm -o c64modemmu-03.prg c64modemmu-03.asm

c64modemmu-04.prg: c64modemmu-04.asm
	acme -f cbm -o c64modemmu-04.prg c64modemmu-04.asm

c64modemmu-05.prg: c64modemmu-05.asm
	acme -f cbm -o c64modemmu-05.prg c64modemmu-05.asm

c64modemmu-06.prg: c64modemmu-06.asm
	acme -f cbm -o c64modemmu-06.prg c64modemmu-06.asm

c64modemmu-07.prg: c64modemmu-07.asm
	acme -f cbm -o c64modemmu-07.prg c64modemmu-07.asm

c64modemmu-08.prg: c64modemmu-08.asm
	acme -f cbm -o c64modemmu-08.prg c64modemmu-08.asm

c64modemmu-09.prg: c64modemmu-09.asm
	acme -f cbm -o c64modemmu-09.prg c64modemmu-09.asm

c64modemmu-10.prg: c64modemmu-10.asm
	acme -f cbm -o c64modemmu-10.prg c64modemmu-10.asm

c64modemmu-11.prg: c64modemmu-11.asm
	acme -f cbm -o c64modemmu-11.prg c64modemmu-11.asm

c64modemmu-12.prg: c64modemmu-12.asm
	acme -f cbm -o c64modemmu-12.prg c64modemmu-12.asm

c64modemmu-13.prg: c64modemmu-13.asm
	acme -f cbm -o c64modemmu-13.prg c64modemmu-13.asm

c64modez80.prg: c64modez80.asm a.bin
	acme -f cbm -o c64modez80.prg c64modez80.asm

a.bin: c64modez80.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c64modez80.c
	rm -f A
	rm -f A.LDR

clean:
	rm -f c64modemmu-*.prg
