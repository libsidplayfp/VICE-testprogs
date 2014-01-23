
    5 print "printer test... check printer output when done"

   10 open1,4,1:gosub 100
   99 cmd 1:list

  100 print#1,"printer quote mode test"
  130 print#1,chr$(34);chr$(147);chr$(34)
  135 print#1,"control chars $00 to $1f:"
  145 print#1,chr$(34);:fori=0to31:print#1,chr$(i);:next:print#1,chr$(34)
  146 print#1,"control chars $80 to $9f:"
  147 print#1,chr$(34);:fori=0to31:print#1,chr$(i+128 );:next:print#1,chr$(34)
  170 return

  187 :
  188 rem followin line is exactly 80 characters long:
  189 rem 901234567890123456789012345678901234567890123456789012345678901234567890

  190 rem *******************************
  191 rem * the following are just some *
  192 rem * frequently used control     *
  193 rem * chars in a nonsense basic   *
  194 rem * program                     *
  195 rem *******************************
  196 :
  200 print"{blk}{wht}{red}{cyn}{pur}{grn}{blu}{yel}{rvon}{rvof}"
  210 print"{clr}{home}{left}{right}{up}{down}"