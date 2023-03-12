
The following has been cut from the 

COMMODORE MPS-801 DOT MATRIX PRINTER USER'S GUIDE

------------------------------------------------------------------------------
6. Performing the Print Head Test

To perform the test, simply switch the self-diagnostic switch to "T" (shown
in Fig. 2.12). The printer will continue to print all the characters
available until 1 ) the printer is turned off; or 2) the self-diagnostic
switch is "flipped" to position 4 or 5.

------------------------------------------------------------------------------

If you are using a MPS-801 printer, the dn (device number) is usually 4. 
Check the test switch on your printer to see what dn to choose.

------------------------------------------------------------------------------
4. Secondary Address

This printer has 2 secondary address (sa). They are used to the character
front table.

       sa = 0: graphic mode.. . (default)
       sa = 7: business mode

businessmode.bas:

Prints character table in business mode.

graphmode.bas:

Prints character table in graphics mode.

------------------------------------------------------------------------------
5. Printing Modes and Control Codes

DESCRIPTION                                            INPUT CODE

Enter Bit Image Mode ..................................CHR$(8)
Line Feed After Printing ..............................CHR$(10)
Carriage Return .......................................CHR$(13)
Enter Double Width Character Mode .....................CHR$(14)
Enter Standard Character Mode .........................CHR$(15)
Tab Setting the Print Head ............................CHR$(16)
Enter Business Mode in Local ..........................CHR$(17)
Start Reverse Field ...................................CHR$(18)
Repeat Bit Image Selected .............................CHR$(26)
Specify Dot Address (must follow Print Head Tab Code)..CHR$(27)
Enter Graphic Mode in Local ...........................CHR$(145)
Turn Off Reverse Field ................................CHR$(146)

------------------------------------------------------------------------------
5.1 Standard Character Mode
5.2 Double Width Character Mode

When the printer is turned on, it is set to start in the STANDARD CHARACTER
mode. But once you select different character modes the printer will
remain in that mode until a different one is chosen using the CHR$ code. 

doublewidth.bas:

For the example below, we started in double width mode "CHR$(14)" for the title
and then went to the stand character mode "CHR$(15)" to list the program.

After typing RUN, you get this result:

MPS-801 PRINTER (<- in double width characters)

10 OPEN 1,4
20 PRINT#1,CHR$(14)"MPS-801 PRINTER"
30 PTINT#1,CHR$(15)
40 CMD 1: LIST

READY.

------------------------------------------------------------------------------
5.3 Bit Image Mode

bitmap.bas:     prints COMMODORE with its logo 4 times.
  
After typing RUN, you get this result:

C= COMMODORE
C= COMMODORE
C= COMMODORE
C= COMMODORE

By using CHR$(8) you enter the bit image mode This allows you to design
and print bit image graphics by inputting data. Each DATA statement is made
of numbers that represent a row of dots which, when READ all together, will
make up your bit image graphic. To design your bit image graphic, follow the
example below. You should notice that each number in the DATA statement
corresponds to 1 row in your bit image graphic. To design a bit image graphic,
follow these steps:

 6. Put your final total for each column into a data statement in column order.

  1 . . * * . . .
  2 . * . . * * .
  4 * . . . * . .
  8 * . . . . . .  -> (Direction of print head movement) ->
 16 * . . . * . .
 32 . * . . * * .
 64 . . * * . . .
128
 156 162 193 182 162 0 <- bytes to send

------------------------------------------------------------------------------
5.4 Print Position Determination

With the CHR$(16) code you can determine the print start position. This is
done by assigning a 2-digit number following the CHR$(16) (see the examples
below).
The 2-digit numbers following the CHR$(16) code are the print start position
of your standard character.

printstart.bas:

0123456789012345678901234567890123456789
       MPS-801                PRINTER

0123456789012345678901234567890123456789
       MPS-801                PRINTER

0123456789013345678901334567890123456789
        M P S - 8 0 1         P R I N T E R  (double width)

------------------------------------------------------------------------------
5.5 Print Start Position-Dot Address

Using the CHR$(27), the absolute address (dot units) can be specified via the
following format.

CHR$(27)   CHR$(16)     CHR$(HP)     CHR$(LP)

The 2 bytes that follow CHR$(27) and CHR$(16) are binary data used to
indicate the absolute address away from the home position (dot units).

dotstart.bas:

Will print COMMODORE and its logo from the 100th
dot position (16 charades plus 5 dots).

                C= COMMODORE


NOTE FOR THESE NEXT TWO TABLES THE LETTER P OR D FOLLOWED
BY A NUMBER MEANS THE LETTER TO THE POWER OF THE NUMBER. EG  D6 = D TO THE
POWER OF 6. THIS IMPROVISATION IS CAUSE BY THE USE OF PLAIN ASCII.
(DEAN THOMPSON)

          D7 D6 D5 D4 D3 D2 D1 D0
1st byte  0  0  0  0  0  0  0  0     Higher 1 bit (HP)
2nd byte  P7 P6 P5 P4 P3 P2 P1 P0    Lower 8 bits (LP)

The above 2 bytes are used to indicate the staring print position and are
treated as a single 9 bit binary notation data inside the Printer.

P8 P7 P6 P5 P4 P3 P2 P1 P0

For example the dot address 15 can be determined by HP=CHR$(0),LP=CHR$(15).

