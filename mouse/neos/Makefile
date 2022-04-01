
all: neosmouse.prg neosmouse-port2.prg arkanoid.prg

neosmouse.prg: neosmouse.s mousecheese.s
	acme -DTEST=0 -Dcheesemouseport=1 -f cbm -o neosmouse.prg neosmouse.s
neosmouse-port2.prg: neosmouse.s mousecheese.s
	acme -DTEST=0 -Dcheesemouseport=0 -f cbm -o neosmouse-port2.prg neosmouse.s
arkanoid.prg: neosmouse.s arkanoid.s
	acme -DTEST=1 -f cbm -o arkanoid.prg neosmouse.s

clean:
	rm -f neosmouse.prg	
	rm -f neosmouse-port2.prg
	rm -f arkanoid.prg
