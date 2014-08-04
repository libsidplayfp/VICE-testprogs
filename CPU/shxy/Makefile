
all: shxy1.prg shxy2.prg shyx1.prg shyx2.prg

shxy1.prg: shxy1.s
	acme -f cbm -o shxy1.prg -Dopcode=0x9e shxy1.s
shxy2.prg: shxy2.s
	acme -f cbm -o shxy2.prg -Dopcode=0x9e shxy2.s
shyx1.prg: shxy1.s
	acme -f cbm -o shyx1.prg -Dopcode=0x9c shxy1.s
shyx2.prg: shxy2.s
	acme -f cbm -o shyx2.prg -Dopcode=0x9c shxy2.s

clean:
	rm -f shxy1.prg shxy2.prg
	rm -f shyx1.prg shyx2.prg
