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

# all basic v1 keywords in a "basic program"
keywordsv1.prg: keywordsv1.s
	acme keywordsv1.s

# all basic v2 keywords in a "basic program"
keywordsv2.prg: keywordsv2.s
	acme keywordsv2.s

# all basic v2 + Super Expander keywords in a "basic program"
keywordsv2superexp.prg: keywordsv2superexp.s
	acme keywordsv2superexp.s

# all basic v2 + Speech Basic v2.7 keywords in a "basic program"
keywordsv2speech.prg: keywordsv2speech.s
	acme keywordsv2speech.s

# all basic v2 + at Basic keywords in a "basic program"
keywordsv2at.prg: keywordsv2at.s
	acme keywordsv2at.s

# all basic v2 + FC3 keywords in a "basic program"
keywordsv2fc3.prg: keywordsv2fc3.s
	acme keywordsv2fc3.s

.PHONY: test test1 test2 test3 test4 test5 test6 test7 test8 test9 test10

test: test1 test2 test3 test4 test5 test6 test7 test8 test9 test10
	
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
test5: keywordsv1.prg
	@echo -----
	@echo test5 - basic v1 keywords test program
	$(PETCAT) -nh -1 -c -o toasc.out keywordsv1.prg
	$(PETCAT) -w1 -c -o tobas.prg toasc.out
	diff  -q -s keywordsv1.prg tobas.prg

#verify that basic -> ascii -> basic produces consistant and reversible results
test6: keywordsv2.prg
	@echo -----
	@echo test6 - basic v2 keywords test program
	$(PETCAT) -nh -2 -c -o toasc.out keywordsv2.prg
	$(PETCAT) -w2 -c -o tobas.prg toasc.out
	diff  -q -s keywordsv2.prg tobas.prg

test7: keywordsv2superexp.prg
	@echo -----
	@echo test7 - basic v2 + Super Expander keywords test program
	$(PETCAT) -nh -superexp -c -o toasc.out keywordsv2superexp.prg
	$(PETCAT) -wsuperexp -c -o tobas.prg toasc.out
	diff  -q -s keywordsv2superexp.prg tobas.prg

test8: keywordsv2speech.prg
	@echo -----
	@echo test8 - basic v2 + Speech Basic v2.7 keywords test program
	$(PETCAT) -nh -speech -c -o toasc.out keywordsv2speech.prg
	$(PETCAT) -wspeech -c -o tobas.prg toasc.out
	diff  -q -s keywordsv2speech.prg tobas.prg

test9: keywordsv2at.prg
	@echo -----
	@echo test9 - basic v2 + at Basic keywords test program
	$(PETCAT) -nh -at -c -o toasc.out keywordsv2at.prg
	$(PETCAT) -wat -c -o tobas.prg toasc.out
	diff  -q -s keywordsv2at.prg tobas.prg

test10: keywordsv2fc3.prg
	@echo -----
	@echo test10 - basic v2 + FC3 keywords test program
	$(PETCAT) -nh -fc3 -c -o toasc.out keywordsv2fc3.prg
	$(PETCAT) -wfc3 -c -o tobas.prg toasc.out
	diff  -q -s keywordsv2fc3.prg tobas.prg

clean:
	rm -f *~
	rm -f tokensv2.prg
	rm -f petscii.bin
	rm -f tobas.prg
	rm -f topet.out
	rm -f toasc.out
	rm -f ctrlcodes.prg
