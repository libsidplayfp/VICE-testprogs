#! /bin/bash

# $1 reference picture
# $2 screenshot
# $3 output prefix

magick $1 -colors 16 -alpha remove -filter point -resize 179%x200% -page +36+1 -background none -flatten temp1.png
magick $2 temp2.png
magick -delay 50 -loop 0 -dispose Background -page +0+0 temp2.png -page +0+0 temp1.png $3.gif

magick temp2.png -crop 687x544+0+0 temp2.png
apngasm -F -o $3.apng -d 1000 temp1.png  temp2.png > /dev/null

rm temp1.png temp2.png
