This program tests how the record length is parsed.
The real drive code allows "0:NAME,Ljunk,length"  just like it allows
"NAME,SEQ,READ". This program tries various weird combinations, and
afterwards you can see in the directory which record length was the
result. I added the observed values from a 1541-II here but I have no
doubt it's the same in all drives.

The cases with "no channel" specify no correct length, so the drive
will try to open an existing file for read, which will fail.

;test5 ==0801==
  100 open 15,8,15
  110 l1$=chr$(17): l2$=chr$(23)
  200 open 2,8,2,"0:n2,l"+l1$+l2$
  210 gosub 2000: rem no channel
  300 open 2,8,2,"0:n3,l,"+l1$+l2$
  310 gosub 2000: rem 17
  400 open 2,8,2,"0:n4,l"+l1$+","+l2$
  410 gosub 2000: rem 23
  500 open 2,8,2,"0:n5,l,"+l1$+","+l2$
  510 gosub 2000: rem 17
  600 open 2,8,2,"0:n6,l,,"+l1$+","+l2$
  610 gosub 2000: rem $2c comma
  700 open 2,8,2,"0:n7,l"+l1$+",,"+l2$
  710 gosub 2000: rem $2c
  800 open 2,8,2,"0:n8,l"+l1$
  810 gosub 2000: rem no channel
  999 end
 1000 input#15,en,es$,et,es
 1010 print en;es$;et;es
 1020 return
 2000 print#15,"p"+chr$(96+2)+chr$(1)+chr$(0)+chr$(1);
 2010 gosub 1000
 2020 print#2,"hallo";
 2030 gosub 1000
 2040 close 2
 2050 return

