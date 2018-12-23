
all: adc00.prg adc01.prg adc02.prg \
	adc10.prg adc11.prg adc12.prg \
	sbc00.prg sbc01.prg sbc02.prg \
	sbc10.prg sbc11.prg sbc12.prg \
	arr00.prg arr01.prg arr02.prg \
	arr10.prg arr11.prg arr12.prg \
	sbcEB00.prg sbcEB01.prg sbcEB02.prg \
	sbcEB10.prg sbcEB11.prg sbcEB12.prg \
	isc00.prg isc01.prg isc02.prg isc03.prg \
	isc10.prg isc11.prg isc12.prg isc13.prg \
	rra00.prg rra01.prg rra02.prg rra03.prg \
	rra10.prg rra11.prg rra12.prg rra13.prg \
	scanner.prg
	
decimalmode: decimalmode.c
	gcc -o decimalmode decimalmode.c

RESULTFILES=\
	ref_adc_akku.bin ref_adc_sec_akku.bin \
	ref_sbc_akku.bin ref_sbc_sec_akku.bin \
	ref_arr_akku.bin ref_arr_sec_akku.bin \
	ref_isc_akku.bin ref_isc_sec_akku.bin \
	ref_rra_akku.bin ref_rra_sec_akku.bin \
	ref_adc_flags.bin ref_adc_sec_flags.bin \
	ref_sbc_flags.bin ref_sbc_sec_flags.bin \
	ref_arr_flags.bin ref_arr_sec_flags.bin \
	ref_isc_flags.bin ref_isc_sec_flags.bin \
	ref_rra_flags.bin ref_rra_sec_flags.bin \
	ref_isc_mem.bin ref_isc_sec_mem.bin \
	ref_rra_mem.bin ref_rra_sec_mem.bin

RESULTHTML=\
	adc_akku.html adc_sec_akku.html \
	sbc_akku.html sbc_sec_akku.html \
	arr_akku.html arr_sec_akku.html \
	isc_akku.html isc_sec_akku.html \
	rra_akku.html rra_sec_akku.html \
	adc_flags.html adc_sec_flags.html \
	sbc_flags.html sbc_sec_flags.html \
	arr_flags.html arr_sec_flags.html \
	isc_flags.html isc_sec_flags.html \
	rra_flags.html rra_sec_flags.html \
	isc_mem.html isc_sec_mem.html \
	rra_mem.html rra_sec_mem.html

$(RESULTFILES): decimalmode
	./decimalmode

scanner.prg: scanner.asm
	acme -f cbm -o scanner.prg scanner.asm

adc00.prg: test.asm ref_adc_akku.bin
	acme -f cbm -DINSTR=0 -DCARRY=0 -DSTARTPAGE=0   -DNUMPAGES=86 -o adc00.prg test.asm
adc01.prg: test.asm ref_adc_akku.bin
	acme -f cbm -DINSTR=0 -DCARRY=0 -DSTARTPAGE=86  -DNUMPAGES=86 -o adc01.prg test.asm
adc02.prg: test.asm ref_adc_akku.bin
	acme -f cbm -DINSTR=0 -DCARRY=0 -DSTARTPAGE=172 -DNUMPAGES=84 -o adc02.prg test.asm
adc10.prg: test.asm ref_adc_sec_akku.bin
	acme -f cbm -DINSTR=0 -DCARRY=1 -DSTARTPAGE=0   -DNUMPAGES=86 -o adc10.prg test.asm
adc11.prg: test.asm ref_adc_sec_akku.bin
	acme -f cbm -DINSTR=0 -DCARRY=1 -DSTARTPAGE=86  -DNUMPAGES=86 -o adc11.prg test.asm
adc12.prg: test.asm ref_adc_sec_akku.bin
	acme -f cbm -DINSTR=0 -DCARRY=1 -DSTARTPAGE=172 -DNUMPAGES=84 -o adc12.prg test.asm

sbc00.prg: test.asm ref_sbc_akku.bin
	acme -f cbm -DINSTR=1 -DCARRY=0 -DSTARTPAGE=0   -DNUMPAGES=86 -o sbc00.prg test.asm
