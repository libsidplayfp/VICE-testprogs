This directory contains various VIA tests, ported from andre fachats 
ciavarious.

This is work in programs, the tests do not actually work properly yet, and no
reference data is attached so they will always show random errors/red

--------------------------------------------------------------------------------

CIA      VIA

$dc00 -> $1801  Port A Data
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

$dc0d ->        IRQ Enable Mask / Acknowledge

$dc0e ->        CTRL (TimerA)
$dc0f ->        CTRL (TimerB)

--------------------------------------------------------------------------------

VIA1:   Timer A / B
VIA2:   Timer A / B

