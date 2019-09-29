
all: shazpy1.prg shazpy2.prg shazpy3.prg shaabsy1.prg shaabsy2.prg shaabsy3.prg

shazpy1.prg: sha1.s
	acme -f cbm -o shazpy1.prg -Dopcode=0x93 sha1.s
shazpy2.prg: sha2.s
	acme -f cbm -o shazpy2.prg -Dopcode=0x93 sha2.s
shazpy3.prg: sha3.s
	acme -f cbm -o shazpy3.prg -Dopcode=0x93 sha3.s
shazpy4.prg: sha4.s
	acme -f cbm -o shazpy4.prg -Dopcode=0x93 sha4.s
shazpy5.prg: sha5.s
	acme -f cbm -o shazpy5.prg -Dopcode=0x93 sha5.s

shaabsy1.prg: sha1.s
	acme -f cbm -o shaabsy1.prg -Dopcode=0x9f sha1.s
shaabsy2.prg: sha2.s
	acme -f cbm -o shaabsy2.prg -Dopcode=0x9f sha2.s
shaabsy3.prg: sha3.s
	acme -f cbm -o shaabsy3.prg -Dopcode=0x9f sha3.s
shaabsy4.prg: sha4.s
	acme -f cbm -o shaabsy4.prg -Dopcode=0x9f sha4.s
shaabsy5.prg: sha5.s
	acme -f cbm -o shaabsy5.prg -Dopcode=0x9f sha5.s

clean:
	rm -f sha{zp,abs}y[12345].prg
