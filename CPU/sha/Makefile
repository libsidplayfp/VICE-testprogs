
all: shazpy1.prg shazpy2.prg shaabsy1.prg shaabsy2.prg

shazpy1.prg: sha1.s
	acme -f cbm -o shazpy1.prg -Dopcode=0x93 sha1.s
shazpy2.prg: sha2.s
	acme -f cbm -o shazpy2.prg -Dopcode=0x93 sha2.s
shaabsy1.prg: sha1.s
	acme -f cbm -o shaabsy1.prg -Dopcode=0x9f sha1.s
shaabsy2.prg: sha2.s
	acme -f cbm -o shaabsy2.prg -Dopcode=0x9f sha2.s

clean:
	rm -f shazpy1.prg shazpy2.prg
	rm -f shaabsy1.prg shaabsy2.prg
