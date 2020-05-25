
"Combined waveform noise-pulse osc value should reach maximum value of 252 when 
the TEST bit is enabled for voice 3." (see bug #1037)

quicktest.prg:
--------------

"On my real c64 and c128 both with SID 6581, osc results starts at 0 and 
gradually set the osc bits until it is stable at 252. Typical sequence od 
results are 0,0,0,...,0,16,80,208,216,248,252. Time varies but improves 
depending on how long the computer has been on before value becomes stable at 
252 . On VICE it almost stops immediately with result of 255.


wf12nsr.prg:
------------

This is another test program with reference data from my real c64. The test is 
an extension of the noise writeback tests which does take sometime to complete. 
The screen changes colour for each wafeform. The program provides results for 
waveform 8,9,10,11,12,13,14,and 15 each with 2 rows of data. Text in green 
matches reference data. Text in red highlights mismatch. Green border all data 
matches. Red border indicates an error was detected. Hold space bar down to see 
reference data.

The test for each waveform basically executes and shows results as follows.

- The waveform is set with TEST enabled. The 1st value in the results is the 
  osc value read after noise register is given time to reset.
- The waveform is set with TEST disabled. The 2nd value in the results is the 
  osc value read directly after this.
- The waveform is set with TEST enabled again. The 3rd value in he 2nd value 
  in the results is the osc value read directly after this.
- The waveform is set to noise only with TEST disabled. Results are read from 
  osc until 2 lines are filled.

It can be seen in the results for waveform 12 the first value read is 252 before 
the TEST bit is released (5th set of results). This seems to affect the noise 
writeback as discussed in bug# 746. In VICE for waveform 12 the results are 
exactly the same as the noise waveform by itself (ie. waveform 8, the 1st set 
of results). 

NOTE: for the test to work the chip must be "warmed up". especially 8580 may
not reset correctly when cold.
