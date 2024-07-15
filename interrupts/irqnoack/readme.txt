
related to https://sourceforge.net/p/vice-emu/bugs/2052/

ackcia.prg:
Sets up a raster interrupt and a CIA1 Timer interrupt. The Raster interrupt is
never acknowledged, so it will immediately trigger again after the RTI.

ackraster.prg:
Sets up a raster interrupt and a CIA1 Timer interrupt. The Timer interrupt is
never acknowledged, so it will immediately trigger again after the RTI.


TODO: this should probably also be tested with other IRQ and NMI sources, and
also by using CLI or PHP to change the IRQ flag.
