
all: mmutest.prg mmuregister-should-not-mirror.prg 


mmutest.prg: mmutest.asm
	acme -f cbm -o mmutest.prg mmutest.asm

mmuregister-should-not-mirror.prg: mmuregister-should-not-mirror.asm
	acme -f cbm -o mmuregister-should-not-mirror.prg mmuregister-should-not-mirror.asm

clean:
	rm -f mmutest.prg mmuregister-should-not-mirror.prg
