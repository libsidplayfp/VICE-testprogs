
bitfill.prg:
------------

modelled after the "Bit Fill Pattern" test of the "REUTEST" program from the
CMD 1750XL disk

- press SPACE for another test. the top row on screen shows the result, which
  should be zero (=green)

--------------------------------------------------------------------------------

wheels.prg:
-----------

modelled after the REU detection used in "wheels"

- when the test passes the border shows green

--------------------------------------------------------------------------------

twoblocks.prg:
--------------

checks the register contents after transfers

- after first half (grey border) press SPACE to see the second half
- values in the upper part of the screen will turn red if they are wrong

NOTE: the first column of the dumped values will be "wrong" when the test is
      run on a 128k REU (then bit0 is 0)

twoblocks-ff00.prg:
-------------------

same as above, but uses the ff00 trigger to start a transfer

