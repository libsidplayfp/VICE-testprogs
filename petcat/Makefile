.SILENT:

#PETCAT=~/Desktop/vice/vice-emu/trunk/vice/src/petcat
PETCAT=petcat

all: test

# all valid basic v2 tokens in a "basic program"
tokensv2.prg: tokensv2.s
	acme tokensv2.s

# all character codes (0-255)
petscii.bin: petscii.s
	acme petscii.s

# all basic v2 keywords in a "basic program"
keywordsv2.prg: keywordsv2.s
	acme keywordsv2.s

.PHONY: test test1 test2 test3 test4 test5

test: test1 test2 test3 test4 test5
	
#verify that petscii -> ascii -> petscii produces consistant and reversible results
test1: petscii.bin
	@echo -----
	@echo test1 - full petscii range
# convert text from petscii to ascii
	$(PETCAT) -text -nh -c -o toasc.out petscii.bin
# convert text from ascii to petscii
	$(PETCAT) -text -w2 -c -o topet.out toasc.out
	diff  -q -s petscii.bin topet.out

# convert text from petscii to ascii (output ctrl codes as decimal)
	$(PETCAT) -text -nh -c -d -o toasc.out petscii.bin
# convert text from ascii to petscii
	$(PETCAT) -text -w2 -c -o topet.out toasc.out
	diff  -q -s petscii.bin topet.out

#verify that basic -> ascii -> basic produces consistant and reversible results
test2:
	@echo -----
	@echo test2 - real basic program that contains all characters
	$(PETCAT) -nh -c -o toasc.out pi.prg
	$(PETCAT) -w2 -c -o tobas.prg toasc.out
	diff  -q -s pi.prg tobas.prg

	$(PETCAT) -nh -c -d -o toasc.out pi.prg
	$(PETCAT) -w2 -c -o tobas.prg toasc.out
	diff  -q -s pi.prg tobas.prg

#verify that basic -> ascii -> basic produces consistant and reversible results
test3: tokensv2.prg
	@echo -----
	@echo test3 - synthetic test program
	$(PETCAT) -nh -c -o toasc.out tokensv2.prg
	$(PETCAT) -w2 -c -o tobas.prg toasc.out
	diff  -q -s tokensv2.prg tobas.prg

	$(PETCAT) -nh -c -o toasc.out tokensv2.prg
	$(PETCAT) -w2 -c -o tobas.prg toasc.out
	diff  -q -s tokensv2.prg tobas.prg

test4: ctrlcodes.bas
	@echo -----
	@echo ctrlcodes - check if various control codes work
	$(PETCAT) -w2 -o ctrlcodes.prg ctrlcodes.bas
	$(PETCAT) -nh -c -o toasc.out ctrlcodes.prg
	$(PETCAT) -w2 -c -o tobas.prg toasc.out
	diff  -q -s ctrlcodes.prg tobas.prg

#verify that basic -> ascii -> basic produces consistant and reversible results
test5: keywordsv2.prg
	@echo -----
	@echo test5 - basic v2 keywords test program
	$(PETCAT) -nh -2 -c -o toasc.out keywordsv2.prg
	$(PETCAT) -w2 -c -o tobas.prg toasc.out
	diff  -q -s keywordsv2.prg tobas.prg

clean:
	rm -f *~
	rm -f tokensv2.prg
	rm -f petscii.bin
	rm -f tobas.prg
	rm -f topet.out
	rm -f toasc.out
	rm -f ctrlcodes.prg
