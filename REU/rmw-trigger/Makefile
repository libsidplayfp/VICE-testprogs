
all: rmwtrigger-rom.prg rmwtrigger-ram.prg

rmwtrigger-rom.prg: rmwtrigger.asm
	acme -f cbm -DKERNALOFF=0 -o rmwtrigger-rom.prg rmwtrigger.asm
rmwtrigger-ram.prg: rmwtrigger.asm
	acme -f cbm -DKERNALOFF=1 -o rmwtrigger-ram.prg rmwtrigger.asm

clean:
	$(RM) rmwtrigger-rom.prg
	$(RM) rmwtrigger-ram.prg
