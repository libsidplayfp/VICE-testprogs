.SILENT:

#PETCAT=~/Desktop/vice/vice-emu/trunk/vice/src/petcat
PETCAT=petcat

all: test

tokensv2.prg: tokensv2.s
	acme tokensv2.s
petscii.bin: petscii.s
	acme petscii.s

test: test1 test2 test3
	
test1: petscii.bin
	@echo -----
	@echo test1 - full petscii range
# convert text from petscii to ascii
	$(PETCAT) -text -nh -c petscii.bin > toasc.out
# convert text from ascii to petscii
	$(PETCAT) -text -w2 -c toasc.out > topet.out
	-diff  -q -s petscii.bin topet.out

test2:
	@echo -----
	@echo test2 - real basic program that contains all characters
	$(PETCAT) -nh -c pi.prg > toasc.out
	$(PETCAT) -w2 -c toasc.out > tobas.prg
	-diff  -q -s pi.prg tobas.prg

test3: tokensv2.prg
	@echo -----
	@echo test3 - synthetic test program
	$(PETCAT) -nh -c tokensv2.prg > toasc.out
	$(PETCAT) -w2 -c toasc.out > tobas.prg
	-diff  -q -s tokensv2.prg tobas.prg

clean:
	rm -f *~
	rm -f tokensv2.prg
	rm -f petscii.bin
	rm -f tobas.prg
	rm -f topet.out
	rm -f toasc.out
