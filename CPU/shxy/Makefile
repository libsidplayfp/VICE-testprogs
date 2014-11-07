
all: shxy1.prg shxy2.prg shxy3.prg shyx1.prg shyx2.prg shyx3.prg

shxy1.prg: shxy1.s
	acme -f cbm -o shxy1.prg -Dopcode=0x9e shxy1.s
shxy2.prg: shxy2.s
	acme -f cbm -o shxy2.prg -Dopcode=0x9e shxy2.s
shxy3.prg: shxy3.s
	acme -f cbm -o shxy3.prg -Dopcode=0x9e shxy3.s
shyx1.prg: shxy1.s
	acme -f cbm -o shyx1.prg -Dopcode=0x9c shxy1.s
shyx2.prg: shxy2.s
	acme -f cbm -o shyx2.prg -Dopcode=0x9c shxy2.s
shyx3.prg: shxy3.s
	acme -f cbm -o shyx3.prg -Dopcode=0x9c shxy3.s

clean:
	rm -f shxy1.prg shxy2.prg shxy3.prg
	rm -f shyx1.prg shyx2.prg shyx3.prg
