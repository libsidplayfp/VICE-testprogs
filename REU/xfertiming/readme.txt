xfertiming-toc64.prg:
---------------------

checks the timing of a REU->C64 DMA transfer by writing to a I/O register

- all color bars must be in line with each other. the second bar that contains
  the small 8pixel wide splits comes from writing to $d020 using DMA

xfertiming-toreu.prg:
---------------------

checks the timing of a C64->REU DMA transfer by reading from I/O registers and
comparing the values that were read with reference data

- the second (slim) color bar must be in line with the color bars at the top and
  bottom.
- the characters in the screen area must be all green, the first half is read
  from $d012, the other half from $dc04.

(this test does not work in x64, works in x64sc)

xfertiming-swap.prg:
--------------------

checks the timing of a SWAP DMA tramsfer by swapping REU memory with a I/O
register. (only the write to C64 is actually checked)

- all color bars must be in line with each other. the second bar is the result
  of the SWAP, every other (odd) scanline is offset by 8 pixel (due one line
  taking 63 cycles, which is not divideable by the 2 cycles that each swap
  takes)

(this test does not work in x64, works in x64sc)

xfertiming-swap2.prg:
--------------------

checks the timing of a SWAP DMA tramsfer by swapping REU memory with a I/O
register. (only the read from C64 is actually checked)

- all color bars must be in line with each other.
- the characters in the screen area must be all green, these are values read
  from $d012

(this test does not work in x64, works in x64sc)

xfertiming-cmp.prg:
-------------------

checks the timing of a COMPARE DMA transfer by comparing I/O registers and
reference data

- the second (slim) color bar must be in line with the color bars at the top and
  bottom.
- when the test passed, the border turns green

(this test does not work in x64, works in x64sc)

