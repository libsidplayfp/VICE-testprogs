
all: shsabsy1.prg shsabsy2.prg shsabsy3.prg

shsabsy1.prg: shs1.s
	acme -f cbm -o shsabsy1.prg -Dopcode=0x9b shs1.s
shsabsy2.prg: shs2.s
	acme -f cbm -o shsabsy2.prg -Dopcode=0x9b shs2.s
shsabsy3.prg: shs3.s
	acme -f cbm -o shsabsy3.prg -Dopcode=0x9b shs3.s

clean:
	rm -f shsabsy1.prg shsabsy2.prg shsabsy3.prg
