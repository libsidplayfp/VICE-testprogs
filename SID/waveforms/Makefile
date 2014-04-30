all: waveforms-6581.prg waveforms-8580.prg

waveforms-6581.prg: waveforms.asm
	acme -DNEWSID=0  -o waveforms-6581.prg waveforms.asm
waveforms-8580.prg: waveforms.asm
	acme -DNEWSID=1 -o waveforms-8580.prg waveforms.asm
	
clean:
	rm -f *~
	rm -f waveforms-6581.prg
	rm -f waveforms-8580.prg

