the dreaded vsp crash is caused by a metastability condition in the dram. some 
have speculated that it has to do with refresh cycles, but hopefully the 
detailed explanation in this scroller will crush that myth once and for all. 

but first, this is what the machine behaves like from a programmer's point of 
view. let us call memory locations ending in 7 or f fragile. sometimes when vsp 
is performed, several fragile memory cells are randomly corrupted according to 
the following rule: each bit in a fragile memory cell might be changed into the 
corresponding bit of another fragile cell within the same page. this specific 
behaviour can be exploited in several ways: one approach is to ensure that every 
fragile byte in a page is identical. if the page contains code, for instance, 
corruption is avoided if all the fragile bytes are $ea (nop). similarly, in font 
definitions, the bottom line of each character could be blank. another technique 
is to simply avoid all fragile memory locations. the undocumented opcode $80 
(nop immediate) can be used to skip them. data structures can be designed to 
have gaps in the critical places. this latter technique is used in this demo, 
including the music player of course. data that cannot have gaps, i.e. graphics, 
is continuously restored from safe copies elsewhere in memory. you can use shift 
lock to disable this repair, and eventually you should see garbage accumulating 
on the screen. and yet the code will keep running. thus, for the first time, the 
vsp crash has been tamed. 

now for the explanation. the c64 accesses memory twice in every clock cycle. 
each memory access begins with the lsb of the address (also known as the row 
address) being placed on an internal bus connected to the dram chips. as soon as 
the row address is stable, the row address strobe (ras) signal is given. each 
dram chip now latches the row address into a register, and this register 
controls a multiplexer which connects the selected memory row to a set of wires 
called sense lines. each sense line connects to a single bit of memory. the 
sense lines have been precharged to a voltage in between logical zero and 
logical one. the charge stored in the memory cell affects the sense line towards 
a slightly lower or higher voltage depending on the bit value. a feedback 
amplifier senses the voltage difference and exaggerates it, so that the sense 
line reaches the proper voltage representing either zero or one. because the 
memory cell is connected (through the multiplexer) to the sense line, the 
amplified charge will also flow back and refresh the memory cell. hence, a 
memory row is refreshed whenever it is opened. 

vsp is achieved by triggering a badline condition during idle mode in the 
visible part of a rasterline. when this happens, the vic chip gets confused 
about what memory address to access during the half-cycle following the write to 
$d011. it sets the internal bus lines to 11111111 in preparation for an idle 
fetch, but suddenly changes its mind and tries to read from an address with an 
lsb of 00000111. now, since electrical lines can't change voltage 
instantaneously, there is a brief moment of time when each of the changing bits 
(bit 3 through 7) is neither a valid one nor a valid zero. but because the vic 
chip changes the address at an abnormal time, there is now a risk that the ras 
signal, which is generated independently by another part of the vic chip, is 
sent while one or more bus lines is within the undefined voltage range. when an 
undefined voltage is latched into a register, the register enters a metastable 
state, which means that its output will flicker rapidly between zero and one 
several times before settling. this has catastrophic consequences for a dram: 
the row multiplexer will connect several different memory rows, one at a time, 
to the same sense lines. but as soon as some charge has moved from a memory cell 
to the sense line, the amplifier will pull it all the way to a one or a zero. 
if, at this point, another memory row is connected, then the charge will travel 
from the sense line into this other memory cell. in short, one memory cell gets 
refreshed with the bit value of a different memory cell. 

note that because the bus lines change from $ff to $07, only memory rows with an 
address ending in three ones are at risk of being opened simultaneously. this 
explains why corruption can only occur in memory locations ending in 7 or f. 
finally, this phenomenon hinges on the exact timing of the ras signal at the 
nanosecond level, and on many machines the critical situation simply doesn't 
occur. the timing (and thus the probability of a crash) depends on factors such 
as temperature, vic revision, parasitic capacitance and resistance of the traces 
on the motherboard, power supply ripple and interference with other parts of the 
machine such as the phase of the colour carrier with respect to the dotclock. 
the latter is assigned randomly at power-on, by the way, which could be the 
reason why a power-cycle sometimes helps. this is lft signing off. 