dot address
|                                                     |     |                |
|0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17|     |476 477 478 479 | 
|o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  *  o |     | o   o   o   o  |
|o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  *  o |     | o   o   o   o  |
|o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  *  o |.....| o   o   o   o  |
|o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  *  o |     | o   o   o   o  |
|o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  *  o |     | o   o   o   o  |
|o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  *  o |     | o   o   o   o  |
|o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  *  o |     | o   o   o   o  |
|                  |                 |                |     |                |
00                 01                02                    79
|
character address

------------------------------------------------------------------------------

sinus.bas:

Using to change a print start position-dot address, try to make sine curve.

------------------------------------------------------------------------------
5.6 Repetition of Bit Image Data

By using CHR$(26) you can repeat bit image data where you wish

CHR$(8) ... CHR$(26) <NUMBER OF REPETITION> <DATA>

repeat.bas:

What is actually repeatable is just 1 column of bit image information. The
following example uses a CHR$(26) code to draw the histogram

1978  ********  34
1979  *****************  57
1980  ************************  75
1981  *********************************  88
1982  ************************************************  123
1983  *****************************************************************  186

------------------------------------------------------------------------------
5.7 Graphic Mode in Local
5.8 Business Mode in Local

By sending the cursor up code [CHR$(145)] to your printer, following charac-
ters will be printed in cursor up (graphic) mode until either a carriage
return or cursor down code [CHR$(17)] is detected.

By sending the cursor down code [CHR$(145)] to your printer, following
characters will be printed in business mode until either a carriage return or
cursor up code [CHR$(145)] is detected.

localgraph.bas:

*       spade
*       heart
*       diamond
*       club

localbusiness.bas:

spade     *
heart     *
diamond   *
club      *

localmode.bas:

A combination of the above, with an additional pattern made by printing via
alternating secondary address.

FIXME: It is not clear under what conditions the local status is reset to what
the secondary address implies, so the output of this program must be checked on
a real printer!

------------------------------------------------------------------------------
5.9 Reverse Field Mode
5.10 Reset Reverse Field Mode

By selecting the CHR$(18) you have turned on a REVERSE FIELD mode. This
prints white letters on a black background.

When you use CHR$(146) you turn OFF the REVERSE FIELD mode

reverse.bas:

Personal Computer   (in reverse mode)
Dot Matrix Printer  (in normal mode)

Personal Computer    (in reverse mode)
Dot Matrix Printer   (in reverse mode)

------------------------------------------------------------------------------
5.11 Mixture of Various Print Mode

You can use the following example to get an idea as to how to combine more
than 1 print mode, even in one line.

modemix.bas:

C= COMMODORE (in double width)

------------------------------------------------------------------------------
5.12 Line Feed Spacing

Linefeeds are executed in accordance with the print mode in effect just prior to
the execution of a print command.

* Character and double width character modes ...........6 LPI*
* Bit image mode .............................. ........9 LPI*
                                                  (*LPI = Line Per Inch)

linespacing.bas:

ascii
+--------------+---------------+
!              !               !
+--------------+---------------+
!              !               !
+--------------+---------------+
petscii (this one should be seamless)
+--------------+---------------+
!              !               !
+--------------+---------------+
!              !               !
+--------------+---------------+

------------------------------------------------------------------------------
5.13 Data Buffer Size

Your printer's print-line buffer can contain up to 90 byes of data. At least
1 byte will be used for the CHARACTER mode. But since your printer
provides you with automatic printing, you are guaranted that no loss of data
due to overflow will occur. This means that you really don't have to worry
about buffer size. In addition to the print data, the following will also be
included in your buffer:

        Input Code                                  Bytes
        CHR$(8) ......................................1
        CHR$(10) .....................................1
        CHR$(13) .....................................1
        CHR$(14) .....................................1
        CHR$(15) .....................................1
        CHR$(16)/CHR$(HP)/CHR$(LP) ...................3
        CHR$(17) .....................................1
        CHR$(18) .....................................1
        CHR$(26)/number of repetitions/bit image data.3
        CHR$(27)/CHR(16)/CHR$(HP)/CHR$(LP)............3
        CHR$(145) ....................................1
        CHR$(146) ....................................1

------------------------------------------------------------------------------
6. Automatic Printing

Automatic printing will occur under 3 conditions. In order to understand ex-
actly what's happening, you have to have a little knowledge about how your
printer works. First, each printed character is made from 6 rows of dots. Next,
you can have up to 80 characters per printed line (spaces count as 6 dot
positions just like letters and numbers). This means that there are a total
of 480 dots per line. Now you're ready for the 3 conditions.

a.   When the buffer fills up during the input of data.

b.   When your printer "sees" that you have used up more than the 480 dots
     per line that was described above.

c.   When both a and b happen at the same time.

What will happen when these conditions occur?

a. When the buffer fills during printing, it prints out everything is has been
   storing onto your paper. But . . . it remembers where it stopped printing
   so that it can continue from that point, when and if you want to. Or it
   will print again when you fill the buffer again.

b. When the printer uses up more than 480 dots, then it prints out the line
   and then stops and tells you that it's READY for more information.

c. When both a and b occur, your printer will "dump" only the first 80
   characters and print them. Then it will move to the next line. At this
   point, the printer will do 2 things: 1 ) It will hold any characters that
   have been left in the buffer and add to them; 2) It will give you a READY
   for more information statement.

------------------------------------------------------------------------------

When an odd number of CHR$(34) is detected in a line, the control
codes $00-$1F and $80-$9F will be made visible by printing a
reverse character for each of these controls. This will continue until
an even number of quotes [CHR$(34)] has been received or until
end of this line.
