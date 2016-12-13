This test checks/demonstrates the special "Nordic Power" mode which is present
in Atomic Power and Nordic Power cartridges ($de00=$22).

first page on screen shows what is mapped at $8000 (ROML)
second page shows what is mapped at $A000 (ROMH)
third and forth page are IO1 and IO2

when "Nordic Power" mode is active (space pressed) the first page should show 
cartridge ROM, the second cartridge RAM (in 16k game mode). additionally IO2 is 
from the cartridge RAM.
