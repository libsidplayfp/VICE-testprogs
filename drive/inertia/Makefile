
all: drive-emu-check.prg drive-emu-check.d64

drive-emu-check.prg: drive-emu-check.s
	64tass -o drive-emu-check.prg drive-emu-check.s

drive-emu-check.d64: drive-emu-check.prg
	c1541 -format "foo,00" d64 drive-emu-check.d64 \
		-write drive-emu-check.prg "drive-emu-check"
	
clean:
	$(RM) drive-emu-check.prg
	$(RM) drive-emu-check.d64
