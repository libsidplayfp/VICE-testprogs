This tests for a bug introduced by r30700 - when all timers are set to 0, the
emulator would hang (in viacore) with unresponsive GUI. (fixed in r30719)

via1crash.prg:
    sets all VIA1 timers to 0, should return "all ok"

via2crash.prg:
    sets all VIA2 timers to 0, the program will hang when setting T1H, as that
    is used by the system IRQ.
