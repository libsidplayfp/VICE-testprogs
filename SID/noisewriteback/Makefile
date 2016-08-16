all: noise_writeback_test1-old.prg noise_writeback_test1-new.prg \
	noise_writeback_test2-old.prg noise_writeback_test2-new.prg noisewriteback.prg

noisewriteback.prg:  noisewriteback.asm
	acme -f cbm -o noisewriteback.prg noisewriteback.asm

noise_writeback_test1-old.prg:  noise_writeback_test1.asm
	acme -DNEWSID=0 -f cbm -o noise_writeback_test1-old.prg noise_writeback_test1.asm
noise_writeback_test1-new.prg:  noise_writeback_test1.asm
	acme -DNEWSID=1 -f cbm -o noise_writeback_test1-new.prg noise_writeback_test1.asm

noise_writeback_test2-old.prg:  noise_writeback_test2.asm
	acme -DNEWSID=0 -f cbm -o noise_writeback_test2-old.prg noise_writeback_test2.asm
noise_writeback_test2-new.prg:  noise_writeback_test2.asm
	acme -DNEWSID=1 -f cbm -o noise_writeback_test2-new.prg noise_writeback_test2.asm

clean:
	rm -f noise_writeback_test1-old.prg noise_writeback_test1-new.prg
	rm -f noise_writeback_test2-old.prg noise_writeback_test2-new.prg noisewriteback.prg
