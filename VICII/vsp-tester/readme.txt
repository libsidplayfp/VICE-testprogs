
https://sourceforge.net/p/vice-emu/bugs/1855/

On real c64 hardware triggering a badline during idle state ("DMA delay") causes
the VIC to retrieve a different idle byte than usual in the trigger cycle.
Ordinarily idle bytes are sourced from $3fff (or $39ff when ECM enabled). When
DMA delay is triggered on real hardware the idle byte is instead sourced from
$38ff (6569 VICs) or $3807 (8565/8566 VICs) in the cycle the delay is triggered.
This is visible in the cycle prior to the 3 cycles of "display mode" artefacts.

vsp-tester.prg:

Attached is a test program that triggers DMA delay, determines and displays on
screen the altered location of the affected idle-byte, as well as animating that
specific byte in memory as additional verification. The animated idle byte is
located on screen immediately above the address 4th digit.

"I am triggering a DMA delay in the 40th column, ie VIC cycle 53 with vertical
borders open.

In emulation the VSP idle byte continues right up to the 39th column, then the
DMA delay artefacts begins in the 40th. (I was happy with this because the 38
column mode borders can hide the artefact.)

On real hardware however, the idle byte changes in the preceding (39th) column.
I was able to determine that it is being retrieved from a different address than
usual, but that the specific address is different on different machines. The two
addresses I’ve seen so far across 5 machines are $38FF and $3807."
