#.SILENT:

TESTPROGS = \
	exos.prg \
	mmcr.prg \
	mmcrplugin.prg \
	mmcr-64krom.crt \
	romram.crt \
	writeram.crt \
	16kgame.crt \
	rr-reu.crt

all: $(TESTPROGS) disk

exos.prg: main-exos.s
	acme main-exos.s

mmcr.prg: main-mmcr.s run-mmcr.s
	acme run-mmcr.s
mmcrplugin.prg: main-mmcr.s plugin-mmcr.s
	acme plugin-mmcr.s
64krom-padding.bin: 64krom-padding.s	
	acme 64krom-padding.s
mmcr-64krom.bin: main-mmcr.s 64krom-mmcr.s mmcrplugin.prg 64krom-padding.bin
	acme 64krom-mmcr.s
	cat 64krom-mmcr.bin > mmcr-64krom.bin
	cat 64krom-padding.bin >> mmcr-64krom.bin

mmcr-64krom.crt: mmcr-64krom.bin	
	cartconv -t mmcr -i mmcr-64krom.bin -o mmcr-64krom.crt
	
romram.crt: romram.s
	acme romram.s
	
writeram.crt: writeram.s
	acme writeram.s
	cartconv -p -t pf -i writeram.bin -o writeram.crt

16kgame.crt: main-16kgame.s
	acme main-16kgame.s
	cartconv -p -t normal -i 16kgame.bin -o 16kgame.crt
	
rr-reu.crt: rr-reu.s
	acme rr-reu.s
	cartconv -p -t rr -i rr-reu.bin -o rr-reu.crt
	
disk: exos.prg mmcr.prg
	c1541 -format test,00 d64 carttest.d64 -attach carttest.d64 \
		-write exos.prg exos \
		-write mmcr.prg mmcr
	
clean:
	rm -f  $(TESTPROGS)
	rm -f 64krom-padding.bin mmcr-64krom.bin writeram.bin 16kgame.bin 64krom-mmcr.bin
	rm -f carttest.d64 rr-reu.bin
	rm -f  *~
