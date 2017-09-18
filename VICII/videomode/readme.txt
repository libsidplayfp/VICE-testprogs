these tests show various mid-line splits between graphic modes. these splits
do not become effective at character boundaries (as one would expect) but they
are delayed by a varying amount of pixels - caused by propagation delays and
analog side effects. the amount of delay may depend on the type of VICII, and
the temperature of the chip.

see the screenshots directory for captures from real hardware, compared to the
reference pictures used for the test suite.

what kind of splits do actually vary between setups (and temperature) is still
yet to be determined, more captures from real hardware are needed.

so far the following tests show suspicious/different results:

- videomode-x
- videomode-z
- videomode2

