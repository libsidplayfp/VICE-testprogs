
This unit test checks the reset behaviour of the exponential counter.

After performing a hard restart, it sets ADSR to 1111 (so, one rc reset every 32 cycles from here on),
triggers an envelope, and waits for ENV3 to pass 0x1a to set the exponential counter period to 8.

It then iterates over 40 rc resets, each time fetching a pair of values from gate0/gate1 to write
to the gate register of voice 3 in quick succession, before recording the value of ENV3

It demonstrates that the exponential counter is reset in the attack state, but only when an rc reset
event occurs.

First row of values displayed are the measured results, second is the reference.

As usual, green border on pass, red on fail.


