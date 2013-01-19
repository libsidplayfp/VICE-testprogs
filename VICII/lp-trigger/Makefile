 

all:
	cl65 -t c64 -o test1.prg test1.s stableraster_lightpen.s
	cl65 -t c64 -o test2.prg test2.s
	acme lpcart.s
	cartconv -t ulti -i lpcart.bin -o lpcart.crt

clean:
	rm -f *~
	rm -f *.o
	rm -f lpcart.bin lpcart.crt
	rm -f *.prg

