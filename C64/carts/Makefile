#.SILENT:

TESTPROGS = \
	exos.prg \
	mmcr.prg \
	mmcrplugin.prg \
	mmcr-64krom.bin \
	romram.crt \
	writeram.crt \
	16kgame.crt

all: $(TESTPROGS) disk

exos.prg: main-exos.s
	acme main-exos.s

mmcr.prg: main-mmcr.s run-mmcr.s
	acme run-mmcr.s
mmcrplugin.prg: main-mmcr.s plugin-mmcr.s
	acme plugin-mmcr.s
mmcr-64krom.bin: main-mmcr.s 64krom-mmcr.s mmcrplugin.prg
	acme 64krom-mmcr.s

romram.crt: romram.s
	acme romram.s
	
writeram.crt: writeram.s
	acme writeram.s
	cartconv -t pf -i writeram.bin -o writeram.crt

16kgame.crt: main-16kgame.s
	acme main-16kgame.s
	cartconv -t normal -i 16kgame.bin -o 16kgame.crt
	
disk: exos.prg mmcr.prg
	c1541 -format test,00 d64 carttest.d64 -attach carttest.d64 \
		-write exos.prg exos \
		-write mmcr.prg mmcr
	
clean:
	rm -f  $(TESTPROGS)
	rm -f  *~
