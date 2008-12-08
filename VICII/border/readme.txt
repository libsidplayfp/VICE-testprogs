
All PRGs compiled with acme
Run them with
LOAD"BORDER-....PRG",8,1
SYS2064


border-<n>:
-----------
Opens right border in cycle 56 of line n and following lines.
While n=250 is early enough to let the border open, n>=251 will make the
bottom border flipflop set and so the border isn't open.
n=251 shows a bug in VICE-2.0 and earlier.

border-bm-idle:
---------------
Opens right border in the line before VIC-II changes from Hires bitmap to
idle state. The open border seems to prevents the VIC-II from switching to
black as it usually does in idle state. Exploits a bug in VICE that is
also visible in Krestology/Crest.


