
all: main.prg

main.prg: main.asm
	acme -f cbm -o main.prg main.asm
	
test: main.prg
	x64sc -default -sidstereo 1 -sidstereoaddress 0xd420 main.prg

