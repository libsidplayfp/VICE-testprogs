
all: neos0k.prg neos8k.prg

neos0k.prg: neos-vic20.asm
	acme -Dexpanded=0 -f cbm -o neos0k.prg neos-vic20.asm
	
neos8k.prg: neos-vic20.asm
	acme -Dexpanded=1 -f cbm -o neos8k.prg neos-vic20.asm
	
clean:
	$(RM) neos0k.prg
	$(RM) neos8k.prg
