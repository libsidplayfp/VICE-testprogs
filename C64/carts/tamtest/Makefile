
all: tamtest.crt

tamtest.crt: tamtest.asm
	acme -f plain -o tamtest.crt tamtest.asm

clean:
	rm -f tamtest.crt
	rm -f *~
