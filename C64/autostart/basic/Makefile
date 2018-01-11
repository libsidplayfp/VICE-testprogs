
all: basictest.prg printpoint.prg printpoint2.prg batest.d64

basictest.prg: basictest.bas
	petcat -w2 -o basictest.prg basictest.bas
printpoint.prg: printpoint.bas
	petcat -w2 -o printpoint.prg printpoint.bas
printpoint2.prg: printpoint2.bas
	petcat -w2 -o printpoint2.prg printpoint2.bas
batest.d64: batest.bas
	petcat -w2 -o batest.prg batest.bas
	c1541 -format "batest,00" d64 batest.d64 -write batest.prg batest

