This is another REU test program that will figure out how the RAM mirrors are
arranged on a particular REU, and then will reliably determine the amount of
RAM that is present. In particular it does not rely on a certain powerup value
in RAM, nor assumes continues mirrors.

the two values in the top left of the screen are the number of banks and the
amount of memory in KiB.

-------------------------------------------------------------------------------

TODO: the following is not yet confirmed. mark confirmed results by (*)

expected results:

128k REU:

- 2 banks, mirrored every two banks across all banks

256k REU:

- 4 banks, mirrored every 8 banks. banks 4-7 are not connected and read as
  floating bus (mostly $ff)

512 REU:

- 8 banks, mirrored every 8 banks across all banks

> 512 REU:

- unknown. probably should mirror present banks without "holes"
