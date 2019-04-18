

all: spritevssprite.prg

spritevssprite.prg: spritevssprite.asm
	cl65 -v -vm -t none -C spritevssprite.link spritevssprite.asm -o spritevssprite.prg
	
clean:
	$(RM) spritevssprite.prg
