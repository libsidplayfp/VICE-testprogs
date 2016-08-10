
all: detect.prg detect-1-old.prg detect-1-new.prg detect-2-old.prg detect-2-new.prg

detect.prg: main.asm
	acme -f cbm -DSIDTYPE=0 -DCHECKTYPE=0 -DINTERACTIVE=1 -o detect.prg main.asm
detect-1-old.prg: main.asm
	acme -f cbm -DSIDTYPE=0 -DCHECKTYPE=0 -DINTERACTIVE=0 -o detect-1-old.prg main.asm
detect-1-new.prg: main.asm
	acme -f cbm -DSIDTYPE=1 -DCHECKTYPE=0 -DINTERACTIVE=0 -o detect-1-new.prg main.asm
detect-2-old.prg: main.asm
	acme -f cbm -DSIDTYPE=0 -DCHECKTYPE=1 -DINTERACTIVE=0 -o detect-2-old.prg main.asm
detect-2-new.prg: main.asm
	acme -f cbm -DSIDTYPE=1 -DCHECKTYPE=1 -DINTERACTIVE=0 -o detect-2-new.prg main.asm
