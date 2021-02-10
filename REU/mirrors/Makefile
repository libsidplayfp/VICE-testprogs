
all: mirrors.prg mirrors128k.prg mirrors256k.prg mirrors512k.prg \
	mirrors1m.prg mirrors2m.prg mirrors4m.prg mirrors8m.prg mirrors16m.prg

mirrors.prg: mirrors.asm
	acme -f cbm -DTESTSIZE=0 -o mirrors.prg mirrors.asm
mirrors128k.prg: mirrors.asm
	acme -f cbm -DTESTSIZE=128 -o mirrors128k.prg mirrors.asm
mirrors256k.prg: mirrors.asm
	acme -f cbm -DTESTSIZE=256 -o mirrors256k.prg mirrors.asm
mirrors512k.prg: mirrors.asm
	acme -f cbm -DTESTSIZE=512 -o mirrors512k.prg mirrors.asm
mirrors1m.prg: mirrors.asm
	acme -f cbm -DTESTSIZE=1024 -o mirrors1m.prg mirrors.asm
mirrors2m.prg: mirrors.asm
	acme -f cbm -DTESTSIZE=2048 -o mirrors2m.prg mirrors.asm
mirrors4m.prg: mirrors.asm
	acme -f cbm -DTESTSIZE=4096 -o mirrors4m.prg mirrors.asm
mirrors8m.prg: mirrors.asm
	acme -f cbm -DTESTSIZE=8192 -o mirrors8m.prg mirrors.asm
mirrors16m.prg: mirrors.asm
	acme -f cbm -DTESTSIZE=16384 -o mirrors16m.prg mirrors.asm

	
	
test128: mirrors.prg
	x64sc -reu -reusize 128 mirrors.prg
test256: mirrors.prg
	x64sc -reu -reusize 256 mirrors.prg
test512: mirrors.prg
	x64sc -reu -reusize 512 mirrors.prg
test1024: mirrors.prg
	x64sc -reu -reusize 1024 mirrors.prg
test2048: mirrors.prg
	x64sc -reu -reusize 2048 mirrors.prg
test16384: mirrors.prg
	x64sc -reu -reusize 16384 mirrors.prg
	
clean:
	$(RM) mirrors.prg
	$(RM) mirrors128k.prg
	$(RM) mirrors256k.prg
	$(RM) mirrors512k.prg
	$(RM) mirrors1m.prg
	$(RM) mirrors2m.prg
	$(RM) mirrors4m.prg
	$(RM) mirrors8m.prg
	$(RM) mirrors16m.prg
