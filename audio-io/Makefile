
all: \
	audio-io-c64.prg \
	audio-io-c128.prg \
	audio-io-cbm5x0.prg \
	audio-io-cbm6x0.prg \
	audio-io-pet.prg \
	audio-io-plus4.prg \
	audio-io-vic20.prg \
	audio-io-c128-z80.prg \
	audio-io-c64-z80.prg \
	audio128.com \
	audio64.com

audio-io-c64.prg: audio-io.c stream.s c64-drivers.s stubs.s
	cl65 -t c64 -o audio-io-c64.prg audio-io.c stream.s c64-drivers.s stubs.s

audio-io-c128.prg: audio-io.c stream.s c64-drivers.s stubs.s
	cl65 -t c128 -o audio-io-c128.prg audio-io.c stream.s c64-drivers.s stubs.s

audio-io-cbm5x0.prg: audio-io.c stream.s cbm5x0-drivers.s cbm2-common-drivers.s stubs.s
	cl65 -t cbm510 -o audio-io-cbm5x0.prg audio-io.c stream.s cbm5x0-drivers.s cbm2-common-drivers.s stubs.s

audio-io-cbm6x0.prg: audio-io.c stream.s cbm2-drivers.s cbm2-common-drivers.s stubs.s
	cl65 -t cbm610 -o audio-io-cbm6x0.prg audio-io.c stream.s cbm2-drivers.s cbm2-common-drivers.s stubs.s

audio-io-pet.prg: audio-io.c stream.s pet-drivers.s stubs.s
	cl65 -t pet -o audio-io-pet.prg audio-io.c stream.s pet-drivers.s stubs.s

audio-io-plus4.prg: audio-io.c stream.s plus4-drivers.s stubs.s
	cl65 -t c16 -o audio-io-plus4.prg audio-io.c stream.s plus4-drivers.s stubs.s

audio-io-vic20.prg: audio-io.c stream.s vic20-drivers.s stubs.s
	cl65 -t vic20 -C vic20-32k.cfg -o audio-io-vic20.prg audio-io.c stream.s vic20-drivers.s stubs.s

audio128.com: audio-io-z80.c z80-drivers128.asm
	zcc +cpm -D__C128CPM__ -o audio128.com audio-io-z80.c z80-drivers128.asm

z80-drivers128.asm: z80-drivers.asm
	sed 's/IOBASE/0xd000/g' <z80-drivers.asm >z80-drivers128.asm

audio64.com: audio-io-z80.c z80-drivers64.asm
	zcc +cpm -D__C64CPM__ -o audio64.com audio-io-z80.c z80-drivers64.asm

z80-drivers64.asm: z80-drivers.asm
	sed 's/IOBASE/0xc000/g' <z80-drivers.asm >z80-drivers64.asm

audio-io-c128-z80.prg: audio-io-c128-z80.asm audio-io-c128-z80.bin
	acme -f cbm -o audio-io-c128-z80.prg audio-io-c128-z80.asm

audio-io-c128-z80.bin: audio-io-z80.c z80-drivers128.asm
	zcc +c128 -create-app -subtype=disk -D__C128NATIVE__ audio-io-z80.c z80-drivers128.asm
	rm -f A A.LDR
	mv a.bin audio-io-c128-z80.bin

audio-io-c64-z80.prg: audio-io-c64-z80.asm audio-io-c64-z80.bin
	acme -f cbm -o audio-io-c64-z80.prg audio-io-c64-z80.asm

audio-io-c64-z80.bin: audio-io-z80.c z80-drivers64.asm
	zcc +c128 -create-app -subtype=disk -zorg=256 -D__C64NATIVE__ audio-io-z80.c z80-drivers64.asm
	rm -f A A.LDR
	mv a.bin audio-io-c64-z80.bin
