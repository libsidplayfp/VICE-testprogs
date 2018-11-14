The waveform D/A converter introduces a DC offset in the signal
to the envelope multiplying D/A converter. The "zero" level of
the waveform D/A converter can be found as follows:

Measure the "zero" voltage of voice 3 on the SID audio output
pin, routing only voice 3 to the mixer ($d417 = $0b, $d418 =
$0f, all other registers zeroed).

-> zerolevel1.prg

Then set the sustain level for voice 3 to maximum and search for
the waveform output value yielding the same voltage as found
above. This is done by trying out different waveform output
values until the correct value is found, e.g. with the following
program:

-> zerolevel2.prg

The waveform output range is 0x000 to 0xfff, so the "zero"
level should ideally have been 0x800. In the measured chip, the
waveform output "zero" level was found to be 0x380 (i.e. $d41b
= 0x38) at an audio output voltage of 5.94V.

With knowledge of the mixer op-amp characteristics, further estimates
of waveform voltages can be obtained by sampling the EXT IN pin.
From EXT IN samples, the corresponding waveform output can be found by
using the model for the mixer.

Such measurements have been done on a chip marked MOS 6581R4AR
0687 14, and the following results have been obtained:

* The full range of one voice is approximately 1.5V.
* The "zero" level rides at approximately 5.0V.
