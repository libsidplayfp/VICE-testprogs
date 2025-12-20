#! /bin/bash

function maketests
{
magick ../references/$1.prg.png -resize 171%x200% -page +35+4 -crop 720x576+0+0 temp1.png
magick ./zerox-6569r1/6569r1_$1.png -crop 720x576+0+0 temp2.png
magick ./zerox-6569r5_1886_s/6569R5_1886_S_$1.png -crop 720x576+0+0 temp3.png

#magick -delay 100 -loop 0 -dispose Background temp1.png temp2.png temp3.png ./$1.gif
magick -delay 100 -loop 0 -dispose Background temp2.png temp3.png ./$1.gif


magick ../references/$1.prg-8565.png -resize 171%x200% -page +35+4 -crop 720x576+0+0 temp1.png
magick ./zerox-8565r2/8565r2_$1.png -crop 720x576+0+0 temp2.png
magick ./unseen-nogreydot/unseen-$1.png -resize 96%x100% -page +0+3 -crop 720x576+0+0 temp3.png
magick ./unseen-greydot/unseen-$1.png -resize 96%x100% -page +0+3 -crop 720x576+0+0 temp4.png

#magick -delay 100 -loop 0 -dispose Background temp1.png temp2.png temp3.png temp4.png ./$1-8565.gif
magick -delay 100 -loop 0 -dispose Background temp2.png temp3.png temp4.png ./$1-8565.gif


magick ../references/$1_ntsc.prg.png -resize 165%x200% -page +33-13 -crop 720x576+0+0 temp1.png
magick ./encore-6567r8/$1.png -crop 720x576+0+0 temp2.png
magick ./encore-6567r56a/$1.png -crop 720x576+0+0 temp3.png

#magick -delay 100 -loop 0 -dispose Background temp1.png temp2.png temp3.png ./$1-ntsc.gif
magick -delay 100 -loop 0 -dispose Background temp2.png temp3.png ./$1-ntsc.gif


rm -f temp1.png temp2.png temp3.png temp4.png
}

maketests videomode-v
maketests videomode-w
maketests videomode-x
maketests videomode-y
maketests videomode-z
maketests videomode1
maketests videomode2
