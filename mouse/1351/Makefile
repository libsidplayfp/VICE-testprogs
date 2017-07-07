
all: mmtest-port1.prg mmtest-port2.prg mssiah.prg

mmtest-port1.prg: mmtest.asm
	acme -DPORT=1 -o mmtest-port1.prg -f cbm mmtest.asm
mmtest-port2.prg: mmtest.asm
	acme -DPORT=2 -o mmtest-port2.prg -f cbm mmtest.asm

mssiah.prg: mssiah.asm
	acme -o mssiah.prg -f cbm mssiah.asm
