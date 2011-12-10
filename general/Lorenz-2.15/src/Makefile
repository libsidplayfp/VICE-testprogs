
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

ASFLAGS=-C -P -O -p -a -W -q

all: $(ALLPROGS) $(ALLDISKS)

trap1.prg: trap1-15.s
	64tass $(ASFLAGS) -D TRAP=1 -i trap1-15.s -o trap1.prg
trap2.prg: trap1-15.s
	64tass $(ASFLAGS) -D TRAP=2 -i trap1-15.s -o trap2.prg
trap3.prg: trap1-15.s
	64tass $(ASFLAGS) -D TRAP=3 -i trap1-15.s -o trap3.prg
trap4.prg: trap1-15.s
	64tass $(ASFLAGS) -D TRAP=4 -i trap1-15.s -o trap4.prg
trap5.prg: trap1-15.s
	64tass $(ASFLAGS) -D TRAP=5 -i trap1-15.s -o trap5.prg
trap6.prg: trap1-15.s
	64tass $(ASFLAGS) -D TRAP=6 -i trap1-15.s -o trap6.prg
trap7.prg: trap1-15.s
	64tass $(ASFLAGS) -D TRAP=7 -i trap1-15.s -o trap7.prg
trap8.prg: trap1-15.s
	64tass $(ASFLAGS) -D TRAP=8 -i trap1-15.s -o trap8.prg
trap9.prg: trap1-15.s
	64tass $(ASFLAGS) -D TRAP=9 -i trap1-15.s -o trap9.prg
trap10.prg: trap1-15.s
	64tass $(ASFLAGS) -D TRAP=10 -i trap1-15.s -o trap10.prg
trap11.prg: trap1-15.s
	64tass $(ASFLAGS) -D TRAP=11 -i trap1-15.s -o trap11.prg
trap12.prg: trap1-15.s
	64tass $(ASFLAGS) -D TRAP=12 -i trap1-15.s -o trap12.prg
trap13.prg: trap1-15.s
	64tass $(ASFLAGS) -D TRAP=13 -i trap1-15.s -o trap13.prg
trap14.prg: trap1-15.s
	64tass $(ASFLAGS) -D TRAP=14 -i trap1-15.s -o trap14.prg
trap15.prg: trap1-15.s
	64tass $(ASFLAGS) -D TRAP=15 -i trap1-15.s -o trap15.prg

%.prg : %.s
	64tass $(ASFLAGS) -i $*.s -o $*.prg
#	64tass $(ASFLAGS) -i $*.s -o $*.prg

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
