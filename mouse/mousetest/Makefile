ASSEMBLER6502	= acme
AS_FLAGS	= -v2 -Wtype-mismatch
RM		= rm

PROGS		= mousetest64.prg mousetest128.prg
SRCS		= 1351.asm amiga_st.asm cx22.asm joystick.asm koala.asm mousetest.asm sprites.asm

all: $(PROGS)

mousetest64.prg: mt64.asm $(SRCS)
	$(ASSEMBLER6502) $(AS_FLAGS) --outfile mousetest64.prg --format cbm mt64.asm

mousetest128.prg: mt128.asm $(SRCS)
	$(ASSEMBLER6502) $(AS_FLAGS) --outfile mousetest128.prg --format cbm mt128.asm

clean:
	-$(RM) -f *.o *.tmp $(PROGS) *~ core
