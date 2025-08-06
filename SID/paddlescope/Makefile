
all: plotter.prg

plotter.prg: plotter.asm
	acme --cpu 6510 -f cbm -o plotter.prg plotter.asm

clean:
	$(RM) plotter.prg
