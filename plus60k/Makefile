all:	test.prg checkregister.prg

test.prg:	test.asm
	acme -v1 --cpu 6502 -f cbm -o test.prg test.asm

checkregister.prg: checkregister.asm
	acme -f cbm -o checkregister.prg checkregister.asm
