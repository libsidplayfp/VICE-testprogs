
all: a.prg a2.prg b.prg b2.prg b3.prg c.prg

a.prg: a.asm a.hpi
	64tass -DSPRITES=1 -a -B $< -o $@
a2.prg: a.asm a.hpi
	64tass -DSPRITES=0 -a -B $< -o $@
b.prg: b.asm
	64tass -DSPRITES=1 -DREVERSEORDER=0 -a -B $< -o $@
b2.prg: b.asm
	64tass -DSPRITES=0 -a -B $< -o $@
b3.prg: b.asm
	64tass -DSPRITES=1 -DREVERSEORDER=1 -a -B $< -o $@
c.prg: c.asm
	64tass -a -B $< -o $@


testa:	a.prg
	x64sc -default -reu -reusize 512 a.prg
testa2:	a2.prg
	x64sc -default -reu -reusize 512 a2.prg
testb:	b.prg
	x64sc -default -reu -reusize 512 b.prg
testb2:	b2.prg
	x64sc -default -reu -reusize 512 b2.prg
testb3:	b3.prg
	x64sc -default -reu -reusize 512 b3.prg
testc:	c.prg
	x64sc -default -reu -reusize 512 c.prg

clean:
	$(RM) a.prg
	$(RM) a2.prg
	$(RM) b.prg
	$(RM) b2.prg
	$(RM) b3.prg
	$(RM) c.prg
	
