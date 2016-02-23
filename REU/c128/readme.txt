C128 REU tests written by Oziphantom:

If not specified the VIC bank is 0
There is
Bank 0 to 0 at 1mhz
Bank 0 to 0 at 2mhz
Bank 0 to 0 at 2mhz vic bank 1
Bank 0 to 1 at 2mhz vic bank 1

The last one will exit to the monitor, as I change all 4 config registers

The test puts 00,01,02,.... FF at $4000 and files $4100-41FF with 00
It then DMAs $4000 to REU $000000 then REU $000000 to $4100
