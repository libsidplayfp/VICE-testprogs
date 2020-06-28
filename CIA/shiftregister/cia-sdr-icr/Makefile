
TESTS=\
	cia1-sdr-icr-0_7f.prg \
	cia1-sdr-icr-1_7f.prg \
	cia1-sdr-icr-4_7f.prg \
        cia1-sdr-icr-0.prg \
        cia1-sdr-icr-3.prg \
        cia1-sdr-icr-19.prg \
        cia1-sdr-icr-39.prg \
	cia1-sdr-icr-4485-0_7f.prg \
	cia1-sdr-icr-4485-1_7f.prg \
	cia1-sdr-icr-4485-4_7f.prg \
        cia1-sdr-icr-4485-0.prg \
        cia1-sdr-icr-4485-3.prg \
        cia1-sdr-icr-4485-19.prg \
        cia1-sdr-icr-4485-39.prg \
        \
	cia2-sdr-icr-0_7f.prg \
	cia2-sdr-icr-1_7f.prg \
	cia2-sdr-icr-4_7f.prg \
        cia2-sdr-icr-0.prg \
        cia2-sdr-icr-3.prg \
        cia2-sdr-icr-19.prg \
        cia2-sdr-icr-39.prg \
	cia2-sdr-icr-4485-0_7f.prg \
	cia2-sdr-icr-4485-1_7f.prg \
	cia2-sdr-icr-4485-4_7f.prg \
        cia2-sdr-icr-4485-0.prg \
        cia2-sdr-icr-4485-3.prg \
        cia2-sdr-icr-4485-19.prg \
  	cia2-sdr-icr-4485-39.prg \

all: $(TESTS)

cia1-sdr-icr-0_7f.prg: cia-sdr-icr-v2.asm
	acme -f cbm -DCIA=1 -DCIATYPE=1 -DBAUDRATE=0 -DINTERACTIVEMODE=0 -o cia1-sdr-icr-0_7f.prg cia-sdr-icr-v2.asm
cia1-sdr-icr-1_7f.prg: cia-sdr-icr-v2.asm
	acme -f cbm -DCIA=1 -DCIATYPE=1 -DBAUDRATE=1 -DINTERACTIVEMODE=0 -o cia1-sdr-icr-1_7f.prg cia-sdr-icr-v2.asm
cia1-sdr-icr-4_7f.prg: cia-sdr-icr-v2.asm
	acme -f cbm -DCIA=1 -DCIATYPE=1 -DBAUDRATE=4 -DINTERACTIVEMODE=0 -o cia1-sdr-icr-4_7f.prg cia-sdr-icr-v2.asm
cia1-sdr-icr-0.prg: cia-sdr-icr-v2.asm
	acme -f cbm -DCIA=1 -DCIATYPE=1 -DBAUDRATE=0 -DINTERACTIVEMODE=1 -o cia1-sdr-icr-0.prg cia-sdr-icr-v2.asm
cia1-sdr-icr-3.prg: cia-sdr-icr-v2.asm
	acme -f cbm -DCIA=1 -DCIATYPE=1 -DBAUDRATE=3 -DINTERACTIVEMODE=1 -o cia1-sdr-icr-3.prg cia-sdr-icr-v2.asm
cia1-sdr-icr-19.prg: cia-sdr-icr-v2.asm
	acme -f cbm -DCIA=1 -DCIATYPE=1 -DBAUDRATE=19 -DINTERACTIVEMODE=1 -o cia1-sdr-icr-19.prg cia-sdr-icr-v2.asm
cia1-sdr-icr-39.prg: cia-sdr-icr-v2.asm
	acme -f cbm -DCIA=1 -DCIATYPE=1 -DBAUDRATE=39 -DINTERACTIVEMODE=1 -o cia1-sdr-icr-39.prg cia-sdr-icr-v2.asm

cia1-sdr-icr-4485-0_7f.prg: cia-sdr-icr-v2.asm
	acme -f cbm -DCIA=1 -DCIATYPE=0 -DBAUDRATE=0 -DINTERACTIVEMODE=0 -o cia1-sdr-icr-4485-0_7f.prg cia-sdr-icr-v2.asm
cia1-sdr-icr-4485-1_7f.prg: cia-sdr-icr-v2.asm
	acme -f cbm -DCIA=1 -DCIATYPE=0 -DBAUDRATE=1 -DINTERACTIVEMODE=0 -o cia1-sdr-icr-4485-1_7f.prg cia-sdr-icr-v2.asm
cia1-sdr-icr-4485-4_7f.prg: cia-sdr-icr-v2.asm
	acme -f cbm -DCIA=1 -DCIATYPE=0 -DBAUDRATE=4 -DINTERACTIVEMODE=0 -o cia1-sdr-icr-4485-4_7f.prg cia-sdr-icr-v2.asm
cia1-sdr-icr-4485-0.prg: cia-sdr-icr-v2.asm
	acme -f cbm -DCIA=1 -DCIATYPE=0 -DBAUDRATE=0 -DINTERACTIVEMODE=1 -o cia1-sdr-icr-4485-0.prg cia-sdr-icr-v2.asm
cia1-sdr-icr-4485-3.prg: cia-sdr-icr-v2.asm
	acme -f cbm -DCIA=1 -DCIATYPE=0 -DBAUDRATE=3 -DINTERACTIVEMODE=1 -o cia1-sdr-icr-4485-3.prg cia-sdr-icr-v2.asm
