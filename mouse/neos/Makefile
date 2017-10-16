
all: neosmouse.prg arkanoid.prg

neosmouse.prg: neosmouse.s mousecheese.s
	acme -DTEST=0 -f cbm -o neosmouse.prg neosmouse.s
arkanoid.prg: neosmouse.s arkanoid.s
	acme -DTEST=1 -f cbm -o arkanoid.prg neosmouse.s

clean:
	rm -f neosmouse.prg	
	rm -f arkanoid.prg
