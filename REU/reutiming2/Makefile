
PROGS=a.prg a2.prg a3.prg a4.prg b.prg b2.prg b3.prg b4.prg b5.prg b6.prg \
	c.prg c2.prg c3.prg c4.prg d.prg d2.prg d3.prg d4.prg \
	e.prg e2.prg e3.prg e4.prg e5.prg e6.prg f.prg f2.prg f3.prg f4.prg \
	g.prg g2.prg g3.prg g4.prg \
	e-m2.prg e2-m2.prg e3-m2.prg e4-m2.prg e5-m2.prg e6-m2.prg f-m2.prg f2-m2.prg f3-m2.prg f4-m2.prg \
	g-m2.prg g2-m2.prg g3-m2.prg g4-m2.prg

all: $(PROGS)

a.prg: a.asm a.hpi
	64tass -DSPRITES=1 -DSWAP=0 --vice-labels --labels=$@.lbl -a $< -o $@
a2.prg: a.asm a.hpi
	64tass -DSPRITES=0 -DSWAP=0 --vice-labels --labels=$@.lbl -a $< -o $@
a3.prg: a.asm a.hpi
	64tass -DSPRITES=1 -DSWAP=1 --vice-labels --labels=$@.lbl -a $< -o $@
a4.prg: a.asm a.hpi
	64tass -DSPRITES=0 -DSWAP=1 --vice-labels --labels=$@.lbl -a $< -o $@

b.prg: b.asm
	64tass -DSPRITES=1 -DREVERSEORDER=0 -DSWAP=0 --vice-labels --labels=$@.lbl -a $< -o $@
b2.prg: b.asm
	64tass -DSPRITES=0 -DSWAP=0 --vice-labels --labels=$@.lbl -a $< -o $@
b3.prg: b.asm
	64tass -DSPRITES=1 -DREVERSEORDER=1 -DSWAP=0 --vice-labels --labels=$@.lbl -a $< -o $@
b4.prg: b.asm
	64tass -DSPRITES=1 -DREVERSEORDER=0 -DSWAP=1 --vice-labels --labels=$@.lbl -a $< -o $@
b5.prg: b.asm
	64tass -DSPRITES=0 -DSWAP=1 --vice-labels --labels=$@.lbl -a $< -o $@
b6.prg: b.asm
	64tass -DSPRITES=1 -DREVERSEORDER=1 -DSWAP=1 --vice-labels --labels=$@.lbl -a $< -o $@

c.prg: c.asm
	64tass -DSPRITES=0 -DTRANSFERBYTES=19 -DSWAP=0 --vice-labels --labels=$@.lbl -a $< -o $@
c2.prg: c.asm
	64tass -DSPRITES=0 -DTRANSFERBYTES=18 -DSWAP=0 --vice-labels --labels=$@.lbl -a $< -o $@
c3.prg: c.asm
	64tass -DSPRITES=0 -DTRANSFERBYTES=10 -DSWAP=1 --vice-labels --labels=$@.lbl -a $< -o $@
c4.prg: c.asm
	64tass -DSPRITES=0 -DTRANSFERBYTES=9 -DSWAP=1 --vice-labels --labels=$@.lbl -a $< -o $@

d.prg: d.asm
	64tass -DTRANSFERBYTES=12 -DSWAP=0 --vice-labels --labels=$@.lbl -a $< -o $@
d2.prg: d.asm
	64tass -DTRANSFERBYTES=11 -DSWAP=0 --vice-labels --labels=$@.lbl -a $< -o $@
d3.prg: d.asm
	64tass -DTRANSFERBYTES=6 -DSWAP=1 --vice-labels --labels=$@.lbl -a $< -o $@
d4.prg: d.asm
	64tass -DTRANSFERBYTES=5 -DSWAP=1 --vice-labels --labels=$@.lbl -a $< -o $@

e.prg: e.asm ref/e-ref.bin
	64tass -DIOGLITCH=1 -DSPRITES=1 -DREVERSEORDER=0 -DSWAP=0 --vice-labels --labels=$@.lbl -a $< -o $@
e2.prg: e.asm ref/e2-ref.bin
	64tass -DIOGLITCH=1 -DSPRITES=0 -DREVERSEORDER=0 -DSWAP=0 --vice-labels --labels=$@.lbl -a $< -o $@
e3.prg: e.asm ref/e3-ref.bin
	64tass -DIOGLITCH=1 -DSPRITES=1 -DREVERSEORDER=1 -DSWAP=0 --vice-labels --labels=$@.lbl -a $< -o $@
e4.prg: e.asm ref/e4-ref.bin
	64tass -DIOGLITCH=1 -DSPRITES=1 -DREVERSEORDER=0 -DSWAP=1 --vice-labels --labels=$@.lbl -a $< -o $@
e5.prg: e.asm ref/e5-ref.bin
	64tass -DIOGLITCH=1 -DSPRITES=0 -DREVERSEORDER=0 -DSWAP=1 --vice-labels --labels=$@.lbl -a $< -o $@
