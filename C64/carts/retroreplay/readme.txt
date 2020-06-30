
writeonce.prg
-------------

checks if the "write once" bits in de01 are really "write once". works best when
no other program (ROM) has written to de01 before.

nofreeze.prg
------------

sets the "no freeze" bit and then reads (and shows) the content of de01, pressing
the freeze button should result in bit 2 being changed.

must be run with a ROM that does not write to de01

allowbank0.prg
allowbank1.prg
--------------

checks mapping of RAM in IO, with "allow bank" bit set or unset. 

must be run with a ROM that does not write to de01
