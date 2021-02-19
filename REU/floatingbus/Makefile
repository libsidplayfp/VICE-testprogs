
all: floating.prg floating-a.prg floating-b.prg floating2.prg floating3a.prg floating3b.prg \
	floating4a.prg floating4b.prg floating4c.prg floating4d.prg

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

floating4a.prg: floating4.asm
	acme -f cbm  -DINCBANK=0 -DINITRAM=0 -o floating4a.prg floating4.asm
floating4b.prg: floating4.asm
	acme -f cbm  -DINCBANK=1 -DINITRAM=0 -o floating4b.prg floating4.asm
floating4c.prg: floating4.asm
	acme -f cbm  -DINCBANK=0 -DINITRAM=1 -o floating4c.prg floating4.asm
floating4d.prg: floating4.asm
	acme -f cbm  -DINCBANK=1 -DINITRAM=1 -o floating4d.prg floating4.asm

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
	
test4a: floating4a.prg
	x64sc -reu -reusize 256 floating4a.prg
test4b: floating4b.prg
	x64sc -reu -reusize 256 floating4b.prg
test4c: floating4c.prg
	x64sc -reu -reusize 256 floating4c.prg
test4d: floating4d.prg
	x64sc -reu -reusize 256 floating4d.prg
	
clean:
	$(RM) floating.prg
	$(RM) floating-a.prg
	$(RM) floating-b.prg
	$(RM) floating2.prg
	$(RM) floating3a.prg
	$(RM) floating3b.prg
	$(RM) floating4a.prg
	$(RM) floating4b.prg
	$(RM) floating4c.prg
	$(RM) floating4d.prg
