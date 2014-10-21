all: waveforms-6581.prg waveforms-8580.prg

waveforms-6581.prg: waveforms.asm ref6581.prg
	acme -DNEWSID=0  -o waveforms-6581.prg waveforms.asm
waveforms-8580.prg: waveforms.asm ref8580.prg
	acme -DNEWSID=1 -o waveforms-8580.prg waveforms.asm
	
clean:
	rm -f *~
	rm -f waveforms-6581.prg
	rm -f waveforms-8580.prg

