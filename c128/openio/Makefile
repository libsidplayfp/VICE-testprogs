
all: desterm.prg htst.prg

desterm.prg: desterm.asm
	acme -f cbm -o desterm.prg desterm.asm
htst.prg: htst.asm
	acme -f cbm -o htst.prg htst.asm

clean:
	$(RM) desterm.prg
	$(RM) htst.prg

