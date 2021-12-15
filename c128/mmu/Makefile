
all: \
	mmuversion.prg \
	mmuswaptest.prg \
	mmutest.prg \
	mmutest2.prg \
	mmuregister-should-not-mirror.prg \
	p0h-is-set-after-p0l.prg \
	p0h-rw-test.prg \
	p1h-is-set-after-p1l.prg \
	p1h-rw-test.prg


mmuversion.prg: mmuversion.asm
	acme -f cbm -o mmuversion.prg mmuversion.asm

mmuswaptest.prg: mmuswaptest.asm
	acme -f cbm -o mmuswaptest.prg mmuswaptest.asm

mmutest.prg: mmutest.asm
	acme -f cbm -o mmutest.prg mmutest.asm

mmutest2.prg: mmutest2.asm
	acme -f cbm -o mmutest2.prg mmutest2.asm

mmuregister-should-not-mirror.prg: mmuregister-should-not-mirror.asm
	acme -f cbm -o mmuregister-should-not-mirror.prg mmuregister-should-not-mirror.asm

p0h-is-set-after-p0l.prg: p0h-is-set-after-p0l.asm
	acme -f cbm -o p0h-is-set-after-p0l.prg p0h-is-set-after-p0l.asm

p0h-rw-test.prg: p0h-rw-test.asm
	acme -f cbm -o p0h-rw-test.prg p0h-rw-test.asm
	
p1h-is-set-after-p1l.prg: p1h-is-set-after-p1l.asm
	acme -f cbm -o p1h-is-set-after-p1l.prg p1h-is-set-after-p1l.asm

p1h-rw-test.prg: p1h-rw-test.asm
	acme -f cbm -o p1h-rw-test.prg p1h-rw-test.asm
	
clean:
	rm -f mmuversion.prg mmutest2.prg mmutest.prg mmuregister-should-not-mirror.prg
	rm -f p0h-is-set-after-p0l.prg p0h-rw-test.prg
	rm -f p1h-is-set-after-p1l.prg p1h-rw-test.prg
