
all: ane.prg ane-border.prg ane-none.prg

ane.prg: ane.s
	acme -f cbm -DBORDER=0 -DSPRITES=1 -o ane.prg ane.s
ane-border.prg: ane.s
	acme -f cbm -DBORDER=1 -DSPRITES=1 -o ane-border.prg ane.s
ane-none.prg: ane.s
	acme -f cbm -DBORDER=1 -DSPRITES=0 -o ane-none.prg ane.s

clean:
	rm -f ane.prg
	rm -f ane-border.prg
	rm -f ane-none.prg
