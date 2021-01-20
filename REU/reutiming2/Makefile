
all: a.prg b.prg b2.prg

a.prg: a.asm a.hpi
	64tass -DSPRITES=1 -a -B $< -o $@
a2.prg: a.asm a.hpi
	64tass -DSPRITES=0 -a -B $< -o $@
b.prg: b.asm
	64tass -DSPRITES=1 -a -B $< -o $@
b2.prg: b.asm
	64tass -DSPRITES=0 -a -B $< -o $@


testa:	a.prg
	x64sc -default -reu -reusize 512 a.prg
testa2:	a2.prg
	x64sc -default -reu -reusize 512 a2.prg
testb:	b.prg
	x64sc -default -reu -reusize 512 b.prg
testb2:	b2.prg
	x64sc -default -reu -reusize 512 b2.prg

clean:
	$(RM) a.prg
	$(RM) b.prg
	$(RM) b2.prg
	
