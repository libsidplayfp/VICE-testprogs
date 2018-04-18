The attached test program tries to open a file (itself) using each secondary 
address in the range 2-14. A green letter is printed if it works and the first 
byte returned is correct. A red letter is printed if READST returns Device Not 
Present (immediately after OPEN and CHKIN). (A yellow letter is printed if 
READST succeeds but the wrong byte is returned, but this doesn't happen).

(r34290) - test fails when TDE _AND_ device traps are enabled

