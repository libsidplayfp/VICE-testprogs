this directory contains tunes from the HVSC which rely on certain border cases,
and/or can be used to check certain features/properties of the psid player.

note that often tunes are fixed/updated so they can be played on a real C64
without hassle, meaning some of the problems below may not show anymore in a
recent copy of HVSC.

--------------------------------------------------------------------------------

MUSICIANS/R/Rayden/Boot_Zak_v2.sid - relies on exact emulation of the cpu port, 
 (see CPU/cpuport)

MUSICIANS/B/Bjerregaard_Johannes/Fruitbank.sid - image loads from $0400 - ...

GAMES/S-Z/Triango.sid - init copies code to $0400 - ...

"tunes using low memory like at $0200 or $0340 onward"
MUSICIANS/D/Deenen_Charles/Double_Dragon.sid
MUSICIANS/R/Rowlands_Steve/Cyberdyne_Warrior.sid
MUSICIANS/R/Rowlands_Steve/Fuzzy_Wuzzy.sid
MUSICIANS/R/Rowlands_Steve/Retrograde_tapeloader.sid

GAMES/M-R/Ms_Pacman.sid - image located "under" BASIC ROM

GAMES/M-R/Mean_City.sid - image located "under" KERNAL ROM

"tunes overwriting d000-dfff, sometimes with code or data there, sometimes 
 nothing"
MUSICIANS/D/Dunn_Jonathan/Daley_Thompsons_Olympic_Challenge.sid
MUSICIANS/T/Tel_Jeroen/Hotrod.sid

"tunes where init/play are under $d000-$dfff"
MUSICIANS/F/Follin_Tim/Qix.sid

"Some other fixes is about sids overwriting $fffa-ffff. Usually it's just
 garbage to be removed, sometimes it needs to be relocated if the bytes
 at $fffa-ffff are actually used and there is no actual bankswitching."
MUSICIANS/D/DOS/Tales_of_Mystery_end_tune.sid
"the extra bytes at $fffa aren't used."
MUSICIANS/D/Dunn_Jonathan/Red_Heat.sid

* BASIC tunes

DEMOS/Commodore/C64_Christmas_Album_BASIC.sid - BASIC tune with sub tunes

* technically broken rips

"Tunes that write outside their range can overwrite the sid player code if the 
freepages aren't set.
 This is one example, SoundMonitor tune that writes to $07xx but with no 
 freepages set the sid player is free to use memory from $0400 onward, and 
 there will be problems sooner or later."
DEMOS/0-9/3_Oversample.sid (freepages: 08,39)

* sidplayer tunes

Rendez-vous.mus (Rendez-vous.sid is a regular file including player)
Star_Wars.mus, Star_Wars.str

--------------------------------------------------------------------------------
NOTE:

- compute gazette sidplayer files that are embedded into the PSID format without
  being merged with a player binary are not common "in the wild" and thus no 
  real examples have been added. look in the "sidplayer" subdirectory for some
  artificial tests.

--------------------------------------------------------------------------------

TODO:

- make sure all kinds if setups, speeds, flags etc combinations are covered by
  the test tunes
