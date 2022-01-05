
all: \
	mmuversion.prg \
	mmuswap-00.prg \
	mmuswap-01.prg \
	mmuswap-02.prg \
	mmuswap-03.prg \
	mmuswap-04.prg \
	mmuswap-05.prg \
	mmuswap-06.prg \
	mmuswap-07.prg \
	mmuswap-08.prg \
	mmuswap-09.prg \
	mmuswap-10.prg \
	mmutest.prg \
	mmutest2.prg \
	mmuregister-should-not-mirror.prg \
	p0h-is-set-after-p0l.prg \
	p0h-rw-test.prg \
	p1h-is-set-after-p1l.prg \
	p1h-rw-test.prg

mmuversion.prg: mmuversion.asm
	acme -f cbm -o mmuversion.prg mmuversion.asm

mmuswap-00.prg: mmuswap-00.asm
	acme -f cbm -o mmuswap-00.prg mmuswap-00.asm

mmuswap-01.prg: mmuswap-01.asm
	acme -f cbm -o mmuswap-01.prg mmuswap-01.asm

mmuswap-02.prg: mmuswap-02.asm
	acme -f cbm -o mmuswap-02.prg mmuswap-02.asm

mmuswap-03.prg: mmuswap-03.asm
	acme -f cbm -o mmuswap-03.prg mmuswap-03.asm

mmuswap-04.prg: mmuswap-04.asm
	acme -f cbm -o mmuswap-04.prg mmuswap-04.asm

mmuswap-05.prg: mmuswap-05.asm
	acme -f cbm -o mmuswap-05.prg mmuswap-05.asm

mmuswap-06.prg: mmuswap-06.asm
	acme -f cbm -o mmuswap-06.prg mmuswap-06.asm

mmuswap-07.prg: mmuswap-07.asm
	acme -f cbm -o mmuswap-07.prg mmuswap-07.asm

mmuswap-08.prg: mmuswap-08.asm
	acme -f cbm -o mmuswap-08.prg mmuswap-08.asm

mmuswap-09.prg: mmuswap-09.asm
	acme -f cbm -o mmuswap-09.prg mmuswap-09.asm

mmuswap-10.prg: mmuswap-10.asm
	acme -f cbm -o mmuswap-10.prg mmuswap-10.asm

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
