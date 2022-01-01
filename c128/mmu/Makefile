
all: \
	mmuversion.prg \
	mmuswap-io-page.prg \
	mmuswap-normal-page.prg \
	mmuswap-page0-and-page1.prg \
	mmuswap-page0-only-page1.prg \
	mmuswap-page1-only-page0.prg \
	mmutest.prg \
	mmutest2.prg \
	mmuregister-should-not-mirror.prg \
	p0h-is-set-after-p0l.prg \
	p0h-rw-test.prg \
	p1h-is-set-after-p1l.prg \
	p1h-rw-test.prg


mmuversion.prg: mmuversion.asm
	acme -f cbm -o mmuversion.prg mmuversion.asm

mmuswap-io-page.prg: mmuswap-io-page.asm
	acme -f cbm -o mmuswap-io-page.prg mmuswap-io-page.asm

mmuswap-normal-page.prg: mmuswap-normal-page.asm
	acme -f cbm -o mmuswap-normal-page.prg mmuswap-normal-page.asm

mmuswap-page0-and-page1.prg: mmuswap-page0-and-page1.asm
	acme -f cbm -o mmuswap-page0-and-page1.prg mmuswap-page0-and-page1.asm

mmuswap-page0-only-page1.prg: mmuswap-page0-only-page1.asm
	acme -f cbm -o mmuswap-page0-only-page1.prg mmuswap-page0-only-page1.asm

mmuswap-page1-only-page0.prg: mmuswap-page1-only-page0.asm
	acme -f cbm -o mmuswap-page1-only-page0.prg mmuswap-page1-only-page0.asm

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
