#! /bin/bash
c1541 Source1.d64 -extract
c1541 Source2.d64 -extract
c1541 Source3.d64 -extract
c1541 Source4.d64 -extract
c1541 Source5.d64 -extract
c1541 Source6.d64 -extract

find -name "*.asm" -exec TMPview -i {} -o {}.s \;
rename .asm.s .s *.asm.s
