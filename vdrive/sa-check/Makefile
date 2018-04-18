
all: sacheck.prg sacheck.d64

sacheck.prg: sacheck.s
	acme -f cbm  -o sacheck.prg sacheck.s
	
sacheck.d64: sacheck.prg
	c1541 -format "sacheck,00" d64 sacheck.d64 \
		-write sacheck.prg sacheck.prg

