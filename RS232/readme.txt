
This directory contains some programs for testing RS232 features in VICE

first run tcp like this:

tcpser -r -p 6400 -S 1200 -v 25232 -l 4 -tmM -i"s5=20 s0=1 s39=1"

and then run in VICE (userport):

x64sc -default -rsdev3ip232 -rsdev3baud "1200" -rsuserbaud "1200" -rsuserdev "2" -userportdevice "2" <program>

-------------------------------------------------------------------------------

test1.prg:
----------

simple two-way transfer with strings.

TODO: apparently only sending works correctly, no data is being recieved.


userport-dump.prg:
------------------

show status of all userport rs232 input lines, dump input data


userport-miniterm.prg
---------------------

trivial bidirectional "terminal"


-------------------------------------------------------------------------------
Quick Summary of (Userport) RS232 below:
-------------------------------------------------------------------------------

OPEN fn,2,0,chr$(control register)+chr$(command register)

control register:

                  +-+-+-+ +-+ +-+-+-+-+
                  |7|6|5| |4| |3|2|1|0|
                  +-+-+-+ +-+ +-+-+-+-+   BAUD RATE
                   | | |   |  +-+-+-+-+----------------+
     STOP BITS ----+ | |   |  |0|0|0|0| USER RATE  [NI]|
                     | |   |  +-+-+-+-+----------------+
  0 - 1 STOP BIT     | |   |  |0|0|0|1|       50 BAUD  |
  1 - 2 STOP BITS    | |   |  +-+-+-+-+----------------+
                     | |   |  |0|0|1|0|       75       |
                     | |   |  +-+-+-+-+----------------+
                     | |   |  |0|0|1|1|      110       |
                     | |   |  +-+-+-+-+----------------+
    WORD LENGTH -----+-+   |  |0|1|0|0|      134.5     |
                           |  +-+-+-+-+----------------+
 +---+-----------+         |  |0|1|0|1|      150       |
 |BIT|           |         |  +-+-+-+-+----------------+
 +-+-+    DATA   |         |  |0|1|1|0|      300       |
 |6|5|WORD LENGTH|         |  +-+-+-+-+----------------+
 +-+-+-----------+         |  |0|1|1|1|      600       |
 |0|0|  8 BITS   |         |  +-+-+-+-+----------------+
 +-+-+-----------+         |  |1|0|0|0|     1200       |
 |0|1|  7 BITS   |         |  +-+-+-+-+----------------+
 +-+-+-----------+         |  |1|0|0|1|    (1800)  2400|
 |1|0|  6 BITS   |         |  +-+-+-+-+----------------+
 +-+-+-----------+         |  |1|0|1|0|     2400       |
 |1|1|  5 BITS   |         |  +-+-+-+-+----------------+
 +-+-+-----------+         |  |1|0|1|1|     3600   [NI]|
                           |  +-+-+-+-+----------------+
                           |  |1|1|0|0|     4800   [NI]|
       UNUSED -------------+  +-+-+-+-+----------------+
                              |1|1|0|1|     7200   [NI]|
                              +-+-+-+-+----------------+
         Figure 6-1.          |1|1|1|0|     9600   [NI]|
    Control Register Map.     +-+-+-+-+----------------+
                              |1|1|1|1|    19200   [NI]|
                              +-+-+-+-+----------------+

command register:
                             +-+-+-+-+-+-+-+-+
                             |7|6|5|4|3|2|1|0|
                             +-+-+-+-+-+-+-+-+
                              | | | | | | | |
                              | | | | | | | |
                              | | | | | | | |
                              | | | | | | | |
           PARITY OPTIONS ----+-+-+ | | | | +----- HANDSHAKE
 +---+---+---+---------------------+| | | |
 |BIT|BIT|BIT|     OPERATIONS      || | | |        0 - 3-LINE
 | 7 | 6 | 5 |                     || | | |        1 - X-LINE
 +---+---+---+---------------------+| | | |
 | - | - | 0 |PARITY DISABLED, NONE|| | | |
 |   |   |   |GENERATED/RECEIVED   || | | |
 +---+---+---+---------------------+| | | +------- UNUSED
 | 0 | 0 | 1 |ODD PARITY           || | +--------- UNUSED
 |   |   |   |RECEIVER/TRANSMITTER || +----------- UNUSED
 +---+---+---+---------------------+|
 | 0 | 1 | 1 |EVEN PARITY          ||
 |   |   |   |RECEIVER/TRANSMITTER |+------------- DUPLEX
 +---+---+---+---------------------+
 | 1 | 0 | 1 |MARK TRANSMITTED     |               0 - FULL DUPLEX
 |   |   |   |PARITY CHECK DISABLED|               1 - HALF DUPLEX
 +---+---+---+---------------------+
 | 1 | 1 | 1 |SPACE TRANSMITTED    |
 |   |   |   |PARITY CHECK DISABLED|
 +---+---+---+---------------------+

-------------------------------------------------------------------------------

ST status word

 +-----------------------------------------------------------------------+
 | [7] [6] [5] [4] [3] [2] [1] [0] (Machine Lang.-RSSTAT                 |
 |  |   |   |   |   |   |   |   +- PARITY ERROR BIT                      |
 |  |   |   |   |   |   |   +----- FRAMING ERROR BIT                     |
 |  |   |   |   |   |   +--------- RECEIVER BUFFER OVERRUN BIT           |
 |  |   |   |   |   +------------- RECEIVER BUFFER-EMPTY                 |
 |  |   |   |   |                  (USE TO TEST AFTER A GET#)            |
 |  |   |   |   +----------------- CTS SIGNAL MISSING BIT                |
 |  |   |   +--------------------- UNUSED BIT                            |
 |  |   +------------------------- DSR SIGNAL MISSING BIT                |
 |  +----------------------------- BREAK DETECTED BIT                    |
 |                                                                       |
 +-----------------------------------------------------------------------+

-------------------------------------------------------------------------------

$DD01/56577/CIA2+1:   Data Port B (User Port, RS232)
   +-------+------------------------------------------------------+
   | Bit 7 |   User Port PB7 / RS232 Data Set Ready               |
   | Bit 6 |   User Port PB6 / RS232 Clear to Send                |
   | Bit 5 |   User Port PB5                                      |
   | Bit 4 |   User Port PB4 / RS232 Carrier Detect               |
   | Bit 3 |   User Port PB3 / RS232 Ring Indicator               |
   | Bit 2 |   User Port PB2 / RS232 Data Terminal Ready          |
   | Bit 1 |   User Port PB1 / RS232 Request to Send              |
   | Bit 0 |   User Port PB0 / RS232 Received Data                |
   +-------+------------------------------------------------------+
