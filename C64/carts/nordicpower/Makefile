
all: nptest.crt rrtest.crt nrtest.crt \
	npramwrite.crt nrramwrite.crt ramwrite.prg \
	npdummy.crt nrdummy.crt

nptest.bin: main.asm
	acme -f plain -o nptest.bin main.asm
ramwrite.bin: ramwrite.asm
	acme -f plain -DMAKECRT=1 -o ramwrite.bin ramwrite.asm
ramwrite.prg: ramwrite.asm
	acme -f cbm -DMAKECRT=0 -o ramwrite.prg ramwrite.asm
	
	
nptest.crt: nptest.bin
	cartconv -p -t ap -i nptest.bin -o nptest.crt
rrtest.crt: nptest.bin
	cartconv -p -t rr -i nptest.bin -o rrtest.crt
nrtest.crt: nptest.bin
	cartconv -p -s 1 -t rr -i nptest.bin -o nrtest.crt

npramwrite.crt: ramwrite.bin
	cartconv -p -t ap -i ramwrite.bin -o npramwrite.crt
nrramwrite.crt: ramwrite.bin
	cartconv -p -s 1 -t rr -i ramwrite.bin -o nrramwrite.crt

npdummy.crt:
	echo "----------------" > npdummy.bin
	cartconv -p -t ap -i npdummy.bin -o npdummy.crt
nrdummy.crt:
	echo "----------------" > npdummy.bin
	cartconv -p -s 1 -t rr -i npdummy.bin -o nrdummy.crt

clean:
	$(RM) npdummy.crt nrdummy.crt
	$(RM) npramwrite.crt nrramwrite.crt ramwrite.prg
	$(RM) nptest.crt rrtest.crt nrtest.crt
	$(RM) nptest.bin ramwrite.bin npdummy.bin
