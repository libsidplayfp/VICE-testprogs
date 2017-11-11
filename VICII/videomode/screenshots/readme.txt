
the makefile can be used to create "animations" from the reference picture and
the screenshots.

two kind of animations will be produced

- .gif format (which all viewers can show, however they are 256 colors only and
  that may be problematic and not allow to see all details)
- .apng format (which is truecolor, but few viewers support it - firefox for
  example will show the animation, many other viewers will only show the first
  frame)

--------------------------------------------------------------------------------

videomode-v:
- matches: unseen-nogreydot, unseen-greydot
- with zerox-8565r2 shows a one pixel difference in the bottom white dotted line

videomode-x: 
- shows a one pixel difference in the transition of the bottom red line to the 
  red/cyan pattern. hard to tell what is right
- zerox-6569r5_1886_s does not match the reference, it seems to match the 8565
  reference (?)

videomode-z:
- matches: zerox-8565r2
- shows a one pixel difference in the transition of the bottom black line to the 
  red/cyan pattern. hard to tell what is right

videomode2:
- shows some one pixel differences. hard to tell what is right
  
TODO: 

- we need more, and more detailed screenshots so the references can be fixed
  and verified
- additional reference (and testsuite support) for 6569r1 might be needed
