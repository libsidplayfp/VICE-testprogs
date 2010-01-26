COMPILER = acme
CFLAGS = -v1 --cpu 6502 -f cbm -o

.PHONY: all clean

.SUFFIXES: .prg .asm
%.prg: %.asm
	$(COMPILER) $(CFLAGS) $@ $<

all: testirq1.prg testirq2.prg testirq3.prg \
    testirq4.prg testirq5.prg testirq6.prg \
    testirq1b.prg testirq2b.prg testirq3b.prg \
    testirq4b.prg testirq5b.prg
#testirq6b.prg

testirq1.prg: testirq1.asm irq1.dump

testirq1b.prg: testirq1b.asm irq1b.dump

testirq2.prg: testirq2.asm irq2.dump

testirq2b.prg: testirq2b.asm irq2b.dump

testirq3.prg: testirq3.asm irq3.dump

testirq3b.prg: testirq3b.asm irq3b.dump

testirq4.prg: testirq4.asm irq4.dump

testirq4b.prg: testirq4b.asm irq4b.dump

testirq5.prg: testirq5.asm irq5.dump

testirq5b.prg: testirq5b.asm irq5b.dump

testirq6.prg: testirq6.asm irq6.dump

#testirq6b.prg: testirq6b.asm irq6b.dump

clean:
	-$(REMOVE) *.prg
