
all: crash.prg nocrash.prg

crash.prg: vdcbitmapscroll.asm
	64tass -DCRASH=1 -o crash.prg vdcbitmapscroll.asm
		
nocrash.prg: vdcbitmapscroll.asm
	64tass -DCRASH=0 -o nocrash.prg vdcbitmapscroll.asm
		
clean:
	$(RM) crash.prg nocrash.prg
