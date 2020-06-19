
TESTS=\
        cia1-sdr-icr-4.prg \
        cia1-sdr-icr-5.prg \
        cia1-sdr-icr-6.prg \
        cia1-sdr-icr-7.prg \
        cia1-sdr-icr-8.prg \
        cia1-sdr-icr-50.prg \
        cia1-sdr-icr-51.prg \
        cia1-sdr-icr-64.prg \
        cia1-sdr-icr-4485-7.prg \
        cia1-sdr-icr-4485-8.prg \
        cia1-sdr-icr-4485-50.prg \
        cia1-sdr-icr-4485-51.prg \
        cia1-sdr-icr-4485-64.prg \
        \
        cia2-sdr-icr-4.prg \
        cia2-sdr-icr-5.prg \
        cia2-sdr-icr-6.prg \
        cia2-sdr-icr-7.prg \
        cia2-sdr-icr-8.prg \
        cia2-sdr-icr-50.prg \
        cia2-sdr-icr-51.prg \
        cia2-sdr-icr-64.prg \
        cia2-sdr-icr-4485-7.prg \
        cia2-sdr-icr-4485-8.prg \
        cia2-sdr-icr-4485-50.prg \
        cia2-sdr-icr-4485-51.prg \
        cia2-sdr-icr-4485-64.prg

all: $(TESTS)

cia1-sdr-icr-4.prg: cia-sdr-icr.asm
	acme -f cbm -DCIA=1 -DCIATYPE=1 -DBAUDRATE=4 -o cia1-sdr-icr-4.prg cia-sdr-icr.asm
cia1-sdr-icr-5.prg: cia-sdr-icr.asm
	acme -f cbm -DCIA=1 -DCIATYPE=1 -DBAUDRATE=5 -o cia1-sdr-icr-5.prg cia-sdr-icr.asm
cia1-sdr-icr-6.prg: cia-sdr-icr.asm
	acme -f cbm -DCIA=1 -DCIATYPE=1 -DBAUDRATE=6 -o cia1-sdr-icr-6.prg cia-sdr-icr.asm
cia1-sdr-icr-7.prg: cia-sdr-icr.asm
	acme -f cbm -DCIA=1 -DCIATYPE=1 -DBAUDRATE=7 -o cia1-sdr-icr-7.prg cia-sdr-icr.asm
cia1-sdr-icr-8.prg: cia-sdr-icr.asm
	acme -f cbm -DCIA=1 -DCIATYPE=1 -DBAUDRATE=8 -o cia1-sdr-icr-8.prg cia-sdr-icr.asm
cia1-sdr-icr-50.prg: cia-sdr-icr.asm
	acme -f cbm -DCIA=1 -DCIATYPE=1 -DBAUDRATE=50 -o cia1-sdr-icr-50.prg cia-sdr-icr.asm
cia1-sdr-icr-51.prg: cia-sdr-icr.asm
	acme -f cbm -DCIA=1 -DCIATYPE=1 -DBAUDRATE=51 -o cia1-sdr-icr-51.prg cia-sdr-icr.asm
cia1-sdr-icr-64.prg: cia-sdr-icr.asm
	acme -f cbm -DCIA=1 -DCIATYPE=1 -DBAUDRATE=64 -o cia1-sdr-icr-64.prg cia-sdr-icr.asm

cia1-sdr-icr-4485-7.prg: cia-sdr-icr.asm
	acme -f cbm -DCIA=1 -DCIATYPE=0 -DBAUDRATE=7 -o cia1-sdr-icr-4485-7.prg cia-sdr-icr.asm
cia1-sdr-icr-4485-8.prg: cia-sdr-icr.asm
	acme -f cbm -DCIA=1 -DCIATYPE=0 -DBAUDRATE=8 -o cia1-sdr-icr-4485-8.prg cia-sdr-icr.asm
cia1-sdr-icr-4485-50.prg: cia-sdr-icr.asm
	acme -f cbm -DCIA=1 -DCIATYPE=0 -DBAUDRATE=50 -o cia1-sdr-icr-4485-50.prg cia-sdr-icr.asm
