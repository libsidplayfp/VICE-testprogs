Checks open bus values by forcing known data from ram with
the dummy cycle on an indexing overflow (lda $07ff,x with x >=1).

Returns green on my OC118, expected to work on real 1541s too,
but not yet tested. Will fail on a 1581 due to larger RAM.
