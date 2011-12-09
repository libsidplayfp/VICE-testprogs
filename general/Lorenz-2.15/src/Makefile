
.SILENT:

# start.prg
DISK1PROGS =

DISK2PROGS = \
	shaay.prg \
	trap1.prg \
	trap2.prg \
	trap3.prg \
	trap4.prg \
	trap5.prg \
	trap6.prg \
	trap7.prg \
	trap8.prg \
	trap9.prg \
	trap10.prg \
	trap11.prg \
	trap12.prg \
	trap13.prg \
	trap14.prg \
	trap15.prg \
	trap16.prg \
	trap17.prg \
	cpuport.prg \
	irq.prg \
	icr01.prg \
	cia1ta.prg \
	cia1tb.prg

DISK3PROGS = \
	cia2ta.prg \
	cia2tb.prg \
	finish.prg \
	\
	template.prg

ALLPROGS = $(DISK1PROGS) $(DISK2PROGS) $(DISK3PROGS)
ALLDISKS = Disk1.d64 Disk2.d64 Disk3.d64
	
all: $(ALLPROGS) $(ALLDISKS)

trap1.prg: trap1-15.s
	64tass -p -C -D TRAP=1 -q -a -W -i trap1-15.s -o trap1.prg
trap2.prg: trap1-15.s
	64tass -p -C -D TRAP=2 -q -a -W -i trap1-15.s -o trap2.prg
trap3.prg: trap1-15.s
	64tass -p -C -D TRAP=3 -q -a -W -i trap1-15.s -o trap3.prg
trap4.prg: trap1-15.s
	64tass -p -C -D TRAP=4 -q -a -W -i trap1-15.s -o trap4.prg
trap5.prg: trap1-15.s
	64tass -p -C -D TRAP=5 -q -a -W -i trap1-15.s -o trap5.prg
trap6.prg: trap1-15.s
	64tass -p -C -D TRAP=6 -q -a -W -i trap1-15.s -o trap6.prg
trap7.prg: trap1-15.s
	64tass -p -C -D TRAP=7 -q -a -W -i trap1-15.s -o trap7.prg
trap8.prg: trap1-15.s
	64tass -p -C -D TRAP=8 -q -a -W -i trap1-15.s -o trap8.prg
trap9.prg: trap1-15.s
	64tass -p -C -D TRAP=9 -q -a -W -i trap1-15.s -o trap9.prg
trap10.prg: trap1-15.s
	64tass -p -C -D TRAP=10 -q -a -W -i trap1-15.s -o trap10.prg
trap11.prg: trap1-15.s
	64tass -p -C -D TRAP=11 -q -a -W -i trap1-15.s -o trap11.prg
trap12.prg: trap1-15.s
	64tass -p -C -D TRAP=12 -q -a -W -i trap1-15.s -o trap12.prg
trap13.prg: trap1-15.s
	64tass -p -C -D TRAP=13 -q -a -W -i trap1-15.s -o trap13.prg
trap14.prg: trap1-15.s
	64tass -p -C -D TRAP=14 -q -a -W -i trap1-15.s -o trap14.prg
trap15.prg: trap1-15.s
	64tass -p -C -D TRAP=15 -q -a -W -i trap1-15.s -o trap15.prg

%.prg : %.s
	64tass -p -C -q -a -W -i $*.s -o $*.prg
#	64tass -p -C -a -W -i $*.s -o $*.prg

Disk1.d64: $(DISK1PROGS)
	c1541 -format "test suite 2.15+,#1" d64 Disk1.d64 > /dev/null
	for I in $(basename $(DISK1PROGS)); do \
		c1541 Disk1.d64 -write "$$I.prg" "$$I" > /dev/null; \
	done
	c1541 Disk1.d64 -list
Disk2.d64: $(DISK2PROGS)
	c1541 -format "test suite 2.15+,#2" d64 Disk2.d64 > /dev/null
	for I in $(basename $(DISK2PROGS)); do \
		c1541 Disk2.d64 -write "$$I.prg" "$$I" > /dev/null; \
	done
	c1541 Disk2.d64 -list
Disk3.d64: $(DISK3PROGS)
	c1541 -format "test suite 2.15+,#3" d64 Disk3.d64 > /dev/null
	for I in $(basename $(DISK3PROGS)); do \
		c1541 Disk3.d64 -write "$$I.prg" "$$I" > /dev/null; \
	done
	c1541 Disk3.d64 -list

clean:
	rm -f *~

zap: clean
	rm -f *.prg
	rm -f *.d64
