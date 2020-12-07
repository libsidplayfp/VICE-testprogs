
test-fuxxored.prg:

a simple basic program ("test.prg") encoded by "emu-fuxxor v2" 
(https://csdb.dk/release/?id=55745) which contains a couple of "emulator tests".

When running in the testbench, it will timeout when failed.

hangs in x64, works in x64sc


the other programs are standalone versions of the individual tests done by emu
fuxxor v1 and v2:


ef1-nmi.prg:

test: simple NMI trigger
- green border shows success


ef2-inst1.prg:

test: drive stuff
- green border shows success

fails without true drive emulation


ef2-inst2.prg:

test: sprite vs sprite collision
- green border shows success

fails in x64, works in x64sc
    

ef2-inst3.prg:

test: sprite vs sprite collision
- green border shows success

fails in x64, works in x64sc


ef2-inst4a.prg:

test: writes to RAM at $00 and $01, checks via sprite vs sprite collision
- green border shows success

fails in x64, works in x64sc


ef2-inst4b.prg:

test: sid write to reg and read back value
- green border shows success

the check seems to work on even the oldest x64 i have. it looks like some
kind of generic emulator detection that didnt quite work out :)
    

ef2-inst4c.prg:

test: sprite vs sprite collision
- green border shows success

hangs in x64, works in x64sc
