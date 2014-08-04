
all: shsabsy1.prg shsabsy2.prg

shsabsy1.prg: shs1.s
	acme -f cbm -o shsabsy1.prg -Dopcode=0x9b shs1.s
shsabsy2.prg: shs2.s
	acme -f cbm -o shsabsy2.prg -Dopcode=0x9b shs2.s

clean:
	rm -f shsabsy1.prg shsabsy2.prg