e6.prg: e.asm ref/e6-ref.bin
	64tass -DIOGLITCH=1 -DSPRITES=1 -DREVERSEORDER=1 -DSWAP=1 --vice-labels --labels=$@.lbl -a $< -o $@

f.prg: f.asm ref/f-ref.bin
	64tass -DIOGLITCH=1 -DSPRITES=0 -DTRANSFERBYTES=19 -DSWAP=0 --vice-labels --labels=$@.lbl -a $< -o $@
f2.prg: f.asm ref/f2-ref.bin
	64tass -DIOGLITCH=1 -DSPRITES=0 -DTRANSFERBYTES=18 -DSWAP=0 --vice-labels --labels=$@.lbl -a $< -o $@
f3.prg: f.asm ref/f3-ref.bin
	64tass -DIOGLITCH=1 -DSPRITES=0 -DTRANSFERBYTES=10 -DSWAP=1 --vice-labels --labels=$@.lbl -a $< -o $@
f4.prg: f.asm ref/f4-ref.bin
	64tass -DIOGLITCH=1 -DSPRITES=0 -DTRANSFERBYTES=9 -DSWAP=1 --vice-labels --labels=$@.lbl -a $< -o $@

g.prg: g.asm ref/g-ref.bin
	64tass -DIOGLITCH=1 -DSPRITES=0 -DTRANSFERBYTES=12 -DSWAP=0 --vice-labels --labels=$@.lbl -a $< -o $@
g2.prg: g.asm ref/g2-ref.bin
	64tass -DIOGLITCH=1 -DSPRITES=0 -DTRANSFERBYTES=11 -DSWAP=0 --vice-labels --labels=$@.lbl -a $< -o $@
g3.prg: g.asm ref/g3-ref.bin
	64tass -DIOGLITCH=1 -DSPRITES=0 -DTRANSFERBYTES=6 -DSWAP=1 --vice-labels --labels=$@.lbl -a $< -o $@
g4.prg: g.asm ref/g4-ref.bin
	64tass -DIOGLITCH=1 -DSPRITES=0 -DTRANSFERBYTES=5 -DSWAP=1 --vice-labels --labels=$@.lbl -a $< -o $@

e-m2.prg: e.asm ref/e-m2.bin
	64tass -DIOGLITCH=0 -DSPRITES=1 -DREVERSEORDER=0 -DSWAP=0 --vice-labels --labels=$@.lbl -a $< -o $@
e2-m2.prg: e.asm ref/e2-ref.bin
	64tass -DIOGLITCH=0 -DSPRITES=0 -DREVERSEORDER=0 -DSWAP=0 --vice-labels --labels=$@.lbl -a $< -o $@
e3-m2.prg: e.asm ref/e3-m2.bin
	64tass -DIOGLITCH=0 -DSPRITES=1 -DREVERSEORDER=1 -DSWAP=0 --vice-labels --labels=$@.lbl -a $< -o $@
e4-m2.prg: e.asm ref/e4-m2.bin
	64tass -DIOGLITCH=0 -DSPRITES=1 -DREVERSEORDER=0 -DSWAP=1 --vice-labels --labels=$@.lbl -a $< -o $@
e5-m2.prg: e.asm ref/e5-m2.bin
	64tass -DIOGLITCH=0 -DSPRITES=0 -DREVERSEORDER=0 -DSWAP=1 --vice-labels --labels=$@.lbl -a $< -o $@
e6-m2.prg: e.asm ref/e6-m2.bin
	64tass -DIOGLITCH=0 -DSPRITES=1 -DREVERSEORDER=1 -DSWAP=1 --vice-labels --labels=$@.lbl -a $< -o $@

f-m2.prg: f.asm ref/f-ref.bin
	64tass -DIOGLITCH=0 -DSPRITES=0 -DTRANSFERBYTES=19 -DSWAP=0 --vice-labels --labels=$@.lbl -a $< -o $@
f2-m2.prg: f.asm ref/f2-ref.bin
	64tass -DIOGLITCH=0 -DSPRITES=0 -DTRANSFERBYTES=18 -DSWAP=0 --vice-labels --labels=$@.lbl -a $< -o $@
f3-m2.prg: f.asm ref/f3-m2.bin
	64tass -DIOGLITCH=0 -DSPRITES=0 -DTRANSFERBYTES=10 -DSWAP=1 --vice-labels --labels=$@.lbl -a $< -o $@
f4-m2.prg: f.asm ref/f4-m2.bin
	64tass -DIOGLITCH=0 -DSPRITES=0 -DTRANSFERBYTES=9 -DSWAP=1 --vice-labels --labels=$@.lbl -a $< -o $@

g-m2.prg: g.asm ref/g-ref.bin
	64tass -DIOGLITCH=0 -DSPRITES=0 -DTRANSFERBYTES=12 -DSWAP=0 --vice-labels --labels=$@.lbl -a $< -o $@
g2-m2.prg: g.asm ref/g2-ref.bin
	64tass -DIOGLITCH=0 -DSPRITES=0 -DTRANSFERBYTES=11 -DSWAP=0 --vice-labels --labels=$@.lbl -a $< -o $@
