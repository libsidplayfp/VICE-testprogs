
all: 2mhz-vic-hires.prg 2mhz-vic-multicolor.prg \
	timing-change0.prg timing-change1.prg

2mhz-vic-hires.prg: 2mhz-vic-hires.asm
	acme -f cbm -o 2mhz-vic-hires.prg 2mhz-vic-hires.asm
2mhz-vic-multicolor.prg: 2mhz-vic-multicolor.asm
	acme -f cbm -o 2mhz-vic-multicolor.prg 2mhz-vic-multicolor.asm
timing-change0.prg: timing-change0.asm
	acme -f cbm -o timing-change0.prg timing-change0.asm
timing-change1.prg: timing-change1.asm
	acme -f cbm -o timing-change1.prg timing-change1.asm

clean:
	rm -f 2mhz-vic-hires.prg 2mhz-vic-multicolor.prg
	rm -f timing-change0.prg timing-change1.prg
