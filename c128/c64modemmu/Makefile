
all: \
	c128modez80-00.prg \
	c128modez80-01.prg \
	c128modez80-02.prg \
	c128modez80-03.prg \
	c128modez80-04.prg \
	c128modez80-05.prg \
	c128modez80-06.prg \
	c128modez80-07.prg \
	c128modez80-08.prg \
	c128modez80-09.prg \
	c128modez80-10.prg \
	c128modez80-11.prg \
	c128modez80-12.prg \
	c128modez80-13.prg \
	c128modez80-14.prg \
	c128modez80-15.prg \
	c128modez80-16.prg \
	c128modez80-17.prg \
	c128modez80-18.prg \
	c128modez80-19.prg \
	c128modez80-20.prg \
	c128modez80-21.prg \
	c128modez80-22.prg \
	c128modez80-23.prg \
	c128modez80-24.prg \
	c128modez80-25.prg \
	c64modez80-00.prg \
	c64modez80-01.prg \
	c64modez80-02.prg \
	c64modez80-03.prg \
	c64modez80-04.prg \
	c64modez80-05.prg \
	c64modez80-06.prg \
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
	c64modemmu-14.prg \
	c64modemmu-15.prg \
	c64modemmu-16.prg \
	c64modemmu-17.prg

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

c64modemmu-15.prg: c64modemmu-15.asm
	acme -f cbm -o c64modemmu-15.prg c64modemmu-15.asm

c64modemmu-16.prg: c64modemmu-16.asm
	acme -f cbm -o c64modemmu-16.prg c64modemmu-16.asm

c64modemmu-17.prg: c64modemmu-17.asm
	acme -f cbm -o c64modemmu-17.prg c64modemmu-17.asm

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

c64modez80-03.prg: c64modez80-03.asm c64modez80-03.bin
	acme -f cbm -o c64modez80-03.prg c64modez80-03.asm

c64modez80-03.bin: c64modez80-03.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c64modez80-03.c
	rm -f A A.LDR
	mv a.bin c64modez80-03.bin

c64modez80-04.prg: c64modez80-04.asm c64modez80-04.bin
	acme -f cbm -o c64modez80-04.prg c64modez80-04.asm

c64modez80-04.bin: c64modez80-04.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c64modez80-04.c
	rm -f A A.LDR
	mv a.bin c64modez80-04.bin

c64modez80-05.prg: c64modez80-05.asm c64modez80-05.bin
	acme -f cbm -o c64modez80-05.prg c64modez80-05.asm

c64modez80-05.bin: c64modez80-05.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c64modez80-05.c
	rm -f A A.LDR
	mv a.bin c64modez80-05.bin

c64modez80-06.prg: c64modez80-06.asm c64modez80-06.bin
	acme -f cbm -o c64modez80-06.prg c64modez80-06.asm

c64modez80-06.bin: c64modez80-06.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c64modez80-06.c
	rm -f A A.LDR
	mv a.bin c64modez80-06.bin

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

c128modez80-02.prg: c128modez80-02.asm c128modez80-02.bin
	acme -f cbm -o c128modez80-02.prg c128modez80-02.asm

c128modez80-02.bin: c128modez80-02.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c128modez80-02.c
	rm -f A A.LDR
	mv a.bin c128modez80-02.bin

c128modez80-03.prg: c128modez80-03.asm c128modez80-03.bin
	acme -f cbm -o c128modez80-03.prg c128modez80-03.asm

c128modez80-03.bin: c128modez80-03.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c128modez80-03.c
	rm -f A A.LDR
	mv a.bin c128modez80-03.bin

c128modez80-04.prg: c128modez80-04.asm c128modez80-04.bin
	acme -f cbm -o c128modez80-04.prg c128modez80-04.asm

c128modez80-04.bin: c128modez80-04.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c128modez80-04.c
	rm -f A A.LDR
	mv a.bin c128modez80-04.bin

c128modez80-05.prg: c128modez80-05.asm c128modez80-05.bin
	acme -f cbm -o c128modez80-05.prg c128modez80-05.asm

c128modez80-05.bin: c128modez80-05.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c128modez80-05.c
	rm -f A A.LDR
	mv a.bin c128modez80-05.bin

c128modez80-06.prg: c128modez80-06.asm c128modez80-06.bin
	acme -f cbm -o c128modez80-06.prg c128modez80-06.asm

c128modez80-06.bin: c128modez80-06.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c128modez80-06.c
	rm -f A A.LDR
	mv a.bin c128modez80-06.bin

c128modez80-07.prg: c128modez80-07.asm c128modez80-07.bin
	acme -f cbm -o c128modez80-07.prg c128modez80-07.asm

c128modez80-07.bin: c128modez80-07.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c128modez80-07.c
	rm -f A A.LDR
	mv a.bin c128modez80-07.bin

c128modez80-08.prg: c128modez80-08.asm c128modez80-08.bin
	acme -f cbm -o c128modez80-08.prg c128modez80-08.asm

c128modez80-08.bin: c128modez80-08.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c128modez80-08.c
	rm -f A A.LDR
	mv a.bin c128modez80-08.bin

c128modez80-09.prg: c128modez80-09.asm c128modez80-09.bin
	acme -f cbm -o c128modez80-09.prg c128modez80-09.asm

