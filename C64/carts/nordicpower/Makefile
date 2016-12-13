
all: nptest.bin nptest.crt rrtest.crt

nptest.bin: main.asm
	acme -f plain -o nptest.bin main.asm
	
nptest.crt: nptest.bin
	cartconv -p -t ap -i nptest.bin -o nptest.crt
rrtest.crt: nptest.bin
	cartconv -p -t rr -i nptest.bin -o rrtest.crt
