
all: reuverify.prg reuverify128k.prg reuverify256k.prg reuverify512k.prg \
	reuverify1m.prg reuverify2m.prg reuverify4m.prg reuverify8m.prg

reuverify.prg: reuverify.asm
	acme -f cbm -DTESTSIZE=0 -o reuverify.prg reuverify.asm

reuverify128k.prg: reuverify.asm
	acme -f cbm -DTESTSIZE=128 -o reuverify128k.prg reuverify.asm
reuverify256k.prg: reuverify.asm
	acme -f cbm -DTESTSIZE=256 -o reuverify256k.prg reuverify.asm
reuverify512k.prg: reuverify.asm
	acme -f cbm -DTESTSIZE=512 -o reuverify512k.prg reuverify.asm
reuverify1m.prg: reuverify.asm
	acme -f cbm -DTESTSIZE=1024 -o reuverify1m.prg reuverify.asm
reuverify2m.prg: reuverify.asm
	acme -f cbm -DTESTSIZE=2048 -o reuverify2m.prg reuverify.asm
reuverify4m.prg: reuverify.asm
	acme -f cbm -DTESTSIZE=4096 -o reuverify4m.prg reuverify.asm
reuverify8m.prg: reuverify.asm
	acme -f cbm -DTESTSIZE=8192 -o reuverify8m.prg reuverify.asm
# it fails on 16MB
#reuverify16m.prg: reuverify.asm
#	acme -f cbm -DTESTSIZE=16384 -o reuverify16m.prg reuverify.asm

test128: reuverify.prg
	x64sc -reu -reusize 128 reuverify.prg
test256: reuverify.prg
	x64sc -reu -reusize 256 reuverify.prg
test512: reuverify.prg
	x64sc -reu -reusize 512 reuverify.prg
	
clean:
	$(RM) reuverify.prg
	$(RM) reuverify128k.prg
	$(RM) reuverify256k.prg
	$(RM) reuverify512k.prg
	$(RM) reuverify1m.prg
	$(RM) reuverify2m.prg
	$(RM) reuverify4m.prg
	$(RM) reuverify8m.prg
	$(RM) reuverify16m.prg

