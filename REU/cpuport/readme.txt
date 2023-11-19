
https://sourceforge.net/p/vice-emu/bugs/1965/

On a real C64 with a RAM Expansion Unit, it is not possible to use the REU to
read or write the CPU Data Direction Register and the CPU Processor IO Port
Register, which are memory mapped to the C64 addresses $0000 and $0001.

This is a simple test that checks that CPU read/writes always access the CPU
DDR/Port, and REU read/writes always access the actual RAM.
