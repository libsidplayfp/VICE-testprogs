PROGS=\
	c64-dqbb-emd.prg \
	c64-georam-emd.prg \
	c64-isepic-emd.prg \
	c64-ram-emd.prg \
	c64-ramcart-emd.prg \
	c64-reu-emd.prg \
	c64-vdc-emd.prg \
	c64-dtv-himem-emd.prg \
	c128-efnram-emd.prg \
	c128-georam-emd.prg \
	c128-ifnram-emd.prg \
	c128-ram-emd.prg \
	c128-ram2-emd.prg \
	c128-ramcart-emd.prg \
	c128-reu-emd.prg \
	c128-vdc-emd.prg \
	c16-ram-emd.prg \
	cbm510-ram-emd.prg \
	cbm610-ram-emd.prg \
	vic20-rama-emd.prg

all:	$(PROGS)

c64-dqbb-emd.prg:	c64-dqbb-emd.o em-test.c
	cl65 -t c64 -o c64-dqbb-emd.prg em-test.c c64-dqbb-emd.o

c64-dqbb-emd.o:	c64-dqbb-emd.s
	ca65 c64-dqbb-emd.s

c64-dqbb-emd.s: $(shell cl65 --print-target-path)/c64/drv/emd/c64-dqbb.emd
	co65 -o c64-dqbb-emd.s --code-label _emd_test $(shell cl65 --print-target-path)/c64/drv/emd/c64-dqbb.emd

c64-georam-emd.prg:	c64-georam-emd.o em-test.c
	cl65 -t c64 -o c64-georam-emd.prg em-test.c c64-georam-emd.o

c64-georam-emd.o:	c64-georam-emd.s
	ca65 c64-georam-emd.s

c64-georam-emd.s: $(shell cl65 --print-target-path)/c64/drv/emd/c64-georam.emd
	co65 -o c64-georam-emd.s --code-label _emd_test $(shell cl65 --print-target-path)/c64/drv/emd/c64-georam.emd

c64-isepic-emd.prg:	c64-isepic-emd.o em-test.c
	cl65 -t c64 -o c64-isepic-emd.prg em-test.c c64-isepic-emd.o

c64-isepic-emd.o:	c64-isepic-emd.s
	ca65 c64-isepic-emd.s

c64-isepic-emd.s: $(shell cl65 --print-target-path)/c64/drv/emd/c64-isepic.emd
	co65 -o c64-isepic-emd.s --code-label _emd_test $(shell cl65 --print-target-path)/c64/drv/emd/c64-isepic.emd

c64-ram-emd.prg:	c64-ram-emd.o em-test.c
	cl65 -t c64 -o c64-ram-emd.prg em-test.c c64-ram-emd.o

c64-ram-emd.o:	c64-ram-emd.s
	ca65 c64-ram-emd.s

c64-ram-emd.s: $(shell cl65 --print-target-path)/c64/drv/emd/c64-ram.emd
	co65 -o c64-ram-emd.s --code-label _emd_test $(shell cl65 --print-target-path)/c64/drv/emd/c64-ram.emd

c64-ramcart-emd.prg:	c64-ramcart-emd.o em-test.c
	cl65 -t c64 -o c64-ramcart-emd.prg em-test.c c64-ramcart-emd.o

c64-ramcart-emd.o:	c64-ramcart-emd.s
	ca65 c64-ramcart-emd.s

c64-ramcart-emd.s: $(shell cl65 --print-target-path)/c64/drv/emd/c64-ramcart.emd
	co65 -o c64-ramcart-emd.s --code-label _emd_test $(shell cl65 --print-target-path)/c64/drv/emd/c64-ramcart.emd

c64-reu-emd.prg:	c64-reu-emd.o em-test.c
	cl65 -t c64 -o c64-reu-emd.prg em-test.c c64-reu-emd.o

c64-reu-emd.o:	c64-reu-emd.s
	ca65 c64-reu-emd.s

c64-reu-emd.s: $(shell cl65 --print-target-path)/c64/drv/emd/c64-reu.emd
	co65 -o c64-reu-emd.s --code-label _emd_test $(shell cl65 --print-target-path)/c64/drv/emd/c64-reu.emd

