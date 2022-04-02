
TESTS=\
	cia1-sdr-icr-0_7f.prg \
	cia1-sdr-icr-1_7f.prg \
	cia1-sdr-icr-3_7f.prg \
	cia1-sdr-icr-4_7f.prg \
        cia1-sdr-icr-0.prg \
        cia1-sdr-icr-1.prg \
        cia1-sdr-icr-2.prg \
        cia1-sdr-icr-3.prg \
        cia1-sdr-icr-4.prg \
        cia1-sdr-icr-5.prg \
        cia1-sdr-icr-6.prg \
        cia1-sdr-icr-19.prg \
        cia1-sdr-icr-39.prg \
	cia1-sdr-icr-4485-0_7f.prg \
	cia1-sdr-icr-4485-1_7f.prg \
	cia1-sdr-icr-4485-4_7f.prg \
        cia1-sdr-icr-4485-0.prg \
        cia1-sdr-icr-4485-3.prg \
        cia1-sdr-icr-4485-19.prg \
        cia1-sdr-icr-4485-39.prg \
	cia1-sdr-icr-generic-0_7f.prg \
	cia1-sdr-icr-generic-1_7f.prg \
	cia1-sdr-icr-generic-4_7f.prg \
        cia1-sdr-icr-generic-0.prg \
        cia1-sdr-icr-generic-3.prg \
        cia1-sdr-icr-generic-19.prg \
        cia1-sdr-icr-generic-39.prg \
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
	cia2-sdr-icr-generic-0_7f.prg \
	cia2-sdr-icr-generic-1_7f.prg \
	cia2-sdr-icr-generic-4_7f.prg \
        cia2-sdr-icr-generic-0.prg \
        cia2-sdr-icr-generic-3.prg \
        cia2-sdr-icr-generic-19.prg \
        cia2-sdr-icr-generic-39.prg \

all: $(TESTS)

cia1-sdr-icr-0_7f.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=1 -DCIATYPE=1 -DBAUDRATE=0 -DINTERACTIVEMODE=0 -o cia1-sdr-icr-0_7f.prg cia-sdr-icr-v3.asm
cia1-sdr-icr-1_7f.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=1 -DCIATYPE=1 -DBAUDRATE=1 -DINTERACTIVEMODE=0 -o cia1-sdr-icr-1_7f.prg cia-sdr-icr-v3.asm
cia1-sdr-icr-3_7f.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=1 -DCIATYPE=1 -DBAUDRATE=3 -DINTERACTIVEMODE=0 -o cia1-sdr-icr-3_7f.prg cia-sdr-icr-v3.asm
cia1-sdr-icr-4_7f.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=1 -DCIATYPE=1 -DBAUDRATE=4 -DINTERACTIVEMODE=0 -o cia1-sdr-icr-4_7f.prg cia-sdr-icr-v3.asm
cia1-sdr-icr-0.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=1 -DCIATYPE=1 -DBAUDRATE=0 -DINTERACTIVEMODE=1 -o cia1-sdr-icr-0.prg cia-sdr-icr-v3.asm
cia1-sdr-icr-1.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=1 -DCIATYPE=1 -DBAUDRATE=1 -DINTERACTIVEMODE=1 -o cia1-sdr-icr-1.prg cia-sdr-icr-v3.asm
cia1-sdr-icr-2.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=1 -DCIATYPE=1 -DBAUDRATE=2 -DINTERACTIVEMODE=1 -o cia1-sdr-icr-2.prg cia-sdr-icr-v3.asm
cia1-sdr-icr-3.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=1 -DCIATYPE=1 -DBAUDRATE=3 -DINTERACTIVEMODE=1 -o cia1-sdr-icr-3.prg cia-sdr-icr-v3.asm
cia1-sdr-icr-4.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=1 -DCIATYPE=1 -DBAUDRATE=4 -DINTERACTIVEMODE=1 -o cia1-sdr-icr-4.prg cia-sdr-icr-v3.asm
cia1-sdr-icr-5.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=1 -DCIATYPE=1 -DBAUDRATE=5 -DINTERACTIVEMODE=1 -o cia1-sdr-icr-5.prg cia-sdr-icr-v3.asm
cia1-sdr-icr-6.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=1 -DCIATYPE=1 -DBAUDRATE=6 -DINTERACTIVEMODE=1 -o cia1-sdr-icr-6.prg cia-sdr-icr-v3.asm
cia1-sdr-icr-19.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=1 -DCIATYPE=1 -DBAUDRATE=19 -DINTERACTIVEMODE=1 -o cia1-sdr-icr-19.prg cia-sdr-icr-v3.asm
cia1-sdr-icr-39.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=1 -DCIATYPE=1 -DBAUDRATE=39 -DINTERACTIVEMODE=1 -o cia1-sdr-icr-39.prg cia-sdr-icr-v3.asm

