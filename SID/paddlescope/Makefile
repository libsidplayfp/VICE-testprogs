
all: plotter.prg plotter-sei.prg

plotter.prg: plotter.asm
	acme -DIRQ=1 --cpu 6510 -f cbm -o plotter.prg plotter.asm
plotter-sei.prg: plotter.asm
	acme -DIRQ=0 --cpu 6510 -f cbm -o plotter-sei.prg plotter.asm

clean:
	$(RM) plotter.prg
	$(RM) plotter-sei.prg
