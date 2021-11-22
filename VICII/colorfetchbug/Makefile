
all: main.prg main2.prg main3.prg

main.prg: main.asm
	acme --cpu 6510 -f cbm -o main.prg main.asm
main2.prg: main2.asm
	acme --cpu 6510 -f cbm -o main2.prg main2.asm
main3.prg: main3.asm
	acme --cpu 6510 -f cbm -o main3.prg main3.asm
	
test: main.prg
	x64sc -default main.prg
test2: main2.prg
	x64sc -default main2.prg
test3: main3.prg
	x64sc -default main3.prg

