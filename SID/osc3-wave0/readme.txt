When changing to waveform zero (no waveform selected) the OSC3 register is not 
changed. The bits in OSC3 should slowly decay to 0.

This test does the following:

* set pulse with pulse widht $fff, OSC3 will read $00
* set pulse with pulse widht $000, OSC3 will read $ff
* set no waveform, OSC3 will still read $ff
* wait ~3 secs, OSC3 should now read $00
