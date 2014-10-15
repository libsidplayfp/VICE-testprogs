
all: stereo.prg

stereo.prg: stereo.bas
	petcat -w2 -o stereo.prg -- stereo.bas

test: stereo.prg
	x64sc -sidstereo 1 -sidstereoaddress 0xde00 stereo.prg

clean:
	rm -f *~ stereo.prg

