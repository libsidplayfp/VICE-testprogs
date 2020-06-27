
COMMONFILES=\
	common.inc \
	common.asm \
	test-common.asm \
	text-common.asm

all: aracidtest.prg AR+Co_AcidRamTest.d64 \
	test-ramdetect.prg \
	test-ramsizedetect.prg \
	test-ariotest1.prg \
	test-ariotest2.prg \
	test-arramtest2.prg \
	test-ramdetect-ar.prg \
	test-ramsizedetect-ar.prg \
	test-ariotest1-ar.prg \
	test-ariotest2-ar.prg \
	test-arramtest2-ar.prg \
	test-arramtest2-nr.prg \
	ardummy.crt \
	npdummy.crt \
	rrdummy.crt \
	nrdummy.crt

aracidtest.prg: aracidtest.asm $(COMMONFILES)
	dreamass -o aracidtest.prg aracidtest.asm

AR+Co_AcidRamTest.d64: aracidtest.prg
	c1541 -format "ar acid ramtest,cz" d64 AR+Co_AcidRamTest.d64 \
		-write aracidtest.prg "acid ramtest 0.1"
	
test-ramdetect.prg: test-ramdetect.asm text-ramdetect.asm $(COMMONFILES)
	dreamass -DSTANDALONE -DIOMODE=1 -DCARTMODE=2 -o test-ramdetect.prg test-ramdetect.asm
test-ramsizedetect.prg: test-ramsizedetect.asm text-ramsizedetect.asm $(COMMONFILES)
	dreamass -DSTANDALONE -DIOMODE=1 -DCARTMODE=2 -o test-ramsizedetect.prg test-ramsizedetect.asm
test-ariotest1.prg: test-ariotest1.asm text-ariotest1.asm $(COMMONFILES)
	dreamass -DSTANDALONE -DIOMODE=1 -DCARTMODE=2 -o test-ariotest1.prg test-ariotest1.asm
test-ariotest2.prg: test-ariotest2.asm text-ariotest2.asm $(COMMONFILES)
	dreamass -DSTANDALONE -DIOMODE=1 -DCARTMODE=2 -o test-ariotest2.prg test-ariotest2.asm
test-arramtest2.prg: test-arramtest2.asm text-arramtest2.asm $(COMMONFILES)
	dreamass -DSTANDALONE -DIOMODE=1 -DCARTMODE=2 -o test-arramtest2.prg test-arramtest2.asm

test-ramdetect-ar.prg: test-ramdetect.asm text-ramdetect.asm $(COMMONFILES)
	dreamass -DSTANDALONE -DIOMODE=0 -DCARTMODE=0 -o test-ramdetect-ar.prg test-ramdetect.asm
test-ramsizedetect-ar.prg: test-ramsizedetect.asm text-ramsizedetect.asm $(COMMONFILES)
	dreamass -DSTANDALONE -DIOMODE=0 -DCARTMODE=0 -o test-ramsizedetect-ar.prg test-ramsizedetect.asm
test-ariotest1-ar.prg: test-ariotest1.asm text-ariotest1.asm $(COMMONFILES)
	dreamass -DSTANDALONE -DIOMODE=0 -DCARTMODE=0 -o test-ariotest1-ar.prg test-ariotest1.asm
test-ariotest2-ar.prg: test-ariotest2.asm text-ariotest2.asm $(COMMONFILES)
	dreamass -DSTANDALONE -DIOMODE=0 -DCARTMODE=0 -o test-ariotest2-ar.prg test-ariotest2.asm
test-arramtest2-ar.prg: test-arramtest2.asm text-arramtest2.asm $(COMMONFILES)
	dreamass -DSTANDALONE -DIOMODE=0 -DCARTMODE=0 -o test-arramtest2-ar.prg test-arramtest2.asm

test-arramtest2-nr.prg: test-arramtest2.asm text-arramtest2.asm $(COMMONFILES)
	dreamass -DSTANDALONE -DIOMODE=1 -DCARTMODE=3 -o test-arramtest2-nr.prg test-arramtest2.asm
	
ardummy.crt:
	echo "-------------------------------" > ardummy.bin
	cartconv -p -t ar5 -i ardummy.bin -o ardummy.crt
	$(RM) ardummy.bin
npdummy.crt:
	echo "-------------------------------" > npdummy.bin
	cartconv -p -t ap -i npdummy.bin -o npdummy.crt
	$(RM) npdummy.bin
rrdummy.crt:
	echo "-------------------------------" > rrdummy.bin
	cartconv -p -t rr -i rrdummy.bin -o rrdummy.crt
	$(RM) rrdummy.bin
nrdummy.crt:
	echo "-------------------------------" > nrdummy.bin
	cartconv -p -t rr -s 1 -i nrdummy.bin -o nrdummy.crt
	$(RM) nrdummy.bin
	
clean:
	$(RM) aracidtest.prg
	$(RM) test-ramdetect.prg
	$(RM) test-ramsizedetect.prg
	$(RM) test-ariotest1.prg
	$(RM) test-ariotest2.prg
	$(RM) test-arramtest2.prg
	$(RM) test-ramdetect-ar.prg
	$(RM) test-ramsizedetect-ar.prg
	$(RM) test-ariotest1-ar.prg
	$(RM) test-ariotest2-ar.prg
	$(RM) test-arramtest2-ar.prg
	$(RM) test-arramtest2-nr.prg
	$(RM) ardummy.crt
	$(RM) npdummy.crt
	$(RM) rrdummy.crt
	$(RM) nrdummy.crt
	