sbc01.prg: test.asm ref_sbc_akku.bin
	acme -f cbm -DINSTR=1 -DCARRY=0 -DSTARTPAGE=86  -DNUMPAGES=86 -o sbc01.prg test.asm
sbc02.prg: test.asm ref_sbc_akku.bin
	acme -f cbm -DINSTR=1 -DCARRY=0 -DSTARTPAGE=172 -DNUMPAGES=84 -o sbc02.prg test.asm
sbc10.prg: test.asm ref_sbc_sec_akku.bin
	acme -f cbm -DINSTR=1 -DCARRY=1 -DSTARTPAGE=0   -DNUMPAGES=86 -o sbc10.prg test.asm
sbc11.prg: test.asm ref_sbc_sec_akku.bin
	acme -f cbm -DINSTR=1 -DCARRY=1 -DSTARTPAGE=86  -DNUMPAGES=86 -o sbc11.prg test.asm
sbc12.prg: test.asm ref_sbc_sec_akku.bin
	acme -f cbm -DINSTR=1 -DCARRY=1 -DSTARTPAGE=172 -DNUMPAGES=84 -o sbc12.prg test.asm

arr00.prg: test.asm ref_arr_akku.bin
	acme -f cbm -DINSTR=2 -DCARRY=0 -DSTARTPAGE=0   -DNUMPAGES=86 -o arr00.prg test.asm
arr01.prg: test.asm ref_arr_akku.bin
	acme -f cbm -DINSTR=2 -DCARRY=0 -DSTARTPAGE=86  -DNUMPAGES=86 -o arr01.prg test.asm
arr02.prg: test.asm ref_arr_akku.bin
	acme -f cbm -DINSTR=2 -DCARRY=0 -DSTARTPAGE=172 -DNUMPAGES=84 -o arr02.prg test.asm
arr10.prg: test.asm ref_arr_sec_akku.bin
	acme -f cbm -DINSTR=2 -DCARRY=1 -DSTARTPAGE=0   -DNUMPAGES=86 -o arr10.prg test.asm
arr11.prg: test.asm ref_arr_sec_akku.bin
	acme -f cbm -DINSTR=2 -DCARRY=1 -DSTARTPAGE=86  -DNUMPAGES=86 -o arr11.prg test.asm
arr12.prg: test.asm ref_arr_sec_akku.bin
	acme -f cbm -DINSTR=2 -DCARRY=1 -DSTARTPAGE=172 -DNUMPAGES=84 -o arr12.prg test.asm

sbcEB00.prg: test.asm ref_sbc_akku.bin
	acme -f cbm -DINSTR=3 -DCARRY=0 -DSTARTPAGE=0   -DNUMPAGES=86 -o sbcEB00.prg test.asm
sbcEB01.prg: test.asm ref_sbc_akku.bin
	acme -f cbm -DINSTR=3 -DCARRY=0 -DSTARTPAGE=86  -DNUMPAGES=86 -o sbcEB01.prg test.asm
sbcEB02.prg: test.asm ref_sbc_akku.bin
	acme -f cbm -DINSTR=3 -DCARRY=0 -DSTARTPAGE=172 -DNUMPAGES=84 -o sbcEB02.prg test.asm
sbcEB10.prg: test.asm ref_sbc_sec_akku.bin
	acme -f cbm -DINSTR=3 -DCARRY=1 -DSTARTPAGE=0   -DNUMPAGES=86 -o sbcEB10.prg test.asm
sbcEB11.prg: test.asm ref_sbc_sec_akku.bin
	acme -f cbm -DINSTR=3 -DCARRY=1 -DSTARTPAGE=86  -DNUMPAGES=86 -o sbcEB11.prg test.asm
sbcEB12.prg: test.asm ref_sbc_sec_akku.bin
	acme -f cbm -DINSTR=3 -DCARRY=1 -DSTARTPAGE=172 -DNUMPAGES=84 -o sbcEB12.prg test.asm

isc00.prg: test.asm ref_isc_akku.bin
	acme -f cbm -DINSTR=4 -DCARRY=0 -DSTARTPAGE=0   -DNUMPAGES=64 -o isc00.prg test.asm
isc01.prg: test.asm ref_isc_akku.bin
	acme -f cbm -DINSTR=4 -DCARRY=0 -DSTARTPAGE=64  -DNUMPAGES=64 -o isc01.prg test.asm