cia1-sdr-icr-4485-0_7f.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=1 -DCIATYPE=0 -DBAUDRATE=0 -DINTERACTIVEMODE=0 -o cia1-sdr-icr-4485-0_7f.prg cia-sdr-icr-v3.asm
cia1-sdr-icr-4485-1_7f.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=1 -DCIATYPE=0 -DBAUDRATE=1 -DINTERACTIVEMODE=0 -o cia1-sdr-icr-4485-1_7f.prg cia-sdr-icr-v3.asm
cia1-sdr-icr-4485-4_7f.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=1 -DCIATYPE=0 -DBAUDRATE=4 -DINTERACTIVEMODE=0 -o cia1-sdr-icr-4485-4_7f.prg cia-sdr-icr-v3.asm
cia1-sdr-icr-4485-0.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=1 -DCIATYPE=0 -DBAUDRATE=0 -DINTERACTIVEMODE=1 -o cia1-sdr-icr-4485-0.prg cia-sdr-icr-v3.asm
cia1-sdr-icr-4485-3.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=1 -DCIATYPE=0 -DBAUDRATE=3 -DINTERACTIVEMODE=1 -o cia1-sdr-icr-4485-3.prg cia-sdr-icr-v3.asm
cia1-sdr-icr-4485-19.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=1 -DCIATYPE=0 -DBAUDRATE=19 -DINTERACTIVEMODE=1 -o cia1-sdr-icr-4485-19.prg cia-sdr-icr-v3.asm
cia1-sdr-icr-4485-39.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=1 -DCIATYPE=0 -DBAUDRATE=39 -DINTERACTIVEMODE=1 -o cia1-sdr-icr-4485-39.prg cia-sdr-icr-v3.asm

cia1-sdr-icr-generic-0_7f.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=1 -DCIATYPE=2 -DBAUDRATE=0 -DINTERACTIVEMODE=0 -o cia1-sdr-icr-generic-0_7f.prg cia-sdr-icr-v3.asm
cia1-sdr-icr-generic-1_7f.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=1 -DCIATYPE=2 -DBAUDRATE=1 -DINTERACTIVEMODE=0 -o cia1-sdr-icr-generic-1_7f.prg cia-sdr-icr-v3.asm
cia1-sdr-icr-generic-4_7f.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=1 -DCIATYPE=2 -DBAUDRATE=4 -DINTERACTIVEMODE=0 -o cia1-sdr-icr-generic-4_7f.prg cia-sdr-icr-v3.asm
cia1-sdr-icr-generic-0.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=1 -DCIATYPE=2 -DBAUDRATE=0 -DINTERACTIVEMODE=1 -o cia1-sdr-icr-generic-0.prg cia-sdr-icr-v3.asm
cia1-sdr-icr-generic-3.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=1 -DCIATYPE=2 -DBAUDRATE=3 -DINTERACTIVEMODE=1 -o cia1-sdr-icr-generic-3.prg cia-sdr-icr-v3.asm
cia1-sdr-icr-generic-19.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=1 -DCIATYPE=2 -DBAUDRATE=19 -DINTERACTIVEMODE=1 -o cia1-sdr-icr-generic-19.prg cia-sdr-icr-v3.asm
cia1-sdr-icr-generic-39.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=1 -DCIATYPE=2 -DBAUDRATE=39 -DINTERACTIVEMODE=1 -o cia1-sdr-icr-generic-39.prg cia-sdr-icr-v3.asm



