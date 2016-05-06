all: 6502_functional_test.prg
wip: 6502_interrupt_test.prg 65C02_extended_opcodes_test.prg

6502_functional_test.prg: 6502_functional_test.asm report.asm
	acme -f cbm -o 6502_functional_test.prg 6502_functional_test.asm
65C02_extended_opcodes_test.prg: 65C02_extended_opcodes_test.asm report.asm
	acme --cpu 65C02 -f cbm -o 65C02_extended_opcodes_test.prg 65C02_extended_opcodes_test.asm
6502_interrupt_test.prg: 6502_interrupt_test.asm report.asm
	acme -f cbm -o 6502_interrupt_test.prg 6502_interrupt_test.asm

clean:
	rm -f 6502_functional_test.prg 6502_interrupt_test.prg 65C02_extended_opcodes_test.prg
