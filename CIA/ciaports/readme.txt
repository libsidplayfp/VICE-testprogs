This test checks the behaviour of the CIA1 ports when both are programmed as
output, connected via the keyboard matrix, and then read back.

the interesting cases are:

* Port A outputs high, Port B outputs (active) low.

- In this case port b always "wins" and drives port a low,
  meaning both read back as 0.

* Port A outputs (active) low, Port B outputs high.

This case is a bit special and has some interesting properties:

- Usually (probably unexpectedly) port b will NOT be driven low by port a,
  meaning port a reads back 0 and port b reads back 1.

- port b will be driven low (and then read back 0) only if the resistance of the
  physical connection created over the keyboard matrix is low enough to allow
  the required current. this is (again) usually not the case when pressing single
  keys, instead -depending on the keyboard- pressing two or more keys of the same
  column is required. a special case is the shift-lock key, which will also work
  and which you can seperate from the normal left shift key in this configuration.