isc02.prg: test.asm ref_isc_akku.bin
	acme -f cbm -DINSTR=4 -DCARRY=0 -DSTARTPAGE=128 -DNUMPAGES=64 -o isc02.prg test.asm
isc03.prg: test.asm ref_isc_akku.bin
	acme -f cbm -DINSTR=4 -DCARRY=0 -DSTARTPAGE=192 -DNUMPAGES=64 -o isc03.prg test.asm
isc10.prg: test.asm ref_isc_sec_akku.bin
	acme -f cbm -DINSTR=4 -DCARRY=1 -DSTARTPAGE=0   -DNUMPAGES=64 -o isc10.prg test.asm
isc11.prg: test.asm ref_isc_sec_akku.bin
	acme -f cbm -DINSTR=4 -DCARRY=1 -DSTARTPAGE=64  -DNUMPAGES=64 -o isc11.prg test.asm
isc12.prg: test.asm ref_isc_sec_akku.bin
	acme -f cbm -DINSTR=4 -DCARRY=1 -DSTARTPAGE=128 -DNUMPAGES=64 -o isc12.prg test.asm
isc13.prg: test.asm ref_isc_sec_akku.bin
	acme -f cbm -DINSTR=4 -DCARRY=1 -DSTARTPAGE=192 -DNUMPAGES=64 -o isc13.prg test.asm

rra00.prg: test.asm ref_rra_akku.bin
	acme -f cbm -DINSTR=5 -DCARRY=0 -DSTARTPAGE=0   -DNUMPAGES=64 -o rra00.prg test.asm
rra01.prg: test.asm ref_rra_akku.bin
	acme -f cbm -DINSTR=5 -DCARRY=0 -DSTARTPAGE=64  -DNUMPAGES=64 -o rra01.prg test.asm
rra02.prg: test.asm ref_rra_akku.bin
	acme -f cbm -DINSTR=5 -DCARRY=0 -DSTARTPAGE=128 -DNUMPAGES=64 -o rra02.prg test.asm
rra03.prg: test.asm ref_rra_akku.bin
	acme -f cbm -DINSTR=5 -DCARRY=0 -DSTARTPAGE=192 -DNUMPAGES=64 -o rra03.prg test.asm
rra10.prg: test.asm ref_rra_sec_akku.bin
	acme -f cbm -DINSTR=5 -DCARRY=1 -DSTARTPAGE=0   -DNUMPAGES=64 -o rra10.prg test.asm
rra11.prg: test.asm ref_rra_sec_akku.bin
	acme -f cbm -DINSTR=5 -DCARRY=1 -DSTARTPAGE=64  -DNUMPAGES=64 -o rra11.prg test.asm
rra12.prg: test.asm ref_rra_sec_akku.bin
	acme -f cbm -DINSTR=5 -DCARRY=1 -DSTARTPAGE=128 -DNUMPAGES=64 -o rra12.prg test.asm
rra13.prg: test.asm ref_rra_sec_akku.bin
	acme -f cbm -DINSTR=5 -DCARRY=1 -DSTARTPAGE=192 -DNUMPAGES=64 -o rra13.prg test.asm

	
clean:
	$(RM) decimalmode
	$(RM) adc00.prg adc01.prg adc02.prg
	$(RM) adc10.prg adc11.prg adc12.prg
	$(RM) sbc00.prg sbc01.prg sbc02.prg
	$(RM) sbc10.prg sbc11.prg sbc12.prg
	$(RM) arr00.prg arr01.prg arr02.prg
	$(RM) arr10.prg arr11.prg arr12.prg
	$(RM) sbcEB00.prg sbcEB01.prg sbcEB02.prg
	$(RM) sbcEB10.prg sbcEB11.prg sbcEB12.prg
	$(RM) isc00.prg isc01.prg isc02.prg isc03.prg
	$(RM) isc10.prg isc11.prg isc12.prg isc13.prg
	$(RM) rra00.prg rra01.prg rra02.prg rra03.prg
	$(RM) rra10.prg rra11.prg rra12.prg rra13.prg
	$(RM) scanner.prg
	$(RM) $(RESULTFILES)
	$(RM) $(RESULTHTML)
	
	
