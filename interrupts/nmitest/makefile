#.SILENT:

all: nmitest.prg
nmitest.prg: main.s
	acme main.s
	
test: nmitest.prg
	x64 --autostart nmitest.prg

codenet: nmitest.prg
	codenet -x nmitest.prg
clean:
	rm -f  nmitest.prg
	rm -f  *~
 
