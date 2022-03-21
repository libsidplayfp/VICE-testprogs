
joycheck.prg:
-------------

Reads via1 porta and via2 portb
- after setting to input
- after setting to output and writing 0
- after setting to output and writing 255

expected output:

255 255     <- via1 pa, via2 pb as input
0 255       <- via1 pa as output, first after writing 0, second after writing 255
X Y         <- via2 pb as output, first after writing 0, second after writing 255

X   is jumping between 0 and 247
Y   is jumping between 247 and 255
