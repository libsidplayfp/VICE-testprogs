all: waveforms-6581.prg waveforms-8580.prg \
	waveforms-10-6581.prg waveforms-20-6581.prg waveforms-40-6581.prg \
	waveforms-10-8580.prg waveforms-20-8580.prg waveforms-40-8580.prg \
	waveforms-80-6581.prg waveforms-80-8580.prg

waveforms-6581.prg: waveforms.asm ref6581.prg
	acme -f cbm -DNEWSID=0 -DINTERACTIVE=1 -DWAVE=0 -o waveforms-6581.prg waveforms.asm
waveforms-8580.prg: waveforms.asm ref8580.prg
	acme -f cbm -DNEWSID=1 -DINTERACTIVE=1 -DWAVE=0 -o waveforms-8580.prg waveforms.asm

waveforms-10-6581.prg: waveforms.asm ref6581.prg
	acme -f cbm -DNEWSID=0 -DINTERACTIVE=0 -DWAVE=1 -o waveforms-10-6581.prg waveforms.asm
waveforms-20-6581.prg: waveforms.asm ref6581.prg
	acme -f cbm -DNEWSID=0 -DINTERACTIVE=0 -DWAVE=2 -o waveforms-20-6581.prg waveforms.asm
waveforms-40-6581.prg: waveforms.asm ref6581.prg
	acme -f cbm -DNEWSID=0 -DINTERACTIVE=0 -DWAVE=4 -o waveforms-40-6581.prg waveforms.asm
waveforms-80-6581.prg: waveforms.asm ref6581.prg
	acme -f cbm -DNEWSID=0 -DINTERACTIVE=0 -DWAVE=8 -o waveforms-80-6581.prg waveforms.asm

waveforms-10-8580.prg: waveforms.asm ref8580.prg
	acme -f cbm -DNEWSID=1 -DINTERACTIVE=0 -DWAVE=1 -o waveforms-10-8580.prg waveforms.asm
waveforms-20-8580.prg: waveforms.asm ref8580.prg
	acme -f cbm -DNEWSID=1 -DINTERACTIVE=0 -DWAVE=2 -o waveforms-20-8580.prg waveforms.asm
waveforms-40-8580.prg: waveforms.asm ref8580.prg
	acme -f cbm -DNEWSID=1 -DINTERACTIVE=0 -DWAVE=4 -o waveforms-40-8580.prg waveforms.asm
waveforms-80-8580.prg: waveforms.asm ref8580.prg
	acme -f cbm -DNEWSID=1 -DINTERACTIVE=0 -DWAVE=8 -o waveforms-80-8580.prg waveforms.asm
	
clean:
	rm -f *~
	rm -f waveforms-6581.prg
	rm -f waveforms-10-6581.prg
	rm -f waveforms-20-6581.prg
	rm -f waveforms-40-6581.prg
	rm -f waveforms-80-6581.prg
	rm -f waveforms-8580.prg
	rm -f waveforms-10-8580.prg
	rm -f waveforms-20-8580.prg
	rm -f waveforms-40-8580.prg
	rm -f waveforms-80-8580.prg

