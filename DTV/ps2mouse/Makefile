
all: blocks2.prg pointer2.prg

blocks2.prg: blocks2.asm
	64tass -o blocks2.prg blocks2.asm

pointer2.prg: pointer2.asm
	64tass -o pointer2.prg pointer2.asm
	
clean:
	$(RM) blocks2.prg
	$(RM) pointer2.prg
