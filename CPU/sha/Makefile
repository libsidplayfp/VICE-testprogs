
all: shazpy1.prg shazpy2.prg shazpy3.prg shaabsy1.prg shaabsy2.prg shaabsy3.prg

shazpy1.prg: sha1.s
	acme -f cbm -o shazpy1.prg -Dopcode=0x93 sha1.s
shazpy2.prg: sha2.s
	acme -f cbm -o shazpy2.prg -Dopcode=0x93 sha2.s
shazpy3.prg: sha3.s
	acme -f cbm -o shazpy3.prg -Dopcode=0x93 sha3.s
shaabsy1.prg: sha1.s
	acme -f cbm -o shaabsy1.prg -Dopcode=0x9f sha1.s
shaabsy2.prg: sha2.s
	acme -f cbm -o shaabsy2.prg -Dopcode=0x9f sha2.s
shaabsy3.prg: sha3.s
	acme -f cbm -o shaabsy3.prg -Dopcode=0x9f sha3.s

clean:
	rm -f shazpy1.prg shazpy2.prg shazpy3.prg
	rm -f shaabsy1.prg shaabsy2.prg shaabsy3.prg