cia1-sdr-icr-4485-19.prg: cia-sdr-icr-v2.asm
	acme -f cbm -DCIA=1 -DCIATYPE=0 -DBAUDRATE=19 -DINTERACTIVEMODE=1 -o cia1-sdr-icr-4485-19.prg cia-sdr-icr-v2.asm
cia1-sdr-icr-4485-39.prg: cia-sdr-icr-v2.asm
	acme -f cbm -DCIA=1 -DCIATYPE=0 -DBAUDRATE=39 -DINTERACTIVEMODE=1 -o cia1-sdr-icr-4485-39.prg cia-sdr-icr-v2.asm


cia2-sdr-icr-0_7f.prg: cia-sdr-icr-v2.asm
	acme -f cbm -DCIA=2 -DCIATYPE=1 -DBAUDRATE=0 -DINTERACTIVEMODE=0 -o cia2-sdr-icr-0_7f.prg cia-sdr-icr-v2.asm
cia2-sdr-icr-1_7f.prg: cia-sdr-icr-v2.asm
	acme -f cbm -DCIA=2 -DCIATYPE=1 -DBAUDRATE=1 -DINTERACTIVEMODE=0 -o cia2-sdr-icr-1_7f.prg cia-sdr-icr-v2.asm
cia2-sdr-icr-4_7f.prg: cia-sdr-icr-v2.asm
	acme -f cbm -DCIA=2 -DCIATYPE=1 -DBAUDRATE=4 -DINTERACTIVEMODE=0 -o cia2-sdr-icr-4_7f.prg cia-sdr-icr-v2.asm
cia2-sdr-icr-0.prg: cia-sdr-icr-v2.asm
	acme -f cbm -DCIA=2 -DCIATYPE=1 -DBAUDRATE=0 -DINTERACTIVEMODE=1 -o cia2-sdr-icr-0.prg cia-sdr-icr-v2.asm
cia2-sdr-icr-3.prg: cia-sdr-icr-v2.asm
	acme -f cbm -DCIA=2 -DCIATYPE=1 -DBAUDRATE=3 -DINTERACTIVEMODE=1 -o cia2-sdr-icr-3.prg cia-sdr-icr-v2.asm
cia2-sdr-icr-19.prg: cia-sdr-icr-v2.asm
	acme -f cbm -DCIA=2 -DCIATYPE=1 -DBAUDRATE=19 -DINTERACTIVEMODE=1 -o cia2-sdr-icr-19.prg cia-sdr-icr-v2.asm
cia2-sdr-icr-39.prg: cia-sdr-icr-v2.asm
	acme -f cbm -DCIA=2 -DCIATYPE=1 -DBAUDRATE=39 -DINTERACTIVEMODE=1 -o cia2-sdr-icr-39.prg cia-sdr-icr-v2.asm


cia2-sdr-icr-4485-0_7f.prg: cia-sdr-icr-v2.asm
	acme -f cbm -DCIA=2 -DCIATYPE=0 -DBAUDRATE=0 -DINTERACTIVEMODE=0 -o cia2-sdr-icr-4485-0_7f.prg cia-sdr-icr-v2.asm
cia2-sdr-icr-4485-1_7f.prg: cia-sdr-icr-v2.asm
	acme -f cbm -DCIA=2 -DCIATYPE=0 -DBAUDRATE=1 -DINTERACTIVEMODE=0 -o cia2-sdr-icr-4485-1_7f.prg cia-sdr-icr-v2.asm
cia2-sdr-icr-4485-4_7f.prg: cia-sdr-icr-v2.asm
	acme -f cbm -DCIA=2 -DCIATYPE=0 -DBAUDRATE=4 -DINTERACTIVEMODE=0 -o cia2-sdr-icr-4485-4_7f.prg cia-sdr-icr-v2.asm
cia2-sdr-icr-4485-0.prg: cia-sdr-icr-v2.asm
	acme -f cbm -DCIA=2 -DCIATYPE=0 -DBAUDRATE=0 -DINTERACTIVEMODE=1 -o cia2-sdr-icr-4485-0.prg cia-sdr-icr-v2.asm
cia2-sdr-icr-4485-3.prg: cia-sdr-icr-v2.asm
	acme -f cbm -DCIA=2 -DCIATYPE=0 -DBAUDRATE=3 -DINTERACTIVEMODE=1 -o cia2-sdr-icr-4485-3.prg cia-sdr-icr-v2.asm
cia2-sdr-icr-4485-19.prg: cia-sdr-icr-v2.asm
	acme -f cbm -DCIA=2 -DCIATYPE=0 -DBAUDRATE=19 -DINTERACTIVEMODE=1 -o cia2-sdr-icr-4485-19.prg cia-sdr-icr-v2.asm
cia2-sdr-icr-4485-39.prg: cia-sdr-icr-v2.asm
	acme -f cbm -DCIA=2 -DCIATYPE=0 -DBAUDRATE=39 -DINTERACTIVEMODE=1 -o cia2-sdr-icr-4485-39.prg cia-sdr-icr-v2.asm

	
rename: all
	rename sdr-icr- "" *.prg

clean:
	rm -f *.prg
