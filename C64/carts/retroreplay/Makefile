
all: writeonce.prg \
	nofreeze.prg \
	allowbank1.prg \
	allowbank0.prg \
	rrdummy.crt


writeonce.prg: writeonce.asm
	acme -f cbm -o writeonce.prg writeonce.asm

nofreeze.prg: nofreeze.asm
	acme -f cbm -o nofreeze.prg nofreeze.asm

allowbank1.prg: allowbank.asm
	acme -f cbm -DBANKING=1 -o allowbank1.prg allowbank.asm

allowbank0.prg: allowbank.asm
	acme -f cbm -DBANKING=0 -o allowbank0.prg allowbank.asm

rrdummy.crt:
	echo "-retro replay---" > rrdummy.bin
	cartconv -p -t rr -i rrdummy.bin -o rrdummy.crt

clean:
	$(RM) writeonce.prg
	$(RM) nofreeze.prg
	$(RM) allowbank1.prg
	$(RM) allowbank0.prg
	$(RM) rrdummy.bin rrdummy.crt
