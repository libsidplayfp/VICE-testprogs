6510/8500 $00/$01 unused bits emulation tests
---------------------------------------------

bitfade.s - visualises the bitfading
test1.s - tests the assumptions that the imaginary "capacitor" will only be
          charged when the bit is in output mode, and then the charge will be
          transferred/visible when reading the bit in input mode
delaytime.s - measures the bitfade delay, first row shows the current time and
              value of $01, second row shows the time when bit7 of $01 has
              faded to 0.

theory of operation:
--------------------

NOTE: this is partially guesswork based on observed behavior and not necessarily
      technically correct (corrections welcome)

On the CPU actually the full 8 bit of the i/o port are implemented. What is 
missing for bit 6 and bit 7 is likely only the actual connection to the outside,
meaning there is a floating "pin" that behaves similar to a capacitor.

a) unused bits of $00 (DDR) are actually implemented and working. any value
   written to them can be read back and also affects $01 (DATA) the same as
   with the used bits.

b) unused bits of $01 are also implemented and working. when a bit is
   programmed as output, any value written to it can be read back. when a bit
   is programmed as input (and was previously output, ie the state changes from
   stable to floating) some charge is transferred from the output, and the
   transferred value can be read back from that bit input mode until it fades
   to zero after some time (some hundred microseconds)

delay times:
------------

~$30000 == ~200000ms (gpz, new C64)

some other things that depend on correct behavior:
--------------------------------------------------

cpuports.prg from the lorenz testsuite
http://csdb.dk/release/?id=47808
C64Music/MUSICIANS/R/Rayden/Boot_Zak_v2.sid



 
