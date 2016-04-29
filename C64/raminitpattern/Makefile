
all: pattern00ff.prg platoontest.prg darkstarbbstest.prg

pattern00ff.prg: pattern00ff.asm
	acme -f cbm -o pattern00ff.prg pattern00ff.asm
platoontest.prg: platoontest.asm
	acme -f cbm -o platoontest.prg platoontest.asm
darkstarbbstest.prg: darkstarbbstest.asm
	acme -f cbm -o darkstarbbstest.prg darkstarbbstest.asm

clean:
	rm -f pattern00ff.prg
	rm -f platoontest.prg
	rm -f darkstarbbstest.prg