c64-vdc-emd.prg:	c64-vdc-emd.o em-test.c
	cl65 -t c64 -o c64-vdc-emd.prg em-test.c c64-vdc-emd.o

c64-vdc-emd.o:	c64-vdc-emd.s
	ca65 c64-vdc-emd.s

c64-vdc-emd.s: $(shell cl65 --print-target-path)/c64/drv/emd/c64-vdc.emd
	co65 -o c64-vdc-emd.s --code-label _emd_test $(shell cl65 --print-target-path)/c64/drv/emd/c64-vdc.emd

c64-dtv-himem-emd.prg:	c64-dtv-himem-emd.o em-test.c
	cl65 -t c64 -o c64-dtv-himem-emd.prg em-test.c c64-dtv-himem-emd.o

c64-dtv-himem-emd.o:	c64-dtv-himem-emd.s
	ca65 c64-dtv-himem-emd.s

c64-dtv-himem-emd.s: $(shell cl65 --print-target-path)/c64/drv/emd/dtv-himem.emd
	co65 -o c64-dtv-himem-emd.s --code-label _emd_test $(shell cl65 --print-target-path)/c64/drv/emd/dtv-himem.emd

c128-efnram-emd.prg:	c128-efnram-emd.o em-test.c
	cl65 -t c128 -o c128-efnram-emd.prg em-test.c c128-efnram-emd.o

c128-efnram-emd.o:	c128-efnram-emd.s
	ca65 c128-efnram-emd.s

c128-efnram-emd.s: $(shell cl65 --print-target-path)/c128/drv/emd/c128-efnram.emd
	co65 -o c128-efnram-emd.s --code-label _emd_test $(shell cl65 --print-target-path)/c128/drv/emd/c128-efnram.emd

c128-georam-emd.prg:	c128-georam-emd.o em-test.c
	cl65 -t c128 -o c128-georam-emd.prg em-test.c c128-georam-emd.o

c128-georam-emd.o:	c128-georam-emd.s
	ca65 c128-georam-emd.s

c128-georam-emd.s: $(shell cl65 --print-target-path)/c128/drv/emd/c128-georam.emd
	co65 -o c128-georam-emd.s --code-label _emd_test $(shell cl65 --print-target-path)/c128/drv/emd/c128-georam.emd

c128-ifnram-emd.prg:	c128-ifnram-emd.o em-test.c
	cl65 -t c128 -o c128-ifnram-emd.prg em-test.c c128-ifnram-emd.o

c128-ifnram-emd.o:	c128-ifnram-emd.s
	ca65 c128-ifnram-emd.s

c128-ifnram-emd.s: $(shell cl65 --print-target-path)/c128/drv/emd/c128-ifnram.emd
	co65 -o c128-ifnram-emd.s --code-label _emd_test $(shell cl65 --print-target-path)/c128/drv/emd/c128-ifnram.emd

c128-ram-emd.prg:	c128-ram-emd.o em-test.c
	cl65 -t c128 -o c128-ram-emd.prg em-test.c c128-ram-emd.o

c128-ram-emd.o:	c128-ram-emd.s
	ca65 c128-ram-emd.s

c128-ram-emd.s: $(shell cl65 --print-target-path)/c128/drv/emd/c128-ram.emd
	co65 -o c128-ram-emd.s --code-label _emd_test $(shell cl65 --print-target-path)/c128/drv/emd/c128-ram.emd

c128-ram2-emd.prg:	c128-ram2-emd.o em-test.c
	cl65 -t c128 -o c128-ram2-emd.prg em-test.c c128-ram2-emd.o

c128-ram2-emd.o:	c128-ram2-emd.s
	ca65 c128-ram2-emd.s

c128-ram2-emd.s: $(shell cl65 --print-target-path)/c128/drv/emd/c128-ram2.emd
	co65 -o c128-ram2-emd.s --code-label _emd_test $(shell cl65 --print-target-path)/c128/drv/emd/c128-ram2.emd