cia2-sdr-icr-0_7f.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=2 -DCIATYPE=1 -DBAUDRATE=0 -DINTERACTIVEMODE=0 -o cia2-sdr-icr-0_7f.prg cia-sdr-icr-v3.asm
cia2-sdr-icr-1_7f.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=2 -DCIATYPE=1 -DBAUDRATE=1 -DINTERACTIVEMODE=0 -o cia2-sdr-icr-1_7f.prg cia-sdr-icr-v3.asm
cia2-sdr-icr-4_7f.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=2 -DCIATYPE=1 -DBAUDRATE=4 -DINTERACTIVEMODE=0 -o cia2-sdr-icr-4_7f.prg cia-sdr-icr-v3.asm
cia2-sdr-icr-0.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=2 -DCIATYPE=1 -DBAUDRATE=0 -DINTERACTIVEMODE=1 -o cia2-sdr-icr-0.prg cia-sdr-icr-v3.asm
cia2-sdr-icr-3.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=2 -DCIATYPE=1 -DBAUDRATE=3 -DINTERACTIVEMODE=1 -o cia2-sdr-icr-3.prg cia-sdr-icr-v3.asm
cia2-sdr-icr-19.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=2 -DCIATYPE=1 -DBAUDRATE=19 -DINTERACTIVEMODE=1 -o cia2-sdr-icr-19.prg cia-sdr-icr-v3.asm
cia2-sdr-icr-39.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=2 -DCIATYPE=1 -DBAUDRATE=39 -DINTERACTIVEMODE=1 -o cia2-sdr-icr-39.prg cia-sdr-icr-v3.asm


cia2-sdr-icr-4485-0_7f.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=2 -DCIATYPE=0 -DBAUDRATE=0 -DINTERACTIVEMODE=0 -o cia2-sdr-icr-4485-0_7f.prg cia-sdr-icr-v3.asm
cia2-sdr-icr-4485-1_7f.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=2 -DCIATYPE=0 -DBAUDRATE=1 -DINTERACTIVEMODE=0 -o cia2-sdr-icr-4485-1_7f.prg cia-sdr-icr-v3.asm
cia2-sdr-icr-4485-4_7f.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=2 -DCIATYPE=0 -DBAUDRATE=4 -DINTERACTIVEMODE=0 -o cia2-sdr-icr-4485-4_7f.prg cia-sdr-icr-v3.asm
cia2-sdr-icr-4485-0.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=2 -DCIATYPE=0 -DBAUDRATE=0 -DINTERACTIVEMODE=1 -o cia2-sdr-icr-4485-0.prg cia-sdr-icr-v3.asm
cia2-sdr-icr-4485-3.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=2 -DCIATYPE=0 -DBAUDRATE=3 -DINTERACTIVEMODE=1 -o cia2-sdr-icr-4485-3.prg cia-sdr-icr-v3.asm
cia2-sdr-icr-4485-19.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=2 -DCIATYPE=0 -DBAUDRATE=19 -DINTERACTIVEMODE=1 -o cia2-sdr-icr-4485-19.prg cia-sdr-icr-v3.asm
cia2-sdr-icr-4485-39.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=2 -DCIATYPE=0 -DBAUDRATE=39 -DINTERACTIVEMODE=1 -o cia2-sdr-icr-4485-39.prg cia-sdr-icr-v3.asm

cia2-sdr-icr-generic-0_7f.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=2 -DCIATYPE=2 -DBAUDRATE=0 -DINTERACTIVEMODE=0 -o cia2-sdr-icr-generic-0_7f.prg cia-sdr-icr-v3.asm
cia2-sdr-icr-generic-1_7f.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=2 -DCIATYPE=2 -DBAUDRATE=1 -DINTERACTIVEMODE=0 -o cia2-sdr-icr-generic-1_7f.prg cia-sdr-icr-v3.asm
cia2-sdr-icr-generic-4_7f.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=2 -DCIATYPE=2 -DBAUDRATE=4 -DINTERACTIVEMODE=0 -o cia2-sdr-icr-generic-4_7f.prg cia-sdr-icr-v3.asm
cia2-sdr-icr-generic-0.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=2 -DCIATYPE=2 -DBAUDRATE=0 -DINTERACTIVEMODE=1 -o cia2-sdr-icr-generic-0.prg cia-sdr-icr-v3.asm
cia2-sdr-icr-generic-3.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=2 -DCIATYPE=2 -DBAUDRATE=3 -DINTERACTIVEMODE=1 -o cia2-sdr-icr-generic-3.prg cia-sdr-icr-v3.asm
cia2-sdr-icr-generic-19.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=2 -DCIATYPE=2 -DBAUDRATE=19 -DINTERACTIVEMODE=1 -o cia2-sdr-icr-generic-19.prg cia-sdr-icr-v3.asm
cia2-sdr-icr-generic-39.prg: cia-sdr-icr-v3.asm
	acme -f cbm -DCIA=2 -DCIATYPE=2 -DBAUDRATE=39 -DINTERACTIVEMODE=1 -o cia2-sdr-icr-generic-39.prg cia-sdr-icr-v3.asm

generate:
	cc generate.c -o generate

	
rename: all
	rename sdr-icr- "" *.prg

clean:
	rm -f *.prg generate
