all:	d017-54.prg d017-57.prg

d017-54.prg: d017-54.tas
	dasm $< -o$@
d017-57.prg: d017-57.tas
	dasm $< -o$@

clean:
	rm -f *~
	rm -f d017-54.prg
	rm -f d017-57.prg
 