c128-ramcart-emd.prg:	c128-ramcart-emd.o em-test.c
	cl65 -t c128 -o c128-ramcart-emd.prg em-test.c c128-ramcart-emd.o

c128-ramcart-emd.o:	c128-ramcart-emd.s
	ca65 c128-ramcart-emd.s

c128-ramcart-emd.s: $(shell cl65 --print-target-path)/c128/drv/emd/c128-ramcart.emd
	co65 -o c128-ramcart-emd.s --code-label _emd_test $(shell cl65 --print-target-path)/c128/drv/emd/c128-ramcart.emd

c128-reu-emd.prg:	c128-reu-emd.o em-test.c
	cl65 -t c128 -o c128-reu-emd.prg em-test.c c128-reu-emd.o

c128-reu-emd.o:	c128-reu-emd.s
	ca65 c128-reu-emd.s

c128-reu-emd.s: $(shell cl65 --print-target-path)/c128/drv/emd/c128-reu.emd
	co65 -o c128-reu-emd.s --code-label _emd_test $(shell cl65 --print-target-path)/c128/drv/emd/c128-reu.emd

c128-vdc-emd.prg:	c128-vdc-emd.o em-test.c
	cl65 -t c128 -o c128-vdc-emd.prg em-test.c c128-vdc-emd.o

c128-vdc-emd.o:	c128-vdc-emd.s
	ca65 c128-vdc-emd.s

c128-vdc-emd.s: $(shell cl65 --print-target-path)/c128/drv/emd/c128-vdc.emd
	co65 -o c128-vdc-emd.s --code-label _emd_test $(shell cl65 --print-target-path)/c128/drv/emd/c128-vdc.emd

c16-ram-emd.prg:	c16-ram-emd.o em-test.c
	cl65 -t c16 -o c16-ram-emd.prg em-test.c c16-ram-emd.o

c16-ram-emd.o:	c16-ram-emd.s
	ca65 c16-ram-emd.s

c16-ram-emd.s: $(shell cl65 --print-target-path)/c16/drv/emd/c16-ram.emd
	co65 -o c16-ram-emd.s --code-label _emd_test $(shell cl65 --print-target-path)/c16/drv/emd/c16-ram.emd

cbm510-ram-emd.prg:	cbm510-ram-emd.o em-test.c
	cl65 -t cbm510 -o cbm510-ram-emd.prg em-test.c cbm510-ram-emd.o

cbm510-ram-emd.o:	cbm510-ram-emd.s
	ca65 cbm510-ram-emd.s

cbm510-ram-emd.s: $(shell cl65 --print-target-path)/cbm510/drv/emd/cbm510-ram.emd
	co65 -o cbm510-ram-emd.s --code-label _emd_test $(shell cl65 --print-target-path)/cbm510/drv/emd/cbm510-ram.emd

cbm610-ram-emd.prg:	cbm610-ram-emd.o em-test.c
	cl65 -t cbm610 -o cbm610-ram-emd.prg em-test.c cbm610-ram-emd.o

cbm610-ram-emd.o:	cbm610-ram-emd.s
	ca65 cbm610-ram-emd.s

cbm610-ram-emd.s: $(shell cl65 --print-target-path)/cbm610/drv/emd/cbm610-ram.emd
	co65 -o cbm610-ram-emd.s --code-label _emd_test $(shell cl65 --print-target-path)/cbm610/drv/emd/cbm610-ram.emd

vic20-rama-emd.prg:	vic20-rama-emd.o em-test.c
	cl65 -t vic20 -C vic20-32k.cfg -o vic20-rama-emd.prg em-test.c vic20-rama-emd.o

vic20-rama-emd.o:	vic20-rama-emd.s
	ca65 vic20-rama-emd.s

vic20-rama-emd.s: $(shell cl65 --print-target-path)/vic20/drv/emd/vic20-rama.emd
	co65 -o vic20-rama-emd.s --code-label _emd_test $(shell cl65 --print-target-path)/vic20/drv/emd/vic20-rama.emd

clean:
	rm -f *.o
	rm -f *.s
