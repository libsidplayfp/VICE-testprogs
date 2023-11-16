This directory contains tests for checking the VICE monitor/debugger
--------------------------------------------------------------------------------

6502
----

- assemble (acme) legalopcodes.txt into legalopcodes.bin
- disassemble (monitor) legalopcodes.bin (to legalopcodes2.txt)
- compare with reference (legalopcodes.txt)

- assemble legalopcodes2.txt (acme)
- compare with reference (legalopcodes.bin)

- assemble legalopcodes2.txt (monitor)
- compare with reference (legalopcodes.bin)

- assemble (acme) allundocs.txt into allundocs.bin
- disassemble (monitor) allundocs.bin (to undocsdisasm.txt)
- compare with reference (allundocs.txt)

- assemble (acme) supportedundocs.txt into supportedundocs.bin
- disassemble (monitor) supportedundocs.bin (to supporteddisasm.txt)
- compare with reference (supportedundocs.txt)

- assemble supporteddisasm.txt (monitor)
- compare with reference (supportedundocs.bin)


65816
-----

TODO: 65816 disassembler and assembler test(s)


6809
----

6809 disassembler and assembler test(s)

- disassemble legalopcodes.bin
- compare with reference (legalopcodes.txt)
- assemble the disassembly (legalopcodes1.txt)
- compare with reference (legalopcodes.bin)

TODO: the assembler fails on (some) valid instructions

R65C02
------

TODO: R65C02 disassembler and assembler test(s)


z80
---

- disassemble z80cx.prg
- compare with reference (z80cx-expected.txt)

TODO: test assembler


dummytest
---------

contains all opcodes that produce dummy reads or writes on the 6502

configure the emulators you want to compare at the top of the makefile

use "make test" or "make testnohist" to produce log output, which you can then
inspect in a text editor and/or compare against each other with your favourite
diff tool.
