
all: powerup.prg dumper.prg

powerup.prg: powerup.asm
	acme -f cbm -o powerup.prg powerup.asm
dumper.prg: dumper.asm
	acme -f cbm -o dumper.prg dumper.asm

test128: powerup.prg
	x64sc -reu -reusize 128 powerup.prg
test256: powerup.prg
	x64sc -reu -reusize 256 powerup.prg
test512: powerup.prg
	x64sc -reu -reusize 512 powerup.prg

testdump: dumper.prg
	$(RM) dumpfile
	x64sc -default -warp +truedrive -virtualdev -autostartprgmode 0 -reu -reusize 256 dumper.prg

clean:
	$(RM) powerup.prg
	$(RM) dumper.prg
	$(RM) dumpfile
