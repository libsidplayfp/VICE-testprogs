
all: floating.prg floating-a.prg floating-b.prg floating2.prg floating3a.prg floating3b.prg

floating.prg: floating.asm
	acme -f cbm -DFIRSTREADVALID=0 -DFIRSTWRITEVALID=0 -o floating.prg floating.asm

floating-a.prg: floating.asm
	acme -f cbm -DFIRSTREADVALID=1 -DFIRSTWRITEVALID=0 -o floating-a.prg floating.asm

floating-b.prg: floating.asm
	acme -f cbm -DFIRSTREADVALID=0 -DFIRSTWRITEVALID=1 -o floating-b.prg floating.asm

floating2.prg: floating2.asm
	acme -f cbm -o floating2.prg floating2.asm

floating3a.prg: floating3.asm
	acme -f cbm -DTWOTIMERS=0 -o floating3a.prg floating3.asm
floating3b.prg: floating3.asm
	acme -f cbm -DTWOTIMERS=1 -o floating3b.prg floating3.asm

test: floating.prg
	x64sc -reu -reusize 256 floating.prg
testa: floating-a.prg
	x64sc -reu -reusize 256 floating-a.prg
testb: floating-b.prg
	x64sc -reu -reusize 256 floating-b.prg
	
test2: floating2.prg
	x64sc -reu -reusize 256 floating2.prg
	
test3a: floating3a.prg
	x64sc -reu -reusize 256 floating3a.prg
test3b: floating3b.prg
	x64sc -reu -reusize 256 floating3b.prg
	
clean:
	$(RM) floating.prg
	$(RM) floating-a.prg
	$(RM) floating-b.prg
	$(RM) floating2.prg
	$(RM) floating3a.prg
	$(RM) floating3b.prg
