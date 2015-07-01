when a new badline is forced by writing values to $d011 so the badline condition
matches every line, the first 3 characters do not get proper color information.

blackmail.prg:

display routine from "Blackmail FLI Designer 2.2" - which allows to use some
additional colors in the first 3 characters for the "11" pixels, by using
various illegal opcodes in the display routine which leave different values on
the otherwise floating bus. "01" and "10" pixels will remain light grey ($0f)

