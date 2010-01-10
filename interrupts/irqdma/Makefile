COMPILER = acme
CFLAGS = -v1 --cpu 6502 -f cbm -o

.PHONY: all clean

.SUFFIXES: .prg .asm
%.prg: %.asm
	$(COMPILER) $(CFLAGS) $@ $<

all: testirq1.prg testirq2.prg testirq3.prg testirq4.prg testirq5.prg testirq6.prg

testirq1.prg: testirq1.asm irq1.dump

testirq2.prg: testirq2.asm irq2.dump

testirq3.prg: testirq3.asm irq3.dump

testirq4.prg: testirq4.asm irq4.dump

testirq5.prg: testirq5.asm irq5.dump

testirq6.prg: testirq6.asm irq6.dump

clean:
	-$(REMOVE) *.prg
