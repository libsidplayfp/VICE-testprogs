
all: nptest.crt rrtest.crt nrtest.crt artest.crt \
	rr2test.crt nr2test.crt \
	safearramwrite.prg \
	arramwrite.crt rrramwrite.crt npramwrite.crt nrramwrite.crt \
	arramwrite.prg rrramwrite.prg npramwrite.prg nrramwrite.prg \
	rr2ramwrite.crt nr2ramwrite.crt \
	rr2ramwrite.prg nr2ramwrite.prg \
	ardummy.crt rrdummy.crt npdummy.crt nrdummy.crt

artest.bin: main.asm
	acme -f plain -DARMODE=1 -DIO1READ=0 -DRRMODE=0 -o artest.bin main.asm
nptest.bin: main.asm
	acme -f plain -DARMODE=0 -DIO1READ=0 -DRRMODE=0 -o nptest.bin main.asm
rrtest.bin: main.asm
	acme -f plain -DARMODE=2 -DIO1READ=1 -DRRMODE=1 -o rrtest.bin main.asm
nrtest.bin: main.asm
	acme -f plain -DARMODE=0 -DIO1READ=1 -DRRMODE=1 -o nrtest.bin main.asm
rr2test.bin: main.asm
	acme -f plain -DARMODE=2 -DIO1READ=1 -DRRMODE=2 -o rr2test.bin main.asm
nr2test.bin: main.asm
	acme -f plain -DARMODE=0 -DIO1READ=1 -DRRMODE=2 -o nr2test.bin main.asm
	
arramwrite.bin: ramwrite.asm
	acme -f plain -DMAKECRT=1 -DARMODE=1 -DRRMODE=0 -DIO1READ=0 -DARSAFE=0 -o arramwrite.bin ramwrite.asm
npramwrite.bin: ramwrite.asm
	acme -f plain -DMAKECRT=1 -DARMODE=0 -DRRMODE=0 -DIO1READ=0 -DARSAFE=0 -o npramwrite.bin ramwrite.asm
rrramwrite.bin: ramwrite.asm
	acme -f plain -DMAKECRT=1 -DARMODE=2 -DRRMODE=1 -DIO1READ=1 -DARSAFE=0 -o rrramwrite.bin ramwrite.asm
nrramwrite.bin: ramwrite.asm
	acme -f plain -DMAKECRT=1 -DARMODE=0 -DRRMODE=1 -DIO1READ=1 -DARSAFE=0 -o nrramwrite.bin ramwrite.asm
rr2ramwrite.bin: ramwrite.asm
	acme -f plain -DMAKECRT=1 -DARMODE=2 -DRRMODE=2 -DIO1READ=1 -DARSAFE=0 -o rr2ramwrite.bin ramwrite.asm
nr2ramwrite.bin: ramwrite.asm
	acme -f plain -DMAKECRT=1 -DARMODE=0 -DRRMODE=2 -DIO1READ=1 -DARSAFE=0 -o nr2ramwrite.bin ramwrite.asm

safearramwrite.prg: ramwrite.asm
	acme -f cbm -DMAKECRT=0 -DARMODE=1 -DRRMODE=0 -DIO1READ=0 -DARSAFE=1 -o safearramwrite.prg ramwrite.asm
arramwrite.prg: ramwrite.asm
	acme -f cbm -DMAKECRT=0 -DARMODE=1 -DRRMODE=0 -DIO1READ=0 -DARSAFE=0 -o arramwrite.prg ramwrite.asm
npramwrite.prg: ramwrite.asm
	acme -f cbm -DMAKECRT=0 -DARMODE=0 -DRRMODE=0 -DIO1READ=0 -DARSAFE=0 -o npramwrite.prg ramwrite.asm
rrramwrite.prg: ramwrite.asm
	acme -f cbm -DMAKECRT=0 -DARMODE=2 -DRRMODE=1 -DIO1READ=1 -DARSAFE=0 -o rrramwrite.prg ramwrite.asm
