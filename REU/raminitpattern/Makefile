
all: powerup.prg

powerup.prg: powerup.asm
	acme -f cbm -o powerup.prg powerup.asm

test128: powerup.prg
	x64sc -reu -reusize 128 powerup.prg
test256: powerup.prg
	x64sc -reu -reusize 256 powerup.prg
test512: powerup.prg
	x64sc -reu -reusize 512 powerup.prg
	
clean:
	$(RM) powerup.prg
