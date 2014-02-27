
alarm.prg:      check if ALARMTIME = TIME sets bit 2 of ICR

hour-test.prg:  check AM/PM flag of the hour register

stability.prg:  measures time between 10th seconds alarms, and shows the result.
                currentliy in VICE this time is stable (only differences caused
                by irq jitter, up to 3 cycles).
                - on my c64c the time varies up to ~40 cycles (gpz)