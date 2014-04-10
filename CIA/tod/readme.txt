
Im this directory we collect some tests related to the TOD clock of the CIA.

--------------------------------------------------------------------------------

Facts about the TOD clocks:

- C64 kernal does not initialize or touch them in any way
- clock is stopped by write to hour register and restarted by write to 
  .1 seconds register
- MSB of control register B ($dc0f/$dd0f) decides whether writes will be used as 
  TOD (=0) or alarm time (=1)
- alarm time can't be read other than reading time when alarm interrupt occurs
- reading hour register will "freeze" the other registers return values
  to allow reading the proper time. Clock is still running, though.
- reading the .1 seconds register will unfreeze them and allows to read actual 
  time the next time
- hours register is autofixed if nonsense-values get poked in. writing 0 instead 
  of 12am is possible, though
- minutes and seconds registers will fix any nonsense values when carry over 
  from next lower register occurs. Seems to always inc the next higher register, 
  too.
- bug/feature: poking 12 pm into hours register turns to 12 am and vice versa.
  apparently cia constantly monitors writes to hour register and mechanically
  flips am/pm bit whenever hour value changes to 12, no matter whether value
  is poked in from outside or is result of carryover from minutes register.

--------------------------------------------------------------------------------

alarm.prg:      check if ALARMTIME = TIME sets bit 2 of ICR

alarm-cond.prg:  checks exact conditions for when bit 2 if ICR gets set 
                 (set time to current alarm time)
alarm-cond2.prg: checks exact conditions for when bit 2 if ICR gets set 
                 (set alarm time to current time)

--------------------------------------------------------------------------------

4tod.prg, 4todcia.prg:

this one repeatedly starts tod at 0:00:00.0 with alarm-nmi enabled
when either the alarm is triggerd or tod ran for 1 second it will print out
whether an alarm-nmi occured or not.

expected: NO alarm in 2nd run

--------------------------------------------------------------------------------

5tod.prg:

this one repeatedly starts tod at 0:00:00.0 with alarm-nmi enabled
when either the alarm is triggerd or tod ran for 1 second it will print out
whether an alarm-nmi occured or not.

this version will set the clock to the power up state of 1:00:00.0 after every
test that didn't trigger an alarm, to see if the weird behaviour of the 2nd pass
can be repeated.

expected: first run alarm, second NO alarm, third alarm, etc

--------------------------------------------------------------------------------

6tod.prg:

this one repeatedly starts tod at 0:00:00.0 with alarm-nmi enabled
when either the alarm is triggerd or tod ran for 1 second it will print out
whether an alarm-nmi occured or not.

this version will always reset the clock to the power up state of 1:00:00.0

expected: always alarm

--------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------

TODO:

- make test for power-on defaults (is time really always 1:00:00.0 ?, whats in
  the latch and what is the alarm time?)
- test the "autocorrection" for the time and alarm-time values (when do they
  happen, what exactly happens)
- test whether MSB of ctrlB makes reading of alarm time possible or not (it
  should always be the time)
