this small test reproduces the FLD picture scroller used at the beginning
of "Cataball+3/Decibel".

press A and S to shift the timing left/right by one cycle
press left SHIFT to stop/hold movement

when the displayed hex number is in the range 21-29 the text screen should
scroll up and down via FLD. outside of this range line crunching and/or FLI 
will happen:

1C-20 top: stretched char data 
      bottom: "rolling" screen (line crunching)
21-29 top: idle gfx
      bottom: FLD
2A    repeated first charline, 2 black $ff chars on the right
2B    repeated first charline, 1 black $ff chars on the right
2C    repeated first charline, no black $ff char on the right
2D    repeated first charline, 1 black $ff char on the left
2E    repeated first charline, 2 black $ff char on the left
2F    repeated first charline, 3 black $ff char on the left

5B-5F "rolling" screen (line crunching)
60-68 FLD
