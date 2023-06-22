
all: toc64.prg toreu.prg

toc64.prg: toc64.asm
	acme -f cbm -o toc64.prg toc64.asm
toreu.prg: toreu.asm
	acme -f cbm -o toreu.prg toreu.asm

test1: toc64.prg
	x64sc -default -reu -autostartprgmode 1 toc64.prg
test2: toreu.prg
	x64sc -default -reu -autostartprgmode 1 toreu.prg
	
clean:
	$(RM) toc64.prg
	$(RM) toreu.prg
