This directory contains various VIA tests, ported from andre fachats 
ciavarious.

The idea is that andres programs cover a bunch of things that likely matter for
the VIA too. the respective tests have been reworked to match what the original
test want to do as close as possible.
--------------------------------------------------------------------------------

THIS IS WORK IN PROGRESS, THE TESTS DO NOT ACTUALLY WORK PROPERLY YET, AND NO
REFERENCE DATA IS ATTACHED SO THEY WILL ALWAYS SHOW RANDOM ERRORS/RED

--------------------------------------------------------------------------------

CIA      VIA

$dc00 -> $1801  Port A Data
n/a      $180f  Port A Data (no handshake)
$dc01 -> $1800  Port B Data
$dc02 -> $1803  Port A DDR
$dc03 -> $1802  Port B DDR

$dc04 -> $1804  Timer A lo
$dc05 -> $1805  Timer A hi
n/a      $1806  Timer A Latch lo
n/a      $1807  Timer A Latch hi
$dc06 -> $1808  Timer B lo
$dc07 -> $1809  Timer B hi

$dc08 -> n/a    TOD 10th sec
$dc09 -> n/a    TOD sec
$dc0a -> n/a    TOD min
$dc0b -> n/a    TOD hour

$dc0c -> $180a  Synchronous Serial I/O Data Buffer

$dc0d -> $180d  IRQ CTRL  (w:Enable Mask / r:Acknowledge)
         $180e  IRQ flags

$dc0e ->        CTRL A (TimerA)
$dc0f ->        CTRL B (TimerB)

         $180b  Aux Control (TimerA, TimerB)
         $180c  Peripherial Control

- no cascade mode for timers
- timers run always
- no TOD clock
+ seperate register for the Timer A latch

http://www.zimmers.net/anonftp/pub/cbm/documents/chipdata/6522-VIA.txt
http://www.zimmers.net/anonftp/pub/cbm/schematics/drives/new/1541/1541-II.gif

--------------------------------------------------------------------------------

VIA1:   Timer A / B
VIA2:   Timer A / B

VIA3:   Timer A / B IRQ Flags
VIA3a:  Timer A / B IRQ Flags

VIA6:   Timer A / B (Cascade)
VIA7:   Timer A / B (Cascade)
VIA8:   Timer A / B (Cascade) IRQ Flags

VIA14:   Timer A / B (Cascade)
