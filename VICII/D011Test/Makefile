
all: disable-bad.prg disable-bad_ntsc.prg disable-bad_ntscold.prg
	
%.prg: %.tas
	dasm $< -o$@ -DCYCLES=63
%_ntsc.prg:%.tas
	dasm $*.tas -o$*_ntsc.prg -DCYCLES=65
%_ntscold.prg:%.tas
	dasm $*.tas -o$*_ntscold.prg -DCYCLES=64
	