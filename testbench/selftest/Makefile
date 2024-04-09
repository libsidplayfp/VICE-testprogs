
all: c64-pass.prg c64-fail.prg \
	c64-pass.d64 \
	c64-pass.crt c64-fail.crt \
	plus4-pass.prg plus4-fail.prg \
	plus4-pass.d64 \
	scpu-pass.prg scpu-fail.prg \
	scpu-pass.d64 \
	dtv-pass.prg dtv-fail.prg \
	dtv-pass.d64 \
	c128-pass.prg c128-fail.prg \
	c128-pass.d64 \
	vic20-pass.prg vic20-fail.prg \
	vic20-pass.d64 \
	vic20-pass.crt vic20-fail.crt \
	pet-pass.prg pet-fail.prg \
	pet-pass.d82 \
	cbm610-pass.prg cbm610-fail.prg \
	cbm610-pass.d82 \
	cbm510-pass.prg cbm510-fail.prg \
	cbm510-pass.d82 \
	vsid-pass.prg vsid-fail.prg

c64-pass.prg: c64.asm
	acme -DCART=0 -DFAIL=0 -f cbm -o c64-pass.prg c64.asm
c64-fail.prg: c64.asm
	acme -DCART=0 -DFAIL=1 -f cbm -o c64-fail.prg c64.asm
c64-pass.d64: c64-pass.prg
	c1541 -format "c64 pass,00" d64 c64-pass.d64 \
		-write c64-pass.prg "c64-pass"
c64-pass.crt: c64.asm
	acme -DCART=1 -DFAIL=0 -f plain -o c64-pass.bin c64.asm
	cartconv -p -t normal -i c64-pass.bin -o c64-pass.crt
c64-fail.crt: c64.asm
	acme -DCART=1 -DFAIL=1 -f plain -o c64-fail.bin c64.asm
	cartconv -p -t normal -i c64-fail.bin -o c64-fail.crt
plus4-pass.prg: plus4.asm
	acme -DFAIL=0 -f cbm -o plus4-pass.prg plus4.asm
plus4-pass.d64: plus4-pass.prg
	c1541 -format "plus4 pass,00" d64 plus4-pass.d64 \
		-write plus4-pass.prg "plus4-pass"
plus4-fail.prg: plus4.asm
	acme -DFAIL=1 -f cbm -o plus4-fail.prg plus4.asm
scpu-pass.prg: scpu.asm
	acme -DFAIL=0 -f cbm -o scpu-pass.prg scpu.asm
scpu-fail.prg: scpu.asm
	acme -DFAIL=1 -f cbm -o scpu-fail.prg scpu.asm
scpu-pass.d64: scpu-pass.prg
	c1541 -format "scpu pass,00" d64 scpu-pass.d64 \
		-write scpu-pass.prg "scpu-pass"
dtv-pass.prg: dtv.asm
	acme -DFAIL=0 -f cbm -o dtv-pass.prg dtv.asm
dtv-fail.prg: dtv.asm
	acme -DFAIL=1 -f cbm -o dtv-fail.prg dtv.asm
dtv-pass.d64: dtv-pass.prg
	c1541 -format "dtv pass,00" d64 dtv-pass.d64 \
		-write dtv-pass.prg "dtv-pass"
vic20-pass.prg: vic20.asm
	acme -DEXPANDED=1 -DCART=0 -DFAIL=0 -f cbm -o vic20-pass.prg vic20.asm
vic20-fail.prg: vic20.asm
	acme -DEXPANDED=1 -DCART=0 -DFAIL=1 -f cbm -o vic20-fail.prg vic20.asm
vic20-pass.crt: vic20.asm
	acme -DEXPANDED=0 -DCART=1 -DFAIL=0 -f plain -o vic20-pass.bin vic20.asm
	cartconv -p -t vic20 -l 0xa000 -i vic20-pass.bin -o vic20-pass.crt
vic20-fail.crt: vic20.asm
	acme -DEXPANDED=0 -DCART=1 -DFAIL=1 -f plain -o vic20-fail.bin vic20.asm
	cartconv -p -t vic20 -l 0xa000 -i vic20-fail.bin -o vic20-fail.crt
vic20-pass.d64: vic20-pass.prg
	c1541 -format "vic20 pass,00" d64 vic20-pass.d64 \
		-write vic20-pass.prg "vic20-pass"
c128-pass.prg: c128.asm
	acme -DFAIL=0 -f cbm -o c128-pass.prg c128.asm
c128-fail.prg: c128.asm
	acme -DFAIL=1 -f cbm -o c128-fail.prg c128.asm
c128-pass.d64: scpu-pass.prg
	c1541 -format "c128 pass,00" d64 c128-pass.d64 \
		-write c128-pass.prg "c128-pass"
pet-pass.prg: pet.asm
	acme -DFAIL=0 -f cbm -o pet-pass.prg pet.asm
pet-fail.prg: pet.asm
	acme -DFAIL=1 -f cbm -o pet-fail.prg pet.asm
pet-pass.d82: pet-pass.prg
	c1541 -format "pet pass,00" d82 pet-pass.d82 \
		-write pet-pass.prg "pet-pass"
vsid-pass.prg: vsid.asm
	acme -DFAIL=0 -f plain -o vsid-pass.sid vsid.asm
vsid-fail.prg: vsid.asm
	acme -DFAIL=1 -f plain -o vsid-fail.sid vsid.asm
cbm610-pass.prg: cbm610.asm
	acme -DFAIL=0 -f cbm -o cbm610-pass.prg cbm610.asm
cbm610-fail.prg: cbm610.asm
	acme -DFAIL=1 -f cbm -o cbm610-fail.prg cbm610.asm
cbm610-pass.d82: cbm610-pass.prg
	c1541 -format "cbm610 pass,00" d82 cbm610-pass.d82 \
		-write cbm610-pass.prg "cbm610-pass"
cbm510-pass.prg: cbm510.asm
	acme -DFAIL=0 -f cbm -o cbm510-pass.prg cbm510.asm
cbm510-fail.prg: cbm510.asm
	acme -DFAIL=1 -f cbm -o cbm510-fail.prg cbm510.asm
cbm510-pass.d82: cbm510-pass.prg
	c1541 -format "cbm510 pass,00" d82 cbm510-pass.d82 \
		-write cbm510-pass.prg "cbm510-pass"

clean:
	$(RM) *.prg
	$(RM) *.bin
	$(RM) *.crt
