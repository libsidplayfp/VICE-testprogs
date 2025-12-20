
the makefile can be used to create "animations" from the reference picture and
the screenshots.

two kind of animations will be produced

- .gif format (which all viewers can show, however they are 256 colors only and
  that may be problematic and not allow to see all details)
- .apng format (which is truecolor, but few viewers support it - firefox for
  example will show the animation, many other viewers will only show the first
  frame)

The animation(s) in this (root) dir contain one frame for each tested machine/
chip. This allows to see differences between the individual ICs.

The animation(s) in the individual directories contain the reference data, and
the screenshot(s). This allows to see how different those really are.
