
.SILENT:

PROGS=\
	cpujam02.prg \
	cpujam12.prg \
	cpujam22.prg \
	cpujam32.prg \
	cpujam42.prg \
	cpujam52.prg \
	cpujam62.prg \
	cpujam72.prg \
	cpujam92.prg \
	cpujamb2.prg \
	cpujamd2.prg \
	cpujamf2.prg \
	nojam.prg
all:
	cl65 --asm-define JAMCODE=2 -o cpujam02.prg cpujam.s
	cl65 --asm-define JAMCODE=18 -o cpujam12.prg cpujam.s
	cl65 --asm-define JAMCODE=34 -o cpujam22.prg cpujam.s
	cl65 --asm-define JAMCODE=50 -o cpujam32.prg cpujam.s
	cl65 --asm-define JAMCODE=66 -o cpujam42.prg cpujam.s
	cl65 --asm-define JAMCODE=82 -o cpujam52.prg cpujam.s
	cl65 --asm-define JAMCODE=98 -o cpujam62.prg cpujam.s
	cl65 --asm-define JAMCODE=114 -o cpujam72.prg cpujam.s
	cl65 --asm-define JAMCODE=146 -o cpujam92.prg cpujam.s
	cl65 --asm-define JAMCODE=178 -o cpujamb2.prg cpujam.s
	cl65 --asm-define JAMCODE=210 -o cpujamd2.prg cpujam.s
	cl65 --asm-define JAMCODE=242 -o cpujamf2.prg cpujam.s
	cl65 -o nojam.prg nojam.s
	rm -f *.o

	c1541 -format "cpujam,1" d64 cpujam.d64 > /dev/null
	for I in $(basename $(PROGS)); do \
		c1541 cpujam.d64 -write "$$I.prg" "$$I" > /dev/null; \
	done
	
clean:
	rm -f *~
	rm -f *.prg
	rm -f *.o
