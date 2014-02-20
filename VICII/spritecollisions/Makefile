all:	sprite-sprite.prg sprite-sprite-collision-cycle.prg sprite-gfx-collision-cycle.prg 

sprite-sprite.prg: sprite-sprite.tas
	dasm $< -o$@
sprite-sprite-collision-cycle.prg: sprite-sprite-collision-cycle.tas
	dasm $< -o$@
sprite-gfx-collision-cycle.prg: sprite-gfx-collision-cycle.tas
	dasm $< -o$@

clean:
	rm -f *~
	rm -f sprite-sprite.prg
	rm -f sprite-sprite-collision-cycle.prg
	rm -f sprite-gfx-collision-cycle.prg
 
