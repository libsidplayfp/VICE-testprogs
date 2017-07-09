
all: detect.prg 

detect.prg: detect.asm Makefile
	acme -f cbm -o detect.prg detect.asm

test: detect.prg
	x64sc -sfxse detect.prg

clean:
	rm -rf detect.prg
