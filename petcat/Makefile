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

# all basic v2 + Ultra Basic 64 keywords in a "basic program"
keywordsv2ultra64.prg: keywordsv2ultra64.s
	acme keywordsv2ultra64.s

# all basic v2 + Graphics Basic keywords in a "basic program"
keywordsv2graph.prg: keywordsv2graph.s
	acme keywordsv2graph.s

# all basic v2 + WS Basic keywords in a "basic program"
keywordsv2ws.prg: keywordsv2ws.s
	acme keywordsv2ws.s

# all basic v2 + WS Basic Final keywords in a "basic program"
keywordsv2wsf.prg: keywordsv2wsf.s
	acme keywordsv2wsf.s

# all basic v2 + Turtle Basic keywords in a "basic program"
keywordsv2turtle.prg: keywordsv2turtle.s
	acme keywordsv2turtle.s

# all basic v2 + Mighty Basic keywords in a "basic program"
keywordsv2mighty.prg: keywordsv2mighty.s
	acme keywordsv2mighty.s

# all basic v2 + Pegasus Basic 4.0 keywords in a "basic program"
keywordsv2peg40.prg: keywordsv2peg40.s
	acme keywordsv2peg40.s

# all basic v2 + Xbasic keywords in a "basic program"
keywordsv2xbas.prg: keywordsv2xbas.s
	acme keywordsv2xbas.s

# all basic v2 + Drago Basic v2.2 keywords in a "basic program"
keywordsv2drago.prg: keywordsv2drago.s
	acme keywordsv2drago.s

# all basic v2 + REU Basic keywords in a "basic program"
keywordsv2reu.prg: keywordsv2reu.s
	acme keywordsv2reu.s

# all basic v2 + Basic Lightning keywords in a "basic program"
keywordsv2lightning.prg: keywordsv2lightning.s
	acme keywordsv2lightning.s

# all basic v2 + Magic Basic keywords in a "basic program"
keywordsv2magic.prg: keywordsv2magic.s
	acme keywordsv2magic.s

# all basic v2 + Easy Basic keywords in a "basic program"
keywordsv2easy.prg: keywordsv2easy.s
	acme keywordsv2easy.s

# all basic v2 + Blarg keywords in a "basic program"
keywordsv2blarg.prg: keywordsv2blarg.s
	acme keywordsv2blarg.s

# all basic v2 + Game Basic keywords in a "basic program"
keywordsv2game.prg: keywordsv2game.s
	acme keywordsv2game.s

# all basic v2 + Super Basic keywords in a "basic program"
keywordsv2superbas.prg: keywordsv2superbas.s
	acme keywordsv2superbas.s

# all basic v2 + Expanded Basic 20 keywords in a "basic program"
keywordsv2exp20.prg: keywordsv2exp20.s
	acme keywordsv2exp20.s

# all basic v2 + Expanded Basic 64 keywords in a "basic program"
keywordsv2exp64.prg: keywordsv2exp64.s
	acme keywordsv2exp64.s

# all basic v2 + Super Expander Chip keywords in a "basic program"
keywordsv2sxc.prg: keywordsv2sxc.s
	acme keywordsv2sxc.s

.PHONY: test test1 test2 test3 test4 test5 test6 test7 test8 test9 test10 \
	test11 test12 test13 test14 test15 test16 test17 test18 test19 test20 \
	test21 test22 test23 test24 test25 test26 test27 test28 test29

test:	test1 test2 test3 test4 test5 test6 test7 test8 test9 test10 \
	test11 test12 test13 test14 test15 test16 test17 test18 test19 test20 \
	test21 test22 test23 test24 test25 test26 test27 test28 test29

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

test11: keywordsv2ultra64.prg
	@echo -----
	@echo test11 - basic v2 + Ultra Basic 64 keywords test program
	$(PETCAT) -nh -ultra -c -o toasc.out keywordsv2ultra64.prg
	$(PETCAT) -wultra -c -o tobas.prg toasc.out
	diff  -q -s keywordsv2ultra64.prg tobas.prg

test12: keywordsv2graph.prg
	@echo -----
	@echo test12 - basic v2 + Graphics Basic keywords test program
	$(PETCAT) -nh -graph -c -o toasc.out keywordsv2graph.prg
	$(PETCAT) -wgraph -c -o tobas.prg toasc.out
	diff  -q -s keywordsv2graph.prg tobas.prg

test13: keywordsv2ws.prg
	@echo -----
	@echo test13 - basic v2 + WS Basic keywords test program
	$(PETCAT) -nh -bws -c -o toasc.out keywordsv2ws.prg
	$(PETCAT) -wbws -c -o tobas.prg toasc.out
	diff  -q -s keywordsv2ws.prg tobas.prg

test14: keywordsv2wsf.prg
	@echo -----
	@echo test14 - basic v2 + WS Basic Final keywords test program
	$(PETCAT) -nh -bwsf -c -o toasc.out keywordsv2wsf.prg
	$(PETCAT) -wbwsf -c -o tobas.prg toasc.out
	diff  -q -s keywordsv2wsf.prg tobas.prg

test15: keywordsv2turtle.prg
	@echo -----
	@echo test15 - basic v2 + Turtle Basic keywords test program
	$(PETCAT) -nh -turtle -c -o toasc.out keywordsv2turtle.prg
	$(PETCAT) -wturtle -c -o tobas.prg toasc.out
	diff  -q -s keywordsv2turtle.prg tobas.prg

