
PETTESTS=\
	4510-pet.prg \
	6509-pet.prg \
	65802or65816-pet.prg \
	65816-pet.prg \
	65ce02-pet.prg \
	65sc02andup-pet.prg \
	65sc02-pet.prg \
	c64dtv-pet.prg \
	new6502-pet.prg \
	old6502-pet.prg \
	start-pet.prg

C64TESTS=\
	4510-c64.prg \
	6509-c64.prg \
	65802or65816-c64.prg \
	65816-c64.prg \
	65ce02-c64.prg \
	65sc02andup-c64.prg \
	65sc02-c64.prg \
	c64dtv-c64.prg \
	new6502-c64.prg \
	old6502-c64.prg \
	start-c64.prg

all: cputest-pet.d64 cputest-c64.d64	
	
4510-pet.prg: 4510.bas
	petcat -l 0401 -w2 -o 4510-pet.prg -- 4510.bas
6509-pet.prg: 6509.bas
	petcat -l 0401 -w2 -o 6509-pet.prg -- 6509.bas
65802or65816-pet.prg: 65802or65816.bas
	petcat -l 0401 -w2 -o 65802or65816-pet.prg -- 65802or65816.bas
65816-pet.prg: 65816.bas
	petcat -l 0401 -w2 -o 65816-pet.prg -- 65816.bas
65ce02-pet.prg: 65ce02.bas
	petcat -l 0401 -w2 -o 65ce02-pet.prg -- 65ce02.bas
65sc02andup-pet.prg: 65sc02andup.bas
	petcat -l 0401 -w2 -o 65sc02andup-pet.prg -- 65sc02andup.bas
65sc02-pet.prg: 65sc02.bas
	petcat -l 0401 -w2 -o 65sc02-pet.prg -- 65sc02.bas
c64dtv-pet.prg: c64dtv.bas
	petcat -l 0401 -w2 -o c64dtv-pet.prg -- c64dtv.bas
new6502-pet.prg: new6502.bas
	petcat -l 0401 -w2 -o new6502-pet.prg -- new6502.bas
old6502-pet.prg: old6502.bas
	petcat -l 0401 -w2 -o old6502-pet.prg -- old6502.bas
start-pet.prg: start.bas
	petcat -l 0401 -w2 -o start-pet.prg -- start.bas
	dd if=/dev/zero bs=1 count=500 >> start-pet.prg

4510-c64.prg: 4510.bas
	petcat -w2 -o 4510-c64.prg -- 4510.bas
6509-c64.prg: 6509.bas
	petcat -w2 -o 6509-c64.prg -- 6509.bas
65802or65816-c64.prg: 65802or65816.bas
	petcat -w2 -o 65802or65816-c64.prg -- 65802or65816.bas
65816-c64.prg: 65816.bas
	petcat -w2 -o 65816-c64.prg -- 65816.bas
65ce02-c64.prg: 65ce02.bas
	petcat -w2 -o 65ce02-c64.prg -- 65ce02.bas
65sc02andup-c64.prg: 65sc02andup.bas
	petcat -w2 -o 65sc02andup-c64.prg -- 65sc02andup.bas
65sc02-c64.prg: 65sc02.bas
	petcat -w2 -o 65sc02-c64.prg -- 65sc02.bas
c64dtv-c64.prg: c64dtv.bas
	petcat -w2 -o c64dtv-c64.prg -- c64dtv.bas
new6502-c64.prg: new6502.bas
	petcat -w2 -o new6502-c64.prg -- new6502.bas
old6502-c64.prg: old6502.bas
	petcat -w2 -o old6502-c64.prg -- old6502.bas
start-c64.prg: start.bas
	petcat -w2 -o start-c64.prg -- start.bas
	dd if=/dev/zero bs=1 count=500 >> start-c64.prg

cputest-pet.d64: $(PETTESTS)
	c1541 -format "cputest,00" d64 cputest-pet.d64 \
		-write start-pet.prg start \
		-write 4510-pet.prg 4510 \
		-write 6509-pet.prg 6509 \
		-write 65802or65816-pet.prg 65802or65816 \
		-write 65816-pet.prg 65816 \
		-write 65ce02-pet.prg 65ce02 \
		-write 65sc02andup-pet.prg 65sc02andup \
		-write 65sc02-pet.prg 65sc02 \
		-write c64dtv-pet.prg c64dtv \
		-write new6502-pet.prg new6502 \
		-write old6502-pet.prg old6502 \
		-list

cputest-c64.d64: $(C64TESTS)
	c1541 -format "cputest,00" d64 cputest-c64.d64 \
		-write start-c64.prg start \
		-write 4510-c64.prg 4510 \
		-write 6509-c64.prg 6509 \
		-write 65802or65816-c64.prg 65802or65816 \
		-write 65816-c64.prg 65816 \
		-write 65ce02-c64.prg 65ce02 \
		-write 65sc02andup-c64.prg 65sc02andup \
		-write 65sc02-c64.prg 65sc02 \
		-write c64dtv-c64.prg c64dtv \
		-write new6502-c64.prg new6502 \
		-write old6502-c64.prg old6502 \
		-list

clean:
	$(RM) $(PETTESTS)
	$(RM) $(C64TESTS)
	$(RM) cputest-pet.d64
	$(RM) cputest-c64.d64
