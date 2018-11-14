
all: zerolevel1.prg zerolevel2.prg 

zerolevel1.prg: zerolevel1.asm
	acme -f cbm -o zerolevel1.prg zerolevel1.asm
zerolevel2.prg: zerolevel2.asm
	acme -f cbm -o zerolevel2.prg zerolevel2.asm

clean:
	rm -f zerolevel1.prg
	rm -f zerolevel2.prg

