
this little program can be used to verify that a cartridge is properly disabled
when RUNning a program. the expected/correct output very much depends on the
individual cartridge and cartridge-ROM (see below).

- in the first two rows you see a dump of the values read from the beginning
  of the IO1 and IO2 blocks
- below that is a copy of what can be read from $8000. if you see a pattern that
  shows all values 0...$ff then you are looking at the C64 RAM
- next is the IO1 page
- last not least the IO2 page

- after RESET restart the program with SYS 2560

--------------------------------------------------------------------------------
expected results:
--------------------------------------------------------------------------------

Retro Replay, MMC-Replay, Nordic Replay (with Retro-Replay ROM):
----------------------------------------------------------------

RUN with cartridge enabled ("install fastload" in main screen):

- registers de00 and de01 read as 48, 48
- at 8000 is RAM
- de00 page is active cartridge ROM
- df00 page is inactive (open I/O)

RUN with cartridge disabled ("normal reset" in main screen):

- at 8000 is RAM
- de00 page is inactive (open I/O)
- df00 page is inactive (open I/O)

Final Cartridge III:
--------------------

RUN with cartridge enabled:

- at 8000 is RAM
- de00 page is active cartridge ROM
- df00 page is active cartridge ROM

RUN with cartridge disabled:

- at 8000 is RAM
- de00 page is active cartridge ROM
- df00 page is active cartridge ROM



