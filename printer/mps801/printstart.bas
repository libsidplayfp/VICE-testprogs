10 open4,4
20 for i = 1 to 4
30 print#4,"0123456789";
40 next i
50 print#4,chr$(10);
60 print#4,chr$(16)chr$(48)chr$(56)"mps-801";
70 print#4,chr$(16)chr$(51)chr$(48)"printer"
80 close4

110 open4,4
130 for i = 1 to 4
130 print#4,"0123456789";
140 next i
150 print#4,chr$(10);
160 print#4,chr$(16)"08mps-801";
170 print#4,chr$(16)"30printer"
180 close4

210 open4,4
220 for i = 1 to 4
230 print#4,"0123456789";
240 next i
250 print#4,chr$(10);
255 print#4,chr$(14);
260 print#4,chr$(16)"08mps-801";
270 print#4,chr$(16)"30printer"
280 close4
