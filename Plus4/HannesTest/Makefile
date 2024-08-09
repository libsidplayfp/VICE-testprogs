OPTS = -v --color -f cbm -l $(@:prg=lst)

all: HannesTest.prg

HannesTest.prg: HannesTest.asm
	acme $(OPTS) -o $@ $^

clean:
	rm -f *.prg *.lst
