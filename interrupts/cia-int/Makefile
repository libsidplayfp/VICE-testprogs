# Makefile

all:	cia-int-irq.prg cia-int-nmi.prg

cia-int-irq.prg: cia-int.asm
	dasm $< -o$@ -DTEST_IRQ

cia-int-nmi.prg: cia-int.asm
	dasm $< -o$@ -DTEST_NMI

clean:
	rm -f *~ \#*\#
	rm -f a.out
	rm -f cia-int-irq.prg cia-int-nmi.prg

# eof
