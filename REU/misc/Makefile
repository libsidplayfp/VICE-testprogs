
all: progs disk

progs: wheels.prg bitfill.prg twoblocks.prg twoblocks-ff00.prg \
	bitfill-auto.prg twoblocks-auto.prg twoblocks-ff00-auto.prg

wheels.prg: wheels.asm
	acme -f cbm -o wheels.prg wheels.asm
bitfill.prg: bitfill.asm
	acme -f cbm -DINTERACTIVE=1 -o bitfill.prg bitfill.asm
twoblocks.prg: twoblocks.asm
	acme -DUSEFF00=0 -DINTERACTIVE=1 -f cbm -o twoblocks.prg twoblocks.asm
twoblocks-ff00.prg: twoblocks.asm
	acme -DUSEFF00=1 -DINTERACTIVE=1 -f cbm -o twoblocks-ff00.prg twoblocks.asm
bitfill-auto.prg: bitfill.asm
	acme -f cbm -DINTERACTIVE=0 -o bitfill-auto.prg bitfill.asm
twoblocks-auto.prg: twoblocks.asm
	acme -DUSEFF00=0 -DINTERACTIVE=0 -f cbm -o twoblocks-auto.prg twoblocks.asm
twoblocks-ff00-auto.prg: twoblocks.asm
	acme -DUSEFF00=1 -DINTERACTIVE=0 -f cbm -o twoblocks-ff00-auto.prg twoblocks.asm

disk: progs
	c1541 -format "reu test,00" d64 reutests.d64 \
		-write wheels.prg wheels \
		-write bitfill.prg bitfill \
		-write twoblocks.prg twoblocks \
		-write twoblocks-ff00.prg twoblocks-ff00

clean:
	rm -f wheels.prg bitfill.prg twoblocks.prg twoblocks-ff00.prg
	rm -f bitfill-auto.prg twoblocks-auto.prg twoblocks-ff00-auto.prg
	rm -f reutests.d64
