
This program continuously samples the POT value from port 1 ($d419) and shows
a scatter plot of the values.


- Each Square is 8 pixel wide, ie 8 values

- The blue area marks the full range, ie values 0-255

- The green area (approximately) marks the range used by the 1351 mouse


Observations:

- When a paddle is connected, the value jitters gradually more with higher
  values. Very low values have almost no jitter, very high values jitter around
  6 values or so.

- When a mouse is connected, the value is very precise over the full range,
  only the LSB jitters.

- With both regular paddles and the 1351 mouse, occasional semi-random (usually
  much too large) values can be observed. This happens, because the program
  does _not_ disable interrupts, and the keyboard scanner uses $dc00, which will
  select the other joystick port for a short time, and mess up the sampling.

