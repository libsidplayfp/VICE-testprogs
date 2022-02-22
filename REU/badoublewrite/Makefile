
all: badoublewrite.prg

badoublewrite.prg: badoublewrite.asm
	acme -f cbm -o badoublewrite.prg badoublewrite.asm
	
test: badoublewrite.prg
	x64sc -default -reu -VICIIborder 2 badoublewrite.prg
	
clean:
	$(RM) badoublewrite.prg
