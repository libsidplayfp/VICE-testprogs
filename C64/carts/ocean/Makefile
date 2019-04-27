
all: ocean.crt

ocean.crt: main.asm
	acme -f plain -o ocean.bin main.asm
	cartconv -p -t ocean -i ocean.bin -o ocean.crt

