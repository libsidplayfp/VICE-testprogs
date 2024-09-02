
This program lets you observe (somewhat) how sprite-dma affects REU transfers.

The program first stabilizes the irq, then produces some color bars by writing
to $d020 by CPU, and finally starts one long REU transfer that writes a color
pattern to $d020.

The color bars at the top should all be aligned, this shows the timing is stable

Press 1...8 to enable/disable sprites 1...8
