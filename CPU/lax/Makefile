
all: lax.prg lax-border.prg lax-none.prg

lax.prg: lax.s
	acme -f cbm -DBORDER=0 -DSPRITES=1 -o lax.prg lax.s

lax-border.prg: lax.s
	acme -f cbm -DBORDER=1 -DSPRITES=1 -o lax-border.prg lax.s

lax-none.prg: lax.s
	acme -f cbm -DBORDER=1 -DSPRITES=0 -o lax-none.prg lax.s

clean:
	rm -f lax.prg
	rm -f lax-border.prg
	rm -f lax-none.prg
