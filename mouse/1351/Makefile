
all: mmtest-port1.prg mmtest-port2.prg mssiah.prg mmtest-waitframe-port1.prg \
	mmtest-nolog-port1.prg

mmtest-port1.prg: mmtest.asm
	acme -DPORT=1 -DFRAMESYNC=0 -DLOGGING=1 -o mmtest-port1.prg -f cbm mmtest.asm
mmtest-port2.prg: mmtest.asm
	acme -DPORT=2 -DFRAMESYNC=0 -DLOGGING=1 -o mmtest-port2.prg -f cbm mmtest.asm

mmtest-waitframe-port1.prg: mmtest.asm
	acme -DPORT=1 -DFRAMESYNC=1 -DLOGGING=1 -o mmtest-waitframe-port1.prg -f cbm mmtest.asm
	
mmtest-nolog-port1.prg: mmtest.asm
	acme -DPORT=1 -DFRAMESYNC=0 -DLOGGING=0 -o mmtest-nolog-port1.prg -f cbm mmtest.asm
	
mssiah.prg: mssiah.asm
	acme -o mssiah.prg -f cbm mssiah.asm

clean:
	$(RM) mmtest-port1.prg mmtest-port2.prg mssiah.prg
	$(RM) mmtest-waitframe-port1.prg
	$(RM) mmtest-nolog-port1.prg
