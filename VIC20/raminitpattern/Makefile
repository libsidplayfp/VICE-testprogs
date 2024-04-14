
all: ae.crt jellymonsters.crt

ae.crt: cart.asm
	acme -DTEST=0 -DEXPANDED=0 -f plain -o cart.bin cart.asm
	cartconv -p -t vic20 -l 0xa000 -i cart.bin -o ae.crt
jellymonsters.crt: cart.asm
	acme -DTEST=1 -DEXPANDED=0 -f plain -o cart.bin cart.asm
	cartconv -p -t vic20 -l 0xa000 -i cart.bin -o jellymonsters.crt
clean:
	$(RM) *.prg
	$(RM) *.bin
	$(RM) *.crt
