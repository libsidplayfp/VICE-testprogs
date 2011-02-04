   10 rem        written by
   20 rem     patrick mcallister
   30 rem                                 ^
   40 rem   use this program to learn how
   50 rem   create and use relative files.
   60 rem   it is flexible enough for you
   70 rem   to customize it for your use.
   80 ll$=chr$(13)   :rem  this is the field delimiter used when writing records
   90 open15,8,15,"i0":close15 : rem  initialize the disk drive.
  100 input"{clr}what is the name of the file";nm$ :rem  maximum 16 character name.
  110 input"how many characters in each record";ln  :rem    maximum 254.
  115 print
  120 print"{down}do you want to"
  122 print"{rvon}r{rvof}ead a record"
  124 print"{rvon}w{rvof}rite a record"
  126 print"{rvon}s{rvof}et up a file"
  128 input"or {rvon}q{rvof}uit";a$
  130 if a$="r" then 200
  140 if a$="w" then 400
  150 if a$="s" then 600
  160 if a$="q" then 800
  170 print"type an 'r' 'w' 's' or 'q'  ":goto120
  190 :
  200 rem  this section positions to and reads a record.
  210 open15,8,15           :rem open the command channel
  220 gosub 5000 :rem  check the error channel
  230 open8,8,8,"0:"+(nm$)+",l,"+chr$(ln) :rem  open file with record length ln.
  240 gosub 5000 :rem  check the error channel
  250 input"read what record number";rn
  260 gosub1000 :rem  calculate the low byte/high byte pointer.
  270 print#15,"p"+chr$(96+8)+chr$(rl)+chr$(rh)+chr$(1) :rem  position command
  280 gosub 5000 :rem  check the error channel
  285 if e=50 thenprint"record number to large":goto340
  290 input#8,aa$,bb$,cc$,dd$,ee$ :rem  read in the fields.
  300 gosub 5000 :rem  check the error channel
  310 print"{down}record number";rn;"contains:"
  315 print"    name: ";aa$
  320 print" address: ";bb$
  325 print"    city: ";cc$
  330 print"   state: ";dd$
  335 print"zip code: ";ee$
  340 input"{down}read another record";a$
  350 if a$="y"then250
  360 close8:close15:goto120 :rem  go to the menu
  390 :
  400 rem  this section positions to and writes a record.
  410 open15,8,15           :rem open the command channel
  415 gosub 5000 :rem  check the error channel
  420 open8,8,8,"0:"+(nm$)+",l,"+chr$(ln) :rem  open file with record length ln.
  430 gosub 5000 :rem  check the error channel
  440 input"{down}write what record number";rn
  445 input"name";aa$       :rem  change the prompts to ask for the data needed
  450 input"address";bb$    :rem  in your particular application.
  455 input"city";cc$       :rem  any number of fields can be used as long as
  460 input"state";dd$      :rem  they fit within the record length you
  470 input"zip code";ee$   :rem  specified when creating the file.
  480 rc$=aa$+ll$+bb$+ll$+cc$+ll$+dd$+ll$+ee$
  490 rem  rc$ is the string containing all the fields for the record.
  500 rem  remember the max length for rc$ is 254 characters.
  510 gosub1000 :rem  calculate the low byte/high byte pointer.
  520 print#15,"p"+chr$(96+8)+chr$(rl)+chr$(rh)+chr$(1) :rem  position command
  530 gosub 5000 :rem  check the error channel
  535 if e=50 thenprint"the dos will expand the file now"
  540 print#8,rc$  :rem  write the record
  550 gosub 5000 :rem  check the error channel
  560 input"write another record";a$
  570 if a$="y"then430
  580 close8:close15:goto120 :rem  go to the menu
  590 :
  600 rem  this section positions to and writes the highest record number.
  610 rem  although not entirely necessary, writing and updating long files
  620 rem  is speeded when this proceedure is used.  this will cause the
  630 rem  dos side sector list to be created entirely at the start rather
  640 rem  that being appended for each new higher record number.
  650 open15,8,15           :rem open the command channel
  660 gosub 5000 :rem  check the error channel
  670 open8,8,8,"0:"+(nm$)+",l,"+chr$(ln) :rem  open file with record length ln.
  680 gosub 5000 :rem  check the error channel
  690 print"{down}what is the highest record number"
  695 input"you want to use";rn
  700 gosub1000 :rem  calculate the low byte/high byte pointer.
  710 print#15,"p"+chr$(96+8)+chr$(rl)+chr$(rh)+chr$(1) :rem  position command
  720 gosub 5000 :rem  check the error channel
  725 if e=50 thenprint"the dos will expand the file now"
  730 print#8,chr$(255) :rem
  740 gosub 5000 :rem  check the error channel
  750 close8:close15:goto120 :rem  go to the menu
  800 close8:close15:end
 1000 rem  this subroutine calculates the record number pointer
 1010 rem  in the low byte/high byte format.
 1020 rem  rn (record number) is used to calculate rl and rh.
 1030 rh=int(rn/256):rl=rn-(256*rh) : rem  rl is low -- rh is high.
 1040 return
 5000 rem   this is the disk drive error checking subroutine.
 5010 input#15,e,e$,a,b   :rem  read the error channel.
 5020 if e=0 then return  :rem  there is no error if e=0.
 5030 rem   e=50 (record not present) any time a record number pointer is
 5040 rem   positioned beyond the current highest record number.
 5050 if e=50 then return
 5060 print"there is an i/o problem"
 5070 print"error number is";e,e$
 5080 print"at track";a;"   sector";b
 5090 if e=70 thenprint"{down}make sure you input the correct record"
 5100 if e=70 thenprint"length for an existing file name."
 5110 close8:close15:stop
