
all: neosmouse.prg neosmouse-port2.prg arkanoid.prg krakout.prg

neosmouse.prg: neosmouse.s mousecheese.s
	acme -DTEST=0 -Dcheesemouseport=1 -f cbm -o neosmouse.prg neosmouse.s
neosmouse-port2.prg: neosmouse.s mousecheese.s
	acme -DTEST=0 -Dcheesemouseport=0 -f cbm -o neosmouse-port2.prg neosmouse.s
arkanoid.prg: neosmouse.s arkanoid.s
	acme -DTEST=1 -f cbm -o arkanoid.prg neosmouse.s
krakout.prg: neosmouse.s krakout.s
	acme -DTEST=2 -f cbm -o krakout.prg neosmouse.s

clean:
	rm -f neosmouse.prg	
	rm -f neosmouse-port2.prg
	rm -f arkanoid.prg
	rm -f krakout.prg
