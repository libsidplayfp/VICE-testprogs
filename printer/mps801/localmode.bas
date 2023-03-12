
10  cu$=chr$(145):cd$=chr$(17)
11  open7,4,7
12  open8,4,0

30  for i = 1 to 2

100 print#8, "graphics mode (<- uppercase)"
110 print#8,cd$"Spade   "cu$"A"
120 print#8,cd$"Heart   "cu$"S"
130 print#8,cd$"Diamond "cu$"Z"
140 print#8,cd$"Club    "cu$"X"

200 print#7, "Business Mode"
210 print#7,cu$"A       "cd$"Spade"
220 print#7,cu$"S       "cd$"Heart"
230 print#7,cu$"Z       "cd$"Diamond"
240 print#7,cu$"X       "cd$"Club"

300 next

400 print#7,"Spade   ";
410 print#8,"A       "cd$"Spade"
420 print#7,"Heart   ";
430 print#8,"S       "cd$"Heart"
440 print#7,"Diamond ";
450 print#8,"Z       "cd$"Diamond"
460 print#7,"Club    ";
470 print#8,"X       "cd$"Club"

500 print#8,"A       ";
501 print#7,"Spade   ";
502 print#8,"A       ";
503 print#7,"Spade   "
504 print#8,"S       ";
505 print#7,"Heart   ";cu$;
506 print#8,"S       ";
507 print#7,"Heart   "
508 print#8,"Z       ";cd$;
509 print#7,"Diamond ";
510 print#8,"Z       ";
511 print#7,"Diamond "
512 print#8,"X       ";cd$;
513 print#7,"Club    ";cu$;
514 print#8,"X       ";
515 print#7,"Club    "

900 close8
901 close7
