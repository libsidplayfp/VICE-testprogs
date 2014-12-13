this directory contains tunes from the HVSC which rely on certain border cases,
and/or can be used to check certain features/properties of the psid player.

note that often tunes are fixed/updated so they can be played on a real C64
without hassle, meaning some of the problems below may not show anymore in a
recent copy of HVSC.

--------------------------------------------------------------------------------

MUSICIANS/R/Rayden/Boot_Zak_v2.sid - relies on exact emulation of the cpu port, 
 (see CPU/cpuport)

--------------------------------------------------------------------------------

"image loads from $0400 - ... (below $07e8)"
MUSICIANS/B/Bjerregaard_Johannes/Fruitbank.sid
GAMES/M-R/Paradroid.sid
MUSICIANS/F/FAME/Hendriks_Michael/X-Out.sid

"init copies code to $0400 - ... (below $07e8)"
GAMES/S-Z/Triango.sid

"tunes using low memory like at $0200 or $0340 onward"
MUSICIANS/D/Deenen_Charles/Double_Dragon.sid
MUSICIANS/R/Rowlands_Steve/Cyberdyne_Warrior.sid
MUSICIANS/R/Rowlands_Steve/Fuzzy_Wuzzy.sid
MUSICIANS/R/Rowlands_Steve/Retrograde_tapeloader.sid

"tune with free pages starting at $8000"
MUSICIANS/P/Pedersen_Inge/Puggs_in_Town.sid

--------------------------------------------------------------------------------

"image located "under" BASIC ROM"
GAMES/M-R/Ms_Pacman.sid
GAMES/S-Z/Wizardry.sid

"partially under BASIC, requires $01=$36 although play/init is in $Cxxx area"
DEMOS/A-F/Burger.sid

--------------------------------------------------------------------------------

"image located "under" KERNAL ROM"
GAMES/M-R/Mean_City.sid

--------------------------------------------------------------------------------

"image under KERNAL ROM, but play _not_ under ROM (copied at init)"
GAMES/M-R/Magicians_Ball.sid

--------------------------------------------------------------------------------

"tunes overwriting d000-dfff, sometimes with code or data there, sometimes 
 nothing"
MUSICIANS/D/Dunn_Jonathan/Daley_Thompsons_Olympic_Challenge.sid
MUSICIANS/T/Tel_Jeroen/Hotrod.sid

"tunes where init/play are under $d000-$dfff"
MUSICIANS/F/Follin_Tim/Qix.sid

--------------------------------------------------------------------------------

"Some other fixes is about sids overwriting $fffa-ffff. Usually it's just
 garbage to be removed, sometimes it needs to be relocated if the bytes
 at $fffa-ffff are actually used and there is no actual bankswitching."
MUSICIANS/D/DOS/Tales_of_Mystery_end_tune.sid
"the extra bytes at $fffa aren't used."
MUSICIANS/D/Dunn_Jonathan/Red_Heat.sid

GAMES/S-Z/Young_Ones.sid

"end address $0000 (overwrites $fffa-$ffff) ..  doesnt crash but feels unsafe"
MUSICIANS/D/Daglish_Ben/Artura.sid

"end address $ffff (overwrites $fffa-$fffe) ..  doesnt crash but feels unsafe"
MUSICIANS/D/Daglish_Ben/Northstar.sid

********************************************************************************
* BASIC tunes
********************************************************************************

DEMOS/Commodore/C_PRG_ex_01_BASIC.sid
DEMOS/Commodore/C64_Christmas_Album_BASIC.sid - BASIC tune with sub tunes
GAMES/M-R/Othello_BASIC.sid - BASIC tune with sub tunes

********************************************************************************
* technically broken rips
********************************************************************************

"default tune is out of range (incorrectly set to 0 instead of 1)"
GAMES/M-R/Masters_of_Time.sid

"Tunes that write outside their range can overwrite the sid player code if the 
freepages aren't set.
 This is one example, SoundMonitor tune that writes to $07xx but with no 
 freepages set the sid player is free to use memory from $0400 onward, and 
 there will be problems sooner or later."
DEMOS/0-9/3_Oversample.sid (freepages: 08,39)

"Tunes that require a certain $01 value to work correctly"
code in play routine does this
3AFC  A5 01     LDA $01
3AFE  29 FD     AND #$FD
3B00  85 01     STA $01
/MUSICIANS/C/Cooksey_Mark/Airwolf.sid

********************************************************************************
* sidplayer tunes
********************************************************************************

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
