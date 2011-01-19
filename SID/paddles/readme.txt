simple paddle / SID ADC test
----------------------------

this program tests some basic properties of the SID ADCs and the multiplexer,
which are required for proper paddle- and mouse emulation.

what you see on the screen as follows...

adc#1 adc#2  port1    port2
ff 00 ff 00  ........ *.*.....
                43210    43210

...are:
- the values read from the ADCs
- next to that, the difference to the last value, which is mostly useful to
  show how much jitter there is
- next to that the joystick bits, which have the following meaning...

4  joy fire                mouse left
3  joy right paddle 2 fire
2  joy left  paddle 1 fire
1  joy down
0  joy up                  mouse right

... and are just there so buttons can also be checked.

the program tests 4 cases (change with return):

00 - no paddle selected
01 - paddle port 1 selected
10 - paddle port 2 selected
11 - both paddle ports selected

------------------------------------------------------------------------------
theory:

the SIDs POTX/POTY inputs are connected to a 4066 analog switch, whose inputs
go to the POTX/POTY pins of joystick port 1 and 2. the control inputs go to
CIA1 porta bit 6 and 7 as in the table above. the outputs then go to the SID.
* if no output is selected, then the SID is connected to an "infinite"
  resistance, so the ADCs should return 0xff
* if one output is selected, then the SID is connected to the respective
  potentiometer in the paddle, and the ADCs will represent its value.
* if both outputs are selected, then two potentimeters might be connected in
  parallel to each ADC, meaning the final value should be as follows:
  r = 1 / ((1 / r1) + (1 / r2))
  if only one paddle is connected, then (since one of the resistors is
  "infinite"), the final value should be simply:
  r = r1 or r = r2
------------------------------------------------------------------------------
results from my breadbox (gpz):

- with no paddle(s) connected, all 4 cases work as expected, meaning 0xff is
  returned in the ADCs
- with one paddle connected, all cases work as expected. meaning 0xff is
  returned if the port is not selected, and the ADCs working as expected if it
  is (even if both ports are selected at once).
(can't test with both connected at once since i only have one pair of paddles :))
note: i get surprisingly much jitter (in the range of +/- 0x10). might be just
that my paddles need cleaning :)
