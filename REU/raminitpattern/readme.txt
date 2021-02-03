This is a test/check to show what the uninitialized RAM looks like on a REU.

For REU transfers are done from REU memory to screen, each one page:

1) $000000 -> $0400
2) $020000 -> $0500    (+128k)
3) $040000 -> $0600    (+256k)
4) $080000 -> $0700    (+512k)

The result should be like this:

(NOTE: this is all unconfirmed right now, tests pending, mark confirmed tests
 with a (*))

    128k REU        256k 1764          512k 1764

1)  page 0/bank 0   (*)page 0/bank 0   page 0/bank 0
2)  page 0/bank 0   (*)page 0/bank 2   page 0/bank 2
3)  page 0/bank 0   (*)floating bus    page 0/bank 4
4)  page 0/bank 0   (*)page 0/bank 0   page 0/bank 0

When the REU is used in a RAMlink, it appears to look like this

    128k REU        256k 1764          512k 1764

1)  page 0/bank 0   (*)page 0/bank 0   page 0/bank 0
2)  page 0/bank 0   (*)page 0/bank 2   page 0/bank 2
3)  page 0/bank 0   (*)floating bus    page 0/bank 4
4)  page 0/bank 0   (*)page 0/bank 0   page 0/bank 0

- floating bus seems to always read as $ff (there might be pullups in the REC)
- non initialized RAM seems to read as the following pattern:
  $ff, $00, $00, $ff, $ff, $00, $00, $ff, $ff, $00, $00, $ff, $ff, $00, $00, $ff
  [...] and then the same inverted after (at least) 128k
  $00, $ff, $ff, $00, $00, $ff, $ff, $00, $00, $ff, $ff, $00, $00, $ff, $ff, $00