c128modez80-09.bin: c128modez80-09.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c128modez80-09.c
	rm -f A A.LDR
	mv a.bin c128modez80-09.bin

c128modez80-10.prg: c128modez80-10.asm c128modez80-10.bin
	acme -f cbm -o c128modez80-10.prg c128modez80-10.asm

c128modez80-10.bin: c128modez80-10.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c128modez80-10.c
	rm -f A A.LDR
	mv a.bin c128modez80-10.bin

c128modez80-11.prg: c128modez80-11.asm c128modez80-11.bin
	acme -f cbm -o c128modez80-11.prg c128modez80-11.asm

c128modez80-11.bin: c128modez80-11.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c128modez80-11.c
	rm -f A A.LDR
	mv a.bin c128modez80-11.bin

c128modez80-12.prg: c128modez80-12.asm c128modez80-12.bin
	acme -f cbm -o c128modez80-12.prg c128modez80-12.asm

c128modez80-12.bin: c128modez80-12.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c128modez80-12.c
	rm -f A A.LDR
	mv a.bin c128modez80-12.bin

c128modez80-13.prg: c128modez80-13.asm c128modez80-13.bin
	acme -f cbm -o c128modez80-13.prg c128modez80-13.asm

c128modez80-13.bin: c128modez80-13.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c128modez80-13.c
	rm -f A A.LDR
	mv a.bin c128modez80-13.bin

c128modez80-14.prg: c128modez80-14.asm c128modez80-14.bin
	acme -f cbm -o c128modez80-14.prg c128modez80-14.asm

c128modez80-14.bin: c128modez80-14.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c128modez80-14.c
	rm -f A A.LDR
	mv a.bin c128modez80-14.bin

c128modez80-15.prg: c128modez80-15.asm c128modez80-15.bin
	acme -f cbm -o c128modez80-15.prg c128modez80-15.asm

c128modez80-15.bin: c128modez80-15.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c128modez80-15.c
	rm -f A A.LDR
	mv a.bin c128modez80-15.bin

c128modez80-16.prg: c128modez80-16.asm c128modez80-16.bin
	acme -f cbm -o c128modez80-16.prg c128modez80-16.asm

c128modez80-16.bin: c128modez80-16.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c128modez80-16.c
	rm -f A A.LDR
	mv a.bin c128modez80-16.bin

c128modez80-17.prg: c128modez80-17.asm c128modez80-17.bin
	acme -f cbm -o c128modez80-17.prg c128modez80-17.asm

c128modez80-17.bin: c128modez80-17.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c128modez80-17.c
	rm -f A A.LDR
	mv a.bin c128modez80-17.bin

c128modez80-18.prg: c128modez80-18.asm c128modez80-18.bin
	acme -f cbm -o c128modez80-18.prg c128modez80-18.asm

c128modez80-18.bin: c128modez80-18.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c128modez80-18.c
	rm -f A A.LDR
	mv a.bin c128modez80-18.bin

c128modez80-19.prg: c128modez80-19.asm c128modez80-19.bin
	acme -f cbm -o c128modez80-19.prg c128modez80-19.asm

c128modez80-19.bin: c128modez80-19.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c128modez80-19.c
	rm -f A A.LDR
	mv a.bin c128modez80-19.bin

c128modez80-20.prg: c128modez80-20.asm c128modez80-20.bin
	acme -f cbm -o c128modez80-20.prg c128modez80-20.asm

c128modez80-20.bin: c128modez80-20.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c128modez80-20.c
	rm -f A A.LDR
	mv a.bin c128modez80-20.bin

c128modez80-21.prg: c128modez80-21.asm c128modez80-21.bin
	acme -f cbm -o c128modez80-21.prg c128modez80-21.asm

c128modez80-21.bin: c128modez80-21.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c128modez80-21.c
	rm -f A A.LDR
	mv a.bin c128modez80-21.bin

c128modez80-22.prg: c128modez80-22.asm c128modez80-22.bin
	acme -f cbm -o c128modez80-22.prg c128modez80-22.asm

c128modez80-22.bin: c128modez80-22.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c128modez80-22.c
	rm -f A A.LDR
	mv a.bin c128modez80-22.bin

c128modez80-23.prg: c128modez80-23.asm c128modez80-23.bin
	acme -f cbm -o c128modez80-23.prg c128modez80-23.asm

c128modez80-23.bin: c128modez80-23.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c128modez80-23.c
	rm -f A A.LDR
	mv a.bin c128modez80-23.bin

c128modez80-24.prg: c128modez80-24.asm c128modez80-24.bin
	acme -f cbm -o c128modez80-24.prg c128modez80-24.asm

c128modez80-24.bin: c128modez80-24.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c128modez80-24.c
	rm -f A A.LDR
	mv a.bin c128modez80-24.bin

c128modez80-25.prg: c128modez80-25.asm c128modez80-25.bin
	acme -f cbm -o c128modez80-25.prg c128modez80-25.asm

c128modez80-25.bin: c128modez80-25.c
	zcc +c128 -create-app -subtype=disk -zorg=8192 c128modez80-25.c
	rm -f A A.LDR
	mv a.bin c128modez80-25.bin

clean: rm -f c64modemmu-*.prg
