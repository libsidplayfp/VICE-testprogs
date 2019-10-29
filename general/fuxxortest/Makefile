
all: test.prg \
	ef1-nmi.prg \
	ef2-inst1.prg \
	ef2-inst2.prg \
	ef2-inst3.prg \
	ef2-inst4a.prg \
	ef2-inst4b.prg \
	ef2-inst4c.prg

test.prg: test.bas
	petcat -w2 -o test.prg -- test.bas

ef1-nmi.prg: ef1-nmi.asm
	acme -f cbm -o ef1-nmi.prg ef1-nmi.asm
ef2-inst1.prg: ef2-inst1.asm
	acme -f cbm -o ef2-inst1.prg ef2-inst1.asm
ef2-inst2.prg: ef2-inst2.asm
	acme -f cbm -o ef2-inst2.prg ef2-inst2.asm
ef2-inst3.prg: ef2-inst3.asm
	acme -f cbm -o ef2-inst3.prg ef2-inst3.asm
ef2-inst4a.prg: ef2-inst4a.asm
	acme -f cbm -o ef2-inst4a.prg ef2-inst4a.asm
ef2-inst4b.prg: ef2-inst4b.asm
	acme -f cbm -o ef2-inst4b.prg ef2-inst4b.asm
ef2-inst4c.prg: ef2-inst4c.asm
	acme -f cbm -o ef2-inst4c.prg ef2-inst4c.asm
