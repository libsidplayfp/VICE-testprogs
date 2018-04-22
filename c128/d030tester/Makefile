

all: d030test.d64

d030test.d64: d030tester2.0.prg
	c1541 -format "d030tester,00" d64 d030test.d64 \
		-write d030tester2.0.prg d030tester2.0

d030tester2.0.prg: d030tester2.0.asm
	acme -f cbm -o d030tester2.0.prg d030tester2.0.asm
