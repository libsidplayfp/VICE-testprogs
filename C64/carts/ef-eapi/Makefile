

all: test-eapi.crt

################################################################################

padmark: padmark.c
	gcc -Wall -o padmark padmark.c

bank0.bin: ef-startup.asm
	acme -f plain --initmem 0xff -o bank0.bin ef-startup.asm

################################################################################

testeapi.bin: testeapi.asm
	acme --initmem 0xff -o testeapi.bin testeapi.asm

testeapi-image.bin: bank0.bin testeapi.bin
	dd if=bank0.bin ibs=16k count=1 of=testeapi-image.bin conv=sync
	dd if=testeapi.bin ibs=32k count=1 of=testeapi-image.bin oflag=append conv=notrunc,sync

testeapi-padded.bin: testeapi-image.bin padmark
	./padmark testeapi-image.bin testeapi-padded.bin

test-eapi.crt: testeapi-padded.bin
	cartconv -t easy -i testeapi-padded.bin -o test-eapi.crt

################################################################################

testeapi: test-eapi.crt
	x64sc -default +easyflashcrtwrite -cartcrt test-eapi.crt
	
clean:
	$(RM) padmark
	$(RM) bank0.bin
	$(RM) testeapi.bin
	$(RM) testeapi-image.bin
	$(RM) testeapi-padded.bin
	$(RM) test-eapi.crt
