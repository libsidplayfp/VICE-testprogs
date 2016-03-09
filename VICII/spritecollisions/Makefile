
TESTS=\
	sprite-gfx-collision-cycle.prg \
	sprite-sprite-collision-cycle.prg \
	sprite-sprite.prg

TESTSNTSC=\
	sprite-gfx-collision-cycle_ntsc.prg \
	sprite-sprite-collision-cycle_ntsc.prg \
	sprite-sprite_ntsc.prg

TESTSNTSCOLD=\
	sprite-gfx-collision-cycle_ntscold.prg \
	sprite-sprite-collision-cycle_ntscold.prg \
	sprite-sprite_ntscold.prg

all: $(TESTS) $(TESTSNTSC) $(TESTSNTSCOLD)

%.prg:%.tas
	dasm $*.tas -o$*.prg -DCYCLES=63 -DDTV=0
%_ntsc.prg:%.tas
	dasm $*.tas -o$*_ntsc.prg -DCYCLES=65 -DDTV=0
%_ntscold.prg:%.tas
	dasm $*.tas -o$*_ntscold.prg -DCYCLES=64 -DDTV=0

clean:
	rm -f $(TESTS) $(TESTSNTSC) $(TESTSNTSCOLD)