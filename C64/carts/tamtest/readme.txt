tamtest.crt, written by Zaindlmaier

"tamtest" is a C64 RAM tester that runs on the Easyflash and does not use the
C64 stack or Zeropage.

1) boots in ultimax mode and switches the LED on/off to indicate the test started
2) VIC is initialized
3) CBM key is checked (if pressed, skip the test and go to basic)
4) $00/$01 are being checked for use of 16k cartridge mode.
   - if $00 is broken border turns red
   - if $01 is broken background turns red
5) switch to 16k mode so RAM can be accessed (except RAM under I/O)
   - if $01 is broken border turns white
6) RAM at $0200-$cfff and $e000-$ffff is being tested
7) color RAM $d800-$dbff is being tested
8) result is displayed on screen and easyflash LED
   - first line shows broken RAM bits (7-0)
   - second line shows broken color RAM bits (7-0) (bit 7-4 are always "broken")
   - third line shows a blinking character (same as LED)
     - first come bits 7-0 of the RAM (short=ok long=broken)
     - then color ram
