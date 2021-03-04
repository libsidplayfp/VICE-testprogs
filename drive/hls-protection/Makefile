

all: hlstest.prg hlstest.g64

hlstest.prg: hlstest.asm
	64tass -a -o hlstest.prg hlstest.asm
	
hlstest.g64: hlstest.prg
	c1541 -attach hlstest.g64 \
		-delete "hlstest" \
		-write hlstest.prg hlstest
	
test: hlstest.prg hlstest.g64
	x64sc -default +virtualdev -truedrive -autostartprgmode 1 -8 hlstest.g64 hlstest.prg
	
clean:
	$(RM) hlstest.prg
