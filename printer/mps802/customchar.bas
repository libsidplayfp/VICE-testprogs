10 data 28,34,65,65,54,34,0,0
20 open 5,4,5: rem define custom character
30 for i=1 to 8:read a:a$=a$+chr$(a):next
40 print#5,a$: rem send bitmap data
50 open 4,4
60 for i=1 to 10
70 print#4,chr$(14)chr$(254)" {up}c{down}ommodore {up}b{down}usiness {up}m{down}achines"
80 next
90 close 5
100 close 4
