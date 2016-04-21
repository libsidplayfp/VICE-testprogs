all: supergames.bin supergames.crt

supergames.bin: supergames.asm
	acme -f plain -o supergames.bin supergames.asm

supergames.crt: supergames.bin	
	 cartconv -p -t sg -i supergames.bin -o supergames.crt
	
clean:
	rm -f supergames.bin supergames.crt
