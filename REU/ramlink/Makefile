
all: reuverify.prg 

reuverify.prg: reuverify.asm
	acme -f cbm -o reuverify.prg reuverify.asm
	
test128: reuverify.prg
	x64sc -reu -reusize 128 reuverify.prg
test256: reuverify.prg
	x64sc -reu -reusize 256 reuverify.prg
test512: reuverify.prg
	x64sc -reu -reusize 512 reuverify.prg
	
clean:
	$(RM) reuverify.prg

