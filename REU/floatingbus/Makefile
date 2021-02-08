
all: floating.prg

floating.prg: floating.asm
	acme -f cbm -o floating.prg floating.asm

test: floating.prg
	x64sc -reu -reusize 256 floating.prg
	
clean:
	$(RM) floating.prg
