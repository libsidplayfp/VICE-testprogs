Unconnected address space ("open i/o") tests
--------------------------------------------

If these programs do not work on your computer, make sure you don't have any 
memory devices in these addresses.  If you haven't customized your computer, 
then you have bad luck: your computer is not "$DE00-compatible".
You could try to put your computer in a metal box or something, so that it 
wouldn't pick any noise to the data lines when reading the weak signals from 
the open address space.

* de00int.prg

uses IO1 (de00-de7f) for it's irq routine

when the program is working, the border color can be changed from black to
white by pressing space

* de00all.prg

runs all the time in IO1 (de00-de7f)

when the program is working, the border color can be changed from black to
white by pressing space

* dadb.prg

runs code in color-ram (using the high nibbles)

when the program is working, the border color can be changed from white to 
black by pressing space.
