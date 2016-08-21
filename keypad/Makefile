
all:	coplin-c64.prg coplin-c64dtv.prg coplin-vic20.prg coplin-plus4.prg \
	cx85-c64.prg cx85-plus4.prg cx85-vic20.prg cardkey-c64.prg \
	cardkey-plus4.prg cardkey-vic20.prg rushware-c64.prg \
	rushware-c64dtv.prg rushware-plus4.prg rushware-vic20.prg \
	cx21-c64.prg cx21-vic20.prg

coplin-c64.prg: coplin-c64.asm
	acme -v1 --cpu 6502 -f cbm -o coplin-c64.prg coplin-c64.asm

coplin-c64dtv.prg: coplin-c64dtv.asm
	acme -v1 --cpu 6502 -f cbm -o coplin-c64dtv.prg coplin-c64dtv.asm

coplin-vic20.prg: coplin-vic20.asm
	acme -v1 --cpu 6502 -f cbm -o coplin-vic20.prg coplin-vic20.asm

coplin-plus4.prg: coplin-plus4.asm
	acme -v1 --cpu 6502 -f cbm -o coplin-plus4.prg coplin-plus4.asm

cx85-c64.prg: cx85-c64.asm
	acme -v1 --cpu 6502 -f cbm -o cx85-c64.prg cx85-c64.asm

cx85-plus4.prg: cx85-plus4.asm
	acme -v1 --cpu 6502 -f cbm -o cx85-plus4.prg cx85-plus4.asm

cx85-vic20.prg: cx85-vic20.asm
	acme -v1 --cpu 6502 -f cbm -o cx85-vic20.prg cx85-vic20.asm

cardkey-c64.prg: cardkey-c64.asm
	acme -v1 --cpu 6502 -f cbm -o cardkey-c64.prg cardkey-c64.asm

cardkey-plus4.prg: cardkey-plus4.asm
	acme -v1 --cpu 6502 -f cbm -o cardkey-plus4.prg cardkey-plus4.asm

cardkey-vic20.prg: cardkey-vic20.asm
	acme -v1 --cpu 6502 -f cbm -o cardkey-vic20.prg cardkey-vic20.asm

rushware-c64.prg: rushware-c64.asm
	acme -v1 --cpu 6502 -f cbm -o rushware-c64.prg rushware-c64.asm

rushware-c64dtv.prg: rushware-c64dtv.asm
	acme -v1 --cpu 6502 -f cbm -o rushware-c64dtv.prg rushware-c64dtv.asm

rushware-plus4.prg: rushware-plus4.asm
	acme -v1 --cpu 6502 -f cbm -o rushware-plus4.prg rushware-plus4.asm

rushware-vic20.prg: rushware-vic20.asm
	acme -v1 --cpu 6502 -f cbm -o rushware-vic20.prg rushware-vic20.asm

cx21-c64.prg: cx21-c64.asm
	acme -v1 --cpu 6502 -f cbm -o cx21-c64.prg cx21-c64.asm

cx21-vic20.prg: cx21-vic20.asm
	acme -v --cpu 6502 -f cbm -o cx21-vic20.prg cx21-vic20.asm

clean:
	rm -f *~
	rm -f *.prg