nrramwrite.prg: ramwrite.asm
	acme -f cbm -DMAKECRT=0 -DARMODE=0 -DRRMODE=1 -DIO1READ=1 -DARSAFE=0 -o nrramwrite.prg ramwrite.asm
rr2ramwrite.prg: ramwrite.asm
	acme -f cbm -DMAKECRT=0 -DARMODE=2 -DRRMODE=2 -DIO1READ=1 -DARSAFE=0 -o rr2ramwrite.prg ramwrite.asm
nr2ramwrite.prg: ramwrite.asm
	acme -f cbm -DMAKECRT=0 -DARMODE=0 -DRRMODE=2 -DIO1READ=1 -DARSAFE=0 -o nr2ramwrite.prg ramwrite.asm
	
	
artest.crt: artest.bin
	cartconv -p -t ar5 -i artest.bin -o artest.crt
nptest.crt: nptest.bin
	cartconv -p -t ap -i nptest.bin -o nptest.crt
rrtest.crt: rrtest.bin
	cartconv -p -t rr -i rrtest.bin -o rrtest.crt
nrtest.crt: nrtest.bin
	cartconv -p -s 1 -t rr -i nrtest.bin -o nrtest.crt
rr2test.crt: rr2test.bin
	cartconv -p -t rr -i rr2test.bin -o rr2test.crt
nr2test.crt: nr2test.bin
	cartconv -p -s 1 -t rr -i nr2test.bin -o nr2test.crt

arramwrite.crt: arramwrite.bin
	cartconv -p -t ar5 -i arramwrite.bin -o arramwrite.crt
npramwrite.crt: npramwrite.bin
	cartconv -p -t ap -i npramwrite.bin -o npramwrite.crt
rrramwrite.crt: rrramwrite.bin
	cartconv -p -t rr -i rrramwrite.bin -o rrramwrite.crt
nrramwrite.crt: nrramwrite.bin
	cartconv -p -s 1 -t rr -i nrramwrite.bin -o nrramwrite.crt
rr2ramwrite.crt: rr2ramwrite.bin
	cartconv -p -t rr -i rr2ramwrite.bin -o rr2ramwrite.crt
nr2ramwrite.crt: nr2ramwrite.bin
	cartconv -p -s 1 -t rr -i nr2ramwrite.bin -o nr2ramwrite.crt

ardummy.crt:
	echo "-action replay--" > ardummy.bin
	cartconv -p -t ar5 -i ardummy.bin -o ardummy.crt
npdummy.crt:
	echo "-nordic power---" > npdummy.bin
	cartconv -p -t ap -i npdummy.bin -o npdummy.crt
rrdummy.crt:
	echo "-retro replay---" > rrdummy.bin
	cartconv -p -t rr -i rrdummy.bin -o rrdummy.crt
nrdummy.crt:
	echo "-nordic replay--" > npdummy.bin
	cartconv -p -s 1 -t rr -i npdummy.bin -o nrdummy.crt

clean:
	$(RM) nptest.bin rrtest.bin nrtest.bin artest.bin rr2test.bin nr2test.bin 
	$(RM) nptest.crt rrtest.crt nrtest.crt artest.crt rr2test.crt nr2test.crt 
	$(RM) safearramwrite.prg
	$(RM) arramwrite.bin rrramwrite.bin npramwrite.bin nrramwrite.bin
	$(RM) arramwrite.crt rrramwrite.crt npramwrite.crt nrramwrite.crt
	$(RM) arramwrite.prg rrramwrite.prg npramwrite.prg nrramwrite.prg
	$(RM) rr2ramwrite.bin nr2ramwrite.bin
	$(RM) rr2ramwrite.crt nr2ramwrite.crt
	$(RM) rr2ramwrite.prg nr2ramwrite.prg
	$(RM) ardummy.bin npdummy.bin rrdummy.bin nrdummy.bin
	$(RM) ardummy.crt npdummy.crt rrdummy.crt nrdummy.crt
