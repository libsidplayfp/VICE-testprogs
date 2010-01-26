COMPILER = acme
CFLAGS = -v1 --cpu 6502 -f cbm -o

.PHONY: all clean

.SUFFIXES: .prg .asm
%.prg: %.asm
	$(COMPILER) $(CFLAGS) $@ $<

all: record1.prg record2.prg record3.prg \
     record4.prg record5.prg record6.prg \
     record1b.prg record2b.prg record3b.prg \
     record4b.prg record5b.prg record6b.prg \
     test1.prg test2.prg test3.prg \
     test4.prg test5.prg test6.prg \
     test1b.prg test2b.prg test3b.prg \
     test4b.prg test5b.prg test6b.prg \
     test1n.prg test2n.prg test3n.prg \
     test4n.prg test5n.prg test6n.prg
#     test1bn.prg test2bn.prg test3bn.prg \
#     test4bn.prg test5bn.prg test6bn.prg

record1.prg: record1.asm irqdma.asm
record2.prg: record2.asm irqdma.asm
record3.prg: record3.asm irqdma.asm
record4.prg: record4.asm irqdma.asm
record5.prg: record5.asm irqdma.asm
record6.prg: record6.asm irqdma.asm

record1b.prg: record1b.asm irqdma.asm
record2b.prg: record2b.asm irqdma.asm
record3b.prg: record3b.asm irqdma.asm
record4b.prg: record4b.asm irqdma.asm
record5b.prg: record5b.asm irqdma.asm
record6b.prg: record6b.asm irqdma.asm

test1.prg: test1.asm irq1.dump irqdma.asm
test2.prg: test2.asm irq2.dump irqdma.asm
test3.prg: test3.asm irq3.dump irqdma.asm
test4.prg: test4.asm irq4.dump irqdma.asm
test5.prg: test5.asm irq5.dump irqdma.asm
test6.prg: test6.asm irq6.dump irqdma.asm

test1b.prg: test1b.asm irq1b.dump irqdma.asm
test2b.prg: test2b.asm irq2b.dump irqdma.asm
test3b.prg: test3b.asm irq3b.dump irqdma.asm
test4b.prg: test4b.asm irq4b.dump irqdma.asm
test5b.prg: test5b.asm irq5b.dump irqdma.asm
test6b.prg: test6b.asm irq6b.dump irqdma.asm

test1n.prg: test1n.asm irq1-newcia.dump irqdma.asm
test2n.prg: test2n.asm irq2-newcia.dump irqdma.asm
test3n.prg: test3n.asm irq3-newcia.dump irqdma.asm
test4n.prg: test4n.asm irq4-newcia.dump irqdma.asm
test5n.prg: test5n.asm irq5-newcia.dump irqdma.asm
test6n.prg: test6n.asm irq6-newcia.dump irqdma.asm

#test1bn.prg: test1bn.asm irq1b-newcia.dump irqdma.asm
#test2bn.prg: test2bn.asm irq2b-newcia.dump irqdma.asm
#test3bn.prg: test3bn.asm irq3b-newcia.dump irqdma.asm
#test4bn.prg: test4bn.asm irq4b-newcia.dump irqdma.asm
#test5bn.prg: test5bn.asm irq5b-newcia.dump irqdma.asm
#test6bn.prg: test6bn.asm irq6b-newcia.dump irqdma.asm

clean:
	-$(REMOVE) *.prg
