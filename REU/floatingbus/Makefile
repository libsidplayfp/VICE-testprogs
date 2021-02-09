
all: floating.prg floating2.prg

floating.prg: floating.asm
	acme -f cbm -o floating.prg floating.asm

floating2.prg: floating2.asm
	acme -f cbm -o floating2.prg floating2.asm

test: floating.prg
	x64sc -reu -reusize 256 floating.prg
	
test2: floating2.prg
	x64sc -reu -reusize 256 floating2.prg
	
clean:
	$(RM) floating.prg
	$(RM) floating2.prg
