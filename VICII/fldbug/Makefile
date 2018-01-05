#.SILENT:

all: fld0.prg fld1.prg

fld0.prg: main.asm
	acme -DVERSION=0 -f cbm -o fld0.prg main.asm
	
fld1.prg: main.asm
	acme -DVERSION=1 -f cbm -o fld1.prg main.asm
	
clean:
	$(RM) fld0.prg fld1.prg