test16: keywordsv2mighty.prg
	@echo -----
	@echo test16 - basic v2 + Mighty Basic keywords test program
	$(PETCAT) -nh -mighty -c -o toasc.out keywordsv2mighty.prg
	$(PETCAT) -wmighty -c -o tobas.prg toasc.out
	diff  -q -s keywordsv2mighty.prg tobas.prg

test17: keywordsv2peg40.prg
	@echo -----
	@echo test17 - basic v2 + Pegasus Basic 4.0 keywords test program
	$(PETCAT) -nh -pegasus -c -o toasc.out keywordsv2peg40.prg
	$(PETCAT) -wpegasus -c -o tobas.prg toasc.out
	diff  -q -s keywordsv2peg40.prg tobas.prg

test18: keywordsv2xbas.prg
	@echo -----
	@echo test18 - basic v2 + Xbasic keywords test program
	$(PETCAT) -nh -xbasic -c -o toasc.out keywordsv2xbas.prg
	$(PETCAT) -wxbasic -c -o tobas.prg toasc.out
	diff  -q -s keywordsv2xbas.prg tobas.prg

test19: keywordsv2drago.prg
	@echo -----
	@echo test19 - basic v2 + Drago Basic v2.2 keywords test program
	$(PETCAT) -nh -drago -c -o toasc.out keywordsv2drago.prg
	$(PETCAT) -wdrago -c -o tobas.prg toasc.out
	diff  -q -s keywordsv2drago.prg tobas.prg

test20: keywordsv2reu.prg
	@echo -----
	@echo test20 - basic v2 + REU Basic keywords test program
	$(PETCAT) -nh -reu -c -o toasc.out keywordsv2reu.prg
	$(PETCAT) -wreu -c -o tobas.prg toasc.out
	diff  -q -s keywordsv2reu.prg tobas.prg

test21: keywordsv2lightning.prg
	@echo -----
	@echo test21 - basic v2 + Basic Lightning keywords test program
	$(PETCAT) -nh -lightning -c -o toasc.out keywordsv2lightning.prg
	$(PETCAT) -wlightning -c -o tobas.prg toasc.out
	diff  -q -s keywordsv2lightning.prg tobas.prg

test22: keywordsv2magic.prg
	@echo -----
	@echo test22 - basic v2 + Magic Basic keywords test program
	$(PETCAT) -nh -magic -c -o toasc.out keywordsv2magic.prg
	$(PETCAT) -wmagic -c -o tobas.prg toasc.out
	diff  -q -s keywordsv2magic.prg tobas.prg

test23: keywordsv2easy.prg
	@echo -----
	@echo test23 - basic v2 + Easy Basic keywords test program
	$(PETCAT) -nh -easy -c -o toasc.out keywordsv2easy.prg
	$(PETCAT) -weasy -c -o tobas.prg toasc.out
	diff  -q -s keywordsv2easy.prg tobas.prg

test24: keywordsv2blarg.prg
	@echo -----
	@echo test24 - basic v2 + Blarg keywords test program
	$(PETCAT) -nh -blarg -c -o toasc.out keywordsv2blarg.prg
	$(PETCAT) -wblarg -c -o tobas.prg toasc.out
	diff  -q -s keywordsv2blarg.prg tobas.prg

test25: keywordsv2game.prg
	@echo -----
	@echo test25 - basic v2 + Game Basic keywords test program
	$(PETCAT) -nh -game -c -o toasc.out keywordsv2game.prg
	$(PETCAT) -wgame -c -o tobas.prg toasc.out
	diff  -q -s keywordsv2game.prg tobas.prg

test26: keywordsv2superbas.prg
	@echo -----
	@echo test26 - basic v2 + Super Basic keywords test program
	$(PETCAT) -nh -superbas -c -o toasc.out keywordsv2superbas.prg
	$(PETCAT) -wsuperbas -c -o tobas.prg toasc.out
	diff  -q -s keywordsv2superbas.prg tobas.prg

test27: keywordsv2exp20.prg
	@echo -----
	@echo test27 - basic v2 + Expanded Basic 20 keywords test program
	$(PETCAT) -nh -exp20 -o toasc.out keywordsv2exp20.prg
	$(PETCAT) -wexp20 -c -o tobas.prg toasc.out
	diff  -q -s keywordsv2exp20.prg tobas.prg

test28: keywordsv2exp64.prg
	@echo -----
	@echo test28 - basic v2 + Expanded Basic 64 keywords test program
	$(PETCAT) -nh -exp64 -o toasc.out keywordsv2exp64.prg
	$(PETCAT) -wexp64 -c -o tobas.prg toasc.out
	diff  -q -s keywordsv2exp64.prg tobas.prg

test29: keywordsv2sxc.prg
	@echo -----
	@echo test29 - basic v2 + Super Expander Chip keywords test program
	$(PETCAT) -nh -sxc -o toasc.out keywordsv2sxc.prg
	$(PETCAT) -wsxc -c -o tobas.prg toasc.out
	diff  -q -s keywordsv2sxc.prg tobas.prg

clean:
	rm -f *~
	rm -f tokensv2*.prg
	rm -f petscii.bin
	rm -f tobas.prg
	rm -f topet.out
	rm -f toasc.out
	rm -f ctrlcodes.prg
