#! /bin/bash

convert -colors 16 $1 -alpha remove -filter point -resize 171%x200% -background none -flatten temp1.png
convert $2 temp2.png
convert -delay 50 -loop 0 -dispose Background -page +0+0 temp2.png -page +35+4 temp1.png $3.gif

convert -crop 657x544+35+4 temp2.png temp2.png
apngasm $3.apng temp1.png 1 2 
#> /dev/null

rm temp1.png temp2.png