g3-m2.prg: g.asm ref/g3-m2.bin
	64tass -DIOGLITCH=0 -DSPRITES=0 -DTRANSFERBYTES=6 -DSWAP=1 --vice-labels --labels=$@.lbl -a $< -o $@
g4-m2.prg: g.asm ref/g4-m2.bin
	64tass -DIOGLITCH=0 -DSPRITES=0 -DTRANSFERBYTES=5 -DSWAP=1 --vice-labels --labels=$@.lbl -a $< -o $@

testa:	a.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
testa2:	a2.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
testa3:	a3.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
testa4:	a4.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<

testb:	b.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
testb2:	b2.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
testb3:	b3.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
testb4:	b4.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
testb5:	b5.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
testb6:	b6.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<

testc:	c.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
testc2:	c2.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
testc3:	c3.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
testc4:	c4.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<

testd:	d.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
testd2:	d2.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
testd3:	d3.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
testd4:	d4.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<

teste:	e.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
teste2:	e2.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
teste3:	e3.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
teste4:	e4.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
teste5:	e5.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
teste6:	e6.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<

testf:	f.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
testf2:	f2.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
testf3:	f3.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
testf4:	f4.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<

testg:	g.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
testg2:	g2.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
testg3:	g3.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
testg4:	g4.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<

teste-m2:	e-m2.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
teste2-m2:	e2-m2.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
teste3-m2:	e3-m2.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
teste4-m2:	e4-m2.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
teste5-m2:	e5-m2.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
teste6-m2:	e6-m2.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<

testf-m2:	f-m2.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
testf2-m2:	f2-m2.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
testf3-m2:	f3-m2.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
testf4-m2:	f4-m2.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<

testg-m2:	g-m2.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
testg2-m2:	g2-m2.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
testg3-m2:	g3-m2.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<
testg4-m2:	g4-m2.prg
	x64sc -default -reu -reusize 512 -VICIIborders 2 -autostartprgmode 1 -moncommands $<.lbl $<

disk: $(PROGS)
	c1541 -format "reutiming,00" d64 reu.d64 \
		-write "a.prg" \
		-write "a2.prg" \
		-write "a3.prg" \
		-write "a4.prg" \
		-write "b.prg" \
		-write "b2.prg" \
		-write "b3.prg" \
		-write "b4.prg" \
		-write "b5.prg" \
		-write "b6.prg" \
		-write "c.prg" \
		-write "c2.prg" \
		-write "c3.prg" \
		-write "c4.prg" \
		-write "d.prg" \
		-write "d2.prg" \
		-write "d3.prg" \
		-write "d4.prg" \
		-write "e.prg" \
		-write "e2.prg" \
		-write "e3.prg" \
		-write "e4.prg" \
		-write "e5.prg" \
		-write "e6.prg" \
		-write "f.prg" \
		-write "f2.prg" \
		-write "f3.prg" \
		-write "f4.prg" \
		-write "g.prg" \
		-write "g2.prg" \
		-write "g3.prg" \
		-write "g4.prg" \
		-write "e-m2.prg" \
		-write "e2-m2.prg" \
		-write "e3-m2.prg" \
		-write "e4-m2.prg" \
		-write "e5-m2.prg" \
		-write "e6-m2.prg" \
		-write "f-m2.prg" \
		-write "f2-m2.prg" \
		-write "f3-m2.prg" \
		-write "f4-m2.prg" \
		-write "g-m2.prg" \
		-write "g2-m2.prg" \
		-write "g3-m2.prg" \
		-write "g4-m2.prg"
	
clean:
	$(RM) reu.d64
	$(RM) *.lbl
	$(RM) a.prg
	$(RM) a2.prg
	$(RM) a3.prg
	$(RM) a4.prg
	$(RM) b.prg
	$(RM) b2.prg
	$(RM) b3.prg
	$(RM) b4.prg
	$(RM) b5.prg
	$(RM) b6.prg
	$(RM) c.prg
	$(RM) c2.prg
	$(RM) c3.prg
	$(RM) c4.prg
	$(RM) d.prg
	$(RM) d2.prg
	$(RM) d3.prg
	$(RM) d4.prg
	$(RM) e.prg
	$(RM) e2.prg
	$(RM) e3.prg
	$(RM) e4.prg
	$(RM) e5.prg
	$(RM) e6.prg
	$(RM) f.prg
	$(RM) f2.prg
	$(RM) f3.prg
	$(RM) f4.prg
	$(RM) g.prg
	$(RM) g2.prg
	$(RM) g3.prg
	$(RM) g4.prg
	$(RM) e-m2.prg
	$(RM) e2-m2.prg
	$(RM) e3-m2.prg
	$(RM) e4-m2.prg
	$(RM) e5-m2.prg
	$(RM) e6-m2.prg
	$(RM) f-m2.prg
	$(RM) f2-m2.prg
	$(RM) f3-m2.prg
	$(RM) f4-m2.prg
	$(RM) g-m2.prg
	$(RM) g2-m2.prg
	$(RM) g3-m2.prg
	$(RM) g4-m2.prg
	
