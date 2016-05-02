
all: pattern00ff.prg platoontest.prg darkstarbbstest.prg cyberloadtest.prg typicaltest.prg

pattern00ff.prg: pattern00ff.asm
	acme -f cbm -o pattern00ff.prg pattern00ff.asm
platoontest.prg: platoontest.asm
	acme -f cbm -o platoontest.prg platoontest.asm
darkstarbbstest.prg: darkstarbbstest.asm
	acme -f cbm -o darkstarbbstest.prg darkstarbbstest.asm
typicaltest.prg: typicaltest.asm
	acme -f cbm -o typicaltest.prg typicaltest.asm
cyberloadtest.prg: cyberloadtest.asm
	acme -f cbm -o cyberloadtest.prg cyberloadtest.asm

clean:
	rm -f pattern00ff.prg
	rm -f platoontest.prg
	rm -f darkstarbbstest.prg
	rm -f typicaltest.prg
	rm -f cyberloadtest.prg
