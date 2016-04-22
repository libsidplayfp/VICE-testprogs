


all: ciairq1t1.prg ciairq1t2.prg ciairq2t1.prg ciairq2t2.prg

ciairq1t1.prg: ciairqenable.s
	acme -f cbm -DCIA=1 -DTIMER=1 -o ciairq1t1.prg ciairqenable.s
ciairq1t2.prg: ciairqenable.s
	acme -f cbm -DCIA=1 -DTIMER=2 -o ciairq1t2.prg ciairqenable.s
ciairq2t1.prg: ciairqenable.s
	acme -f cbm -DCIA=2 -DTIMER=1 -o ciairq2t1.prg ciairqenable.s
ciairq2t2.prg: ciairqenable.s
	acme -f cbm -DCIA=2 -DTIMER=2 -o ciairq2t2.prg ciairqenable.s

clean:
	rm -f ciairq1t1.prg ciairq1t2.prg ciairq2t1.prg ciairq2t2.prg
