
all: mirrors.prg

mirrors.prg: mirrors.asm
	acme -f cbm -o mirrors.prg mirrors.asm

test128: mirrors.prg
	x64sc -reu -reusize 128 mirrors.prg
test256: mirrors.prg
	x64sc -reu -reusize 256 mirrors.prg
test512: mirrors.prg
	x64sc -reu -reusize 512 mirrors.prg
test1024: mirrors.prg
	x64sc -reu -reusize 1024 mirrors.prg
test2048: mirrors.prg
	x64sc -reu -reusize 2048 mirrors.prg
test16384: mirrors.prg
	x64sc -reu -reusize 16384 mirrors.prg
	
clean:
	$(RM) mirrors.prg
