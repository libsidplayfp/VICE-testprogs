
all: writeram-8000.crt writeram-a000.crt godot.crt

writeram-8000.crt: writeram.s
	acme -f plain -DRAMLOC=0x8000 -o writeram-8000.bin writeram.s
	cartconv -p -t pf -i writeram-8000.bin -o writeram-8000.crt
 
writeram-a000.crt: writeram.s
	acme -f plain -DRAMLOC=0xa000 -o writeram-a000.bin writeram.s
	cartconv -p -t pf -i writeram-a000.bin -o writeram-a000.crt
 
godot.crt: godot.asm
	acme -f plain -o godot.bin godot.asm
	cartconv -p -t pf -i godot.bin -o godot.crt
 