cia1-sdr-icr-4485-51.prg: cia-sdr-icr.asm
	acme -f cbm -DCIA=1 -DCIATYPE=0 -DBAUDRATE=51 -o cia1-sdr-icr-4485-51.prg cia-sdr-icr.asm
cia1-sdr-icr-4485-64.prg: cia-sdr-icr.asm
	acme -f cbm -DCIA=1 -DCIATYPE=0 -DBAUDRATE=64 -o cia1-sdr-icr-4485-64.prg cia-sdr-icr.asm
	
cia2-sdr-icr-4.prg: cia-sdr-icr.asm
	acme -f cbm -DCIA=2 -DCIATYPE=1 -DBAUDRATE=4 -o cia2-sdr-icr-4.prg cia-sdr-icr.asm
cia2-sdr-icr-5.prg: cia-sdr-icr.asm
	acme -f cbm -DCIA=2 -DCIATYPE=1 -DBAUDRATE=5 -o cia2-sdr-icr-5.prg cia-sdr-icr.asm
cia2-sdr-icr-6.prg: cia-sdr-icr.asm
	acme -f cbm -DCIA=2 -DCIATYPE=1 -DBAUDRATE=6 -o cia2-sdr-icr-6.prg cia-sdr-icr.asm
cia2-sdr-icr-7.prg: cia-sdr-icr.asm
	acme -f cbm -DCIA=2 -DCIATYPE=1 -DBAUDRATE=7 -o cia2-sdr-icr-7.prg cia-sdr-icr.asm
cia2-sdr-icr-8.prg: cia-sdr-icr.asm
	acme -f cbm -DCIA=2 -DCIATYPE=1 -DBAUDRATE=8 -o cia2-sdr-icr-8.prg cia-sdr-icr.asm
cia2-sdr-icr-50.prg: cia-sdr-icr.asm
	acme -f cbm -DCIA=2 -DCIATYPE=1 -DBAUDRATE=50 -o cia2-sdr-icr-50.prg cia-sdr-icr.asm
cia2-sdr-icr-51.prg: cia-sdr-icr.asm
	acme -f cbm -DCIA=2 -DCIATYPE=1 -DBAUDRATE=51 -o cia2-sdr-icr-51.prg cia-sdr-icr.asm
cia2-sdr-icr-64.prg: cia-sdr-icr.asm
	acme -f cbm -DCIA=2 -DCIATYPE=1 -DBAUDRATE=64 -o cia2-sdr-icr-64.prg cia-sdr-icr.asm

cia2-sdr-icr-4485-7.prg: cia-sdr-icr.asm
	acme -f cbm -DCIA=2 -DCIATYPE=0 -DBAUDRATE=7 -o cia2-sdr-icr-4485-7.prg cia-sdr-icr.asm
cia2-sdr-icr-4485-8.prg: cia-sdr-icr.asm
	acme -f cbm -DCIA=2 -DCIATYPE=0 -DBAUDRATE=8 -o cia2-sdr-icr-4485-8.prg cia-sdr-icr.asm
cia2-sdr-icr-4485-50.prg: cia-sdr-icr.asm
	acme -f cbm -DCIA=2 -DCIATYPE=0 -DBAUDRATE=50 -o cia2-sdr-icr-4485-50.prg cia-sdr-icr.asm
cia2-sdr-icr-4485-51.prg: cia-sdr-icr.asm
	acme -f cbm -DCIA=2 -DCIATYPE=0 -DBAUDRATE=51 -o cia2-sdr-icr-4485-51.prg cia-sdr-icr.asm
cia2-sdr-icr-4485-64.prg: cia-sdr-icr.asm
	acme -f cbm -DCIA=2 -DCIATYPE=0 -DBAUDRATE=64 -o cia2-sdr-icr-4485-64.prg cia-sdr-icr.asm
	
rename: all
	rename sdr-icr- "" *.prg

clean:
	rm -f *.prg
