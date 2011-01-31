#.SILENT:

all: paltest.prg
paltest.prg: main.s
	acme main.s
	
test: paltest.prg
	x64 --autostart paltest.prg
	
codenet: paltest.prg
	codenet -x paltest.prg

clean:
	rm -f  *~
zap: clean
	rm -f  paltest.prg
