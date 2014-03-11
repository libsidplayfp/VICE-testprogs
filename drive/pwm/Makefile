all: pwm.prg

pwm.prg: main.asm
	acme main.asm

test: pwm.prg
	x64sc -truedrive -autostartprgmode 2 pwm.prg
 
clean:
	rm -f *~
	rm -f pwm.prg