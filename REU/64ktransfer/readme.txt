The tests in this directory check if a transfer of exactly 2^16 bytes works by
using $0000 into the length register.

toc64.prg:
----------

Fills a 64k bank in the reu with the same byte, except the last. Then transfers
to a fixed address on C64 and checks if that contains the last byte at expected.

toreu.prg
---------

Puts a marker into the last page in C64 memory, then transfers 64k into the REU.
Then transfers back the last page from REU to the screen, and checks if the last
byte is what we expect.

