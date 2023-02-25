
all: \
	c128modez80-00.prg \
	c128modez80-01.prg \
	c64modez80-00.prg \
	c64modez80-01.prg \
	c64modez80-02.prg \
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
	c64modemmu-13.prg \
	c64modemmu-14.prg

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

c64modemmu-14.prg: c64modemmu-14.asm
	acme -f cbm -o c64modemmu-14.prg c64modemmu-14.asm

c64modez80-00.prg: c64modez80-00.asm c64modez80-00.bin
	acme -f cbm -o c64modez80-00.prg c64modez80-00.asm

c64modez80-00.bin: c64modez80-00.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c64modez80-00.c
	rm -f A A.LDR
	mv a.bin c64modez80-00.bin

c64modez80-01.prg: c64modez80-01.asm c64modez80-01.bin
	acme -f cbm -o c64modez80-01.prg c64modez80-01.asm

c64modez80-01.bin: c64modez80-01.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c64modez80-01.c
	rm -f A A.LDR
	mv a.bin c64modez80-01.bin

c64modez80-02.prg: c64modez80-02.asm c64modez80-02.bin
	acme -f cbm -o c64modez80-02.prg c64modez80-02.asm

c64modez80-02.bin: c64modez80-02.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c64modez80-02.c
	rm -f A A.LDR
	mv a.bin c64modez80-02.bin

c128modez80-00.prg: c128modez80-00.asm c128modez80-00.bin
	acme -f cbm -o c128modez80-00.prg c128modez80-00.asm

c128modez80-00.bin: c128modez80-00.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c128modez80-00.c
	rm -f A A.LDR
	mv a.bin c128modez80-00.bin

c128modez80-01.prg: c128modez80-01.asm c128modez80-01.bin
	acme -f cbm -o c128modez80-01.prg c128modez80-01.asm

c128modez80-01.bin: c128modez80-01.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c128modez80-01.c
	rm -f A A.LDR
	mv a.bin c128modez80-01.bin

clean:
	rm -f c64modemmu-*.prg
