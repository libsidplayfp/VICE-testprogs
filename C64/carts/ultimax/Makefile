
all: ultimax-ef.crt ultimax-rr.crt ultimax-vic-ef.crt ultimax-vic-rr.crt \
	8k-vic-ef.crt 8k-vic-rr.crt 16k-vic-ef.crt 16k-vic-rr.crt

ultimax-ef.crt: main.asm
	acme -DCARTTYPE=0 --initmem 0x5a -f plain -o ultimax-ef.bin main.asm
	cartconv -p -t easy -i ultimax-ef.bin -o ultimax-ef.crt
	
ultimax-rr.crt: main.asm
	acme -DCARTTYPE=1 --initmem 0x5a -f plain -o ultimax-rr.bin main.asm
	cartconv -p -t rr -i ultimax-rr.bin -o ultimax-rr.crt
	
ultimax-vic-ef.crt: vic-ef.asm vic.asm
	acme -DMODE=0 --initmem 0x5a -f plain -o ultimax-vic-ef.bin vic-ef.asm
	cartconv -p -t easy -i ultimax-vic-ef.bin -o ultimax-vic-ef.crt
ultimax-vic-rr.crt: vic-rr.asm vic.asm
	acme -DMODE=0 --initmem 0x5a -f plain -o ultimax-vic-rr.bin vic-rr.asm
	cartconv -p -t rr -i ultimax-vic-rr.bin -o ultimax-vic-rr.crt
	
8k-vic-ef.crt: vic-ef.asm vic.asm
	acme -DMODE=1 --initmem 0x5a -f plain -o 8k-vic-ef.bin vic-ef.asm
	cartconv -p -t easy -i 8k-vic-ef.bin -o 8k-vic-ef.crt
8k-vic-rr.crt: vic-rr.asm vic.asm
	acme -DMODE=1 --initmem 0x5a -f plain -o 8k-vic-rr.bin vic-rr.asm
	cartconv -p -t rr -i 8k-vic-rr.bin -o 8k-vic-rr.crt
	
16k-vic-ef.crt: vic-ef.asm vic.asm
	acme -DMODE=2 --initmem 0x5a -f plain -o 16k-vic-ef.bin vic-ef.asm
	cartconv -p -t easy -i 16k-vic-ef.bin -o 16k-vic-ef.crt
16k-vic-rr.crt: vic-rr.asm vic.asm
	acme -DMODE=2 --initmem 0x5a -f plain -o 16k-vic-rr.bin vic-rr.asm
	cartconv -p -t rr -i 16k-vic-rr.bin -o 16k-vic-rr.crt
	
clean:
	rm -f ultimax-ef.bin ultimax-ef.crt
	rm -f ultimax-rr.bin ultimax-rr.crt
	rm -f ultimax-vic-ef.bin ultimax-vic-ef.crt
	rm -f ultimax-vic-rr.bin ultimax-vic-rr.crt
	rm -f 8k-vic-ef.bin 8k-vic-ef.crt
	rm -f 8k-vic-rr.bin 8k-vic-rr.crt
	rm -f 16k-vic-ef.bin 16k-vic-ef.crt
	rm -f 16k-vic-rr.bin 16k-vic-rr.crt

