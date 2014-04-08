
alarm.prg:      check if ALARMTIME = TIME sets bit 2 of ICR

alarm-cond.prg:  checks exact conditions for when bit 2 if ICR gets set 
                 (set time to current alarm time)
alarm-cond2.prg: checks exact conditions for when bit 2 if ICR gets set 
                 (set alarm time to current time)

hour-test.prg:  check AM/PM flag of the hour register

--------------------------------------------------------------------------------

stability.prg, stability-ntsc.prg

measures time between 10th seconds alarms, and shows the result. values shown
are the minimum and maximum amount of cycles between 10th second ticks, the
difference, average and ideal value.

in reality these values may vary surprisingly much. infact, anything between
50.2Hz and 49.8HZ is ok for normal operation of the power grid. values between
50.02Hz and 49.08Hz will not get compensated at all.

- on my c64c the min/max difference is up to ~100 cycles depending on time of
  day or whatnot. also the average time/frequency varies (gpz)
