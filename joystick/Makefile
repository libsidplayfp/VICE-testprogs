
all: snespad-trapthem.prg standard-3buttons.prg wheelofjoy-plus4.prg

snespad-trapthem.prg: snespad-trapthem.asm
	acme -f cbm -o snespad-trapthem.prg snespad-trapthem.asm

standard-3buttons.prg: standard-3buttons.asm
	acme -f cbm -o standard-3buttons.prg standard-3buttons.asm

wheelofjoy-plus4.prg: wheelofjoy-plus4.bas
	petcat -w3 -o wheelofjoy-plus4.prg -- wheelofjoy-plus4.bas
