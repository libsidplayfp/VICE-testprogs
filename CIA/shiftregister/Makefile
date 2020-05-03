
TESTS=\
	cia-sp-test-oneshot-old.prg \
	cia-sp-test-continues-old.prg \
	cia-icr-test-oneshot-old.prg \
	cia-icr-test-continues-old.prg \
	cia-sp-test-oneshot-new.prg \
	cia-sp-test-continues-new.prg \
	cia-icr-test-oneshot-new.prg \
	cia-icr-test-continues-new.prg \
	cia-icr-test2-oneshot.prg \
	cia-icr-test2-continues.prg \
	cia-sdr-load.prg \
	cia-sdr-delay.prg \
	cia-sdr-icr-new.prg \
	cia-sdr-icr-old.prg \
	cia-sdr-init.prg

all: $(TESTS)

cia-sp-test-oneshot-old.prg: cia-sp-test.asm
	acme -DONESHOT=1 -DCIA=0 -f cbm -o cia-sp-test-oneshot-old.prg cia-sp-test.asm
cia-sp-test-continues-old.prg: cia-sp-test.asm
	acme -DONESHOT=0 -DCIA=0 -f cbm -o cia-sp-test-continues-old.prg cia-sp-test.asm

cia-icr-test-oneshot-old.prg: cia-icr-test.asm
	acme -DONESHOT=1 -DCIA=0 -f cbm -o cia-icr-test-oneshot-old.prg cia-icr-test.asm
cia-icr-test-continues-old.prg: cia-icr-test.asm
	acme -DONESHOT=0 -DCIA=0 -f cbm -o cia-icr-test-continues-old.prg cia-icr-test.asm

cia-sp-test-oneshot-new.prg: cia-sp-test.asm
	acme -DONESHOT=1 -DCIA=1 -f cbm -o cia-sp-test-oneshot-new.prg cia-sp-test.asm
cia-sp-test-continues-new.prg: cia-sp-test.asm
	acme -DONESHOT=0 -DCIA=1 -f cbm -o cia-sp-test-continues-new.prg cia-sp-test.asm

cia-icr-test-oneshot-new.prg: cia-icr-test.asm
	acme -DONESHOT=1 -DCIA=1 -f cbm -o cia-icr-test-oneshot-new.prg cia-icr-test.asm
cia-icr-test-continues-new.prg: cia-icr-test.asm
	acme -DONESHOT=0 -DCIA=1 -f cbm -o cia-icr-test-continues-new.prg cia-icr-test.asm

cia-icr-test2-oneshot.prg: cia-icr-test2.asm
	acme -DONESHOT=1 -f cbm -o cia-icr-test2-oneshot.prg cia-icr-test2.asm
cia-icr-test2-continues.prg: cia-icr-test2.asm
	acme -DONESHOT=0 -f cbm -o cia-icr-test2-continues.prg cia-icr-test2.asm

cia-sdr-load.prg: cia-sdr-load.a65
	xa -o cia-sdr-load.prg cia-sdr-load.a65
cia-sdr-init.prg: cia-sdr-init.asm
	acme -f cbm -o cia-sdr-init.prg cia-sdr-init.asm
cia-sdr-delay.prg: cia-sdr-delay.asm
	acme -f cbm -o cia-sdr-delay.prg cia-sdr-delay.asm
cia-sdr-icr-new.prg: cia-sdr-icr.asm
	acme -f cbm -DNEWCIA=1 -o cia-sdr-icr-new.prg cia-sdr-icr.asm
cia-sdr-icr-old.prg: cia-sdr-icr.asm
	acme -f cbm -DNEWCIA=0 -o cia-sdr-icr-old.prg cia-sdr-icr.asm
	
clean:
	rm -f *.prg
