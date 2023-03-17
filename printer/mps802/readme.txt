Printing Method          Serial Impact Dot Matrix
Print Rate               45 Ipm* with 80 columns printed
                         78 Ipm with 40 columns printed
                         124 Ipm with 20 columns printed
Print Direction          Bi-directional
Column Capacity          80
Character Font           8X8
Line Spacing             Programmable
. Character Size         0.094" high, 0.08" wide
Copies                   3, including original
Ribbon Type              Cartridge
Ribbon Life              1.2 X 108 characters
Ribbon Cartridge         Commodore PIN 613160550
Paper Width              4.5" to 10" (including tractor holes)
Forms                    7.5 + (0.5 X 2 sprocket margins)
                         Pin-to-pin distance: .5" longitudinally
                                            9.5" laterally
                                            5/32" diameter 

*Lines per minute


secondary address:

0 Print data exactly as received in Upper/Graphics case.
1 Print data according to a previously-defined format
2 Store the formatting data
3 Set the number of lines per page to be printed
4 Enable the printer format diagnostic messages
5 Define a programmable character
6 Set spacing between lines
7 Print data exactly as received in Upper/Lower case.
9 Suppress diagnostic message printing
10 Reset printer 

--------------------------------------------------------------------------------

Printing Data According to a Previously Defined Format: sa = 1

A secondary address of 1 invokes the formatting features of your printer. The data to be
printed is arrayed according to a previously specified format using sa = 2. If you should
transmit a string of data when sa = 1 is in effect and there is no formatting data in the
printer's memory, then the data string is printed exactly as it is received.

When formatting string data from the computer, a skip, CHR$(29), must be sent to
delimit the end of a string being edited to a field. Leading blanks are stripped off a
string; therefore, to print a blank alpha field you must transmit·a shifted blank,
CHR$(160). The alpha field is then right padded with blanks as shown below.

Example:

10 OPEN 2,4,2   : rem store formatting data
20 OPEN 1,4,1   : rem print formatted data
30 PRINT#2,"AAA   AAA   AAA"
40 PRINT#1,"ABC"CHR$(29)CHR$(160)CHR$(29)"DEF"
50 CLOSE 2:CLOSE 1

Results in:

ABC             DEF

--------------------------------------------------------------------------------

Defining a Programmable Character: sa = 5

A secondary address of 5 allows you to create a custom character of your own. This
programmable character is initialized with this secondary address. 

customchar.bas:











