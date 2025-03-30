Checks open bus values by forcing known data from ram with
the dummy cycle on an indexing overflow (lda $07ff,x with x >=1)
and reading the last instruction byte in open areas from 0800-7f00
(one byte per page only).

Returns green on my OC118, expected to work on real 1541s too,
but not yet tested. Will fail on a 1581.

(gpz 30/3/2025) works on my 1541(old), fails on 1570
