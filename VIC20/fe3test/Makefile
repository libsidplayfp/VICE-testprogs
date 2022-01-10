
all: fetest.prg

fetest.prg: fetest.asm
	dasm fetest.asm -ofetest.prg
	
test: fetest.prg
	xvic -default -memory 8k fetest.prg
	
clean:
	$(RM) fetest.prg
