ASSEMBLER6502	= acme
AS_FLAGS	= -v2 -Wtype-mismatch
RM		= rm

PROGS		= mousetest.prg
SRCS		= 1351.asm amiga_st.asm cx22.asm joystick.asm koala.asm mousetest.asm sprites.asm

all: $(PROGS)

mousetest.prg: $(SRCS)
	$(ASSEMBLER6502) $(AS_FLAGS) --outfile mousetest.prg --format cbm mousetest.asm

clean:
	-$(RM) -f *.o *.tmp $(PROGS) *~ core
