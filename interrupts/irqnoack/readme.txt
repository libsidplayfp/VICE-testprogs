
related to https://sourceforge.net/p/vice-emu/bugs/2052/

ackcia.prg:
Sets up a raster interrupt and a CIA1 Timer interrupt. The Raster interrupt is
never acknowledged, so it will immediately trigger again after the RTI.

ackcia2.prg:

like ackcia.prg, but will use PLP; STA; SEI; <failure> instead of RTI

ackcia3.prg:

like ackcia.prg, but will use CLI; SEI; <failure> instead of RTI


ackraster.prg:
Sets up a raster interrupt and a CIA1 Timer interrupt. The Timer interrupt is
never acknowledged, so it will immediately trigger again after the RTI.
(FIXME: i couldn't make the test report "pass" after a while, like the CIA test
does - instead it will run forever/time out when it works correctly)


TODO: this should probably also be tested with other IRQ and NMI sources, and
also by using CLI or PHP to change the IRQ flag.
