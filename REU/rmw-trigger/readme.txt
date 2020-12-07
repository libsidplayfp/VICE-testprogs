
rmwtrigger-rom.prg
rmwtrigger-ram.prg
------------------

It is possible to start a REU transfer by writing to address $ff00, which is 
useful when you want to transfer to or from memory in the $d000-$dfff range. But 
sometimes you don't want to trash the byte at $ff00, so you end up starting the 
transfer like this:

        lda $ff00
        sta $ff00
        
However, it turns out you can use any RMW instruction:

        inc $ff00
        
The dummy write causes the REU to immediately take over the bus, so the second 
write-request from the CPU doesn't reach the memory chips. The incremented value 
never gets written into RAM. Three cycles saved.

CAUTION: this means this trick will only work when the kernal is NOT enabled,
else the first (dummy) write of the INC will still get written to RAM and trash
the previously existing value.

The 6502 has two inputs, /RDY (Ready) and /AEC (Address Enable Control). RDY 
tells the CPU to pause execution, but it is only obeyed during read cycles. AEC 
immediately disconnects the CPU from the buses (address, data, and the read/
write signal).

The VIC chip has two outputs, BA (Bus Available) and AEC (Address Enable 
Control). During normal operation, VIC asserts AEC (which is connected to AEC 
on the CPU) on every other half-cycle in order to read e.g. font bits. It has 
to work immediately, i.e. asynchronously, because it needs to be fast enough 
for half-cycle operations.

When VIC needs to halt the CPU, it first pulls BA low for three cycles, to 
ensure that the CPU is on a read cycle. Then it asserts AEC in order to access 
memory on both half-cycles.

The expansion port has an output, BA, and an input, /DMA. BA comes from the VIC. 
But /DMA is connected to both /RDY and /AEC. That is, it tells the CPU to pause, 
but it also immediately disconnects the CPU from the buses.

The REU monitors BA so it can pause an ongoing transfer during badlines and 
sprite fetches. But otherwise, it pulls /DMA and just assumes that the bus is 
free. The engineers must have assumed (wrongly) that the CPU will always trigger 
a transfer on the last cycle of an instruction, so that the next cycle is 
guaranteed to be a read (to fetch the next instruction).

Instead, due to the double-write of our RMW instruction, part of the CPU will 
attempt to place an address and data value on the buses, and set the read/write 
line to write. But the CPU is disconnected from the buses because /DMA is held 
low, and therefore /AEC. The bits never reach the actual bus lines; they 
dissipate into a small amount of heat.

- does not work in x64sc 39179
