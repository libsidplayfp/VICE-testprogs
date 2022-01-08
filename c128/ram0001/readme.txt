check behaviour of RAM locations $00 and $01

when reading/writing memory locations $00 and $01, the 8502 CPU will instead 
access its CPU port. the physical RAM that is present at these locations can not
be read by the CPU (it will always read the CPU port). when writing a value to
one of these locations, the CPU will signal write enable for the RAM, but it 
will not put the actual value on the bus (the value goes to the CPU port 
instead), which results in whatever value was on the bus before (usually some-
thing fetched by the VICII) ending up in RAM location $00/$01.

as the VICII will always see RAM (also at location $00/$01), those locations can
be made visible as graphics data and eg values can be checked by using sprite-bg
collisions.

quicktest.prg:
    0 poke53272,5:poke0,47:run

simple demonstration, sets videoram to $0000 so you can see the content of RAM
locations $00 and $01 in the top left of the screen. the basic program writes
a constant value of $2f to $00, and the system interrupt will write a constant
value of $37 to $01. however, on a real C128 you will see seemingly random values
being written to RAM locations $00 and $01.

test1.prg:

writes to 0/1 by first writing the desired value to $3fff (last byte of the
current bank, which is fetched by the VICII in the border) and then to 0/1 in
the border area. it then reads the respective ram locations using sprite
collisions and compares to the original value(s). the border will turn red when
an error occurs.

test2.prg

Writes to 0/1 by using the mmu zero page relocation back translation method, and
verifies if the cpu port and ram of the target of the zero page relocation remain
unchanged. The border will turn red when an error occurs.
