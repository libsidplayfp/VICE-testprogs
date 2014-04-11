
In this directory we collect some tests related to the TOD clock of the CIA.

--------------------------------------------------------------------------------

For some reason the TOD clock is neither documented very well in the original
datasheet, nor was it ever investigated in detail by anyone else until now - the
following is an attempt to collect the available info and prove it piece by
piece in seperated test programs.

--------------------------------------------------------------------------------

First, this is what the datasheet says: (a (*) before a sentence/paragraph 
indicates parts that still need to be backed up by a test)

The TOD clock is a special purpose timer for real-time applications. TOD 
consists of a 24-hour (AM/PM) clock with 1/10th second resolution. It is 
organized into 4 registers: 10ths of seconds, Seconds, Minutes and Hours. The 
AM/PM flag is in the MSB of the Hours register for easy bit testing. Each 
register reads out in BCD format to simplify conversion for driving displays, 
etc. The clock requires an external 60 Hz or 50 Hz (programmable) TTL level 
input on the TOD pin for accurate time-keeping. In addition to time-keeping, 
a programmable ALARM is provided for generating an interrupt at a desired time. 

The ALARM registers or located at the same addresses as the corresponding TOD 
registers. Access to the ALARM is governed by a Control Register bit. The ALARM 
is write-only; any read of a TOD address will read time regardless of the state 
of the ALARM access bit. (->poweron.prg)

(*) A specific sequence of events must be followed for proper setting and reading 
of TOD. TOD is automatically stopped whenever a write to the Hours register 
occurs. The clock will not start again until after a write to the 10ths of 
seconds register. This assures TOD will always start at the desired time. 

(*) Since a carry from one stage to the next can occur at any time with respect to a 
read operation, a latching function is included to keep all Time Of Day 
information constant during a read sequence. All four TOD registers latch on a 
read of Hours and remain latched until after a read of 10ths of seconds. The TOD 
clock continues to count when the output registers are latched. 

(*) If only one register is to be read, there is no carry problem and the register 
can be read "on the fly," provided that any read of Hours is followed by a read 
of 10ths of seconds to disable the latching.

Register format:

REG  NAME           D7      D6      D5      D4      D3      D2      D1      D0
8    TOD 10THS      0       0       0       0       T8      T4      T2      T1
9    TOD SEC        0       SH4     SH2     SH1     SL8     SL4     SL2     SL1
A    TOD MIN        0       MH4     MH2     MH1     ML8     ML4     ML2     ML1
B    TOD HR         AM/PM   0       0       HH      HL8     HL4     HL2     HL1

Read:  always TOD
Write: CRB7=0 TOD       CRB7=1 ALARM

additionally:

REG E (CRA) bit7 (TODIN)   1=50 Hz clock required on TOD pin for accurate time,
                           0=60 Hz clock required on TOD pin for accurate time.
REG F (CRB) bit7 (ALARM)   1=writing to TOD registers sets ALARM,
                           0=writing to TOD registers sets TOD clock.

--------------------------------------------------------------------------------

More facts about the TOD clocks that are not in the datasheet: (a (*) before a 
sentence/paragraph indicates parts that still need to be backed up by a test)

- C64 kernal does not initialize or touch them in any way (not really a property
  of the CIA, but it means they can be tested completely without the kernal
  interfering)
- (*) hours register is autofixed if nonsense-values get poked in. writing 0 instead 
  of 12am is possible, though
- (*) minutes and seconds registers will fix any nonsense values when carry over 
  from next lower register occurs. Seems to always inc the next higher register, 
  too.
- bug/feature: poking 12 pm into hours register turns to 12 am and vice versa.
  apparently cia constantly monitors writes to hour register and mechanically
  flips am/pm bit whenever hour value changes to 12, no matter whether value
  is poked in from outside or is result of carryover from minutes register.
- (*) Wikipedia says: Due to a bug in many 6526s, the alarm IRQ would not always 
  occur when the seconds component of the alarm time is exactly zero. The 
  workaround is to set the alarm's tenths value to 0.1 seconds.
- reading the clock (hour to tenths) does not start it

- at powerup 
  - the clock is not running
  - the time value read from the latch is 01:00:00.0 (mostly, hour might be $11 ...)
  - the am/pm flag is random
  - the alarm is set to 00:00:00.0 by default, and because of that does not
    trigger unless the time is forced to 00:00:00.0 too

--------------------------------------------------------------------------------

alarm.prg:       check if ALARMTIME = TIME sets bit 2 of ICR

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

powerup.prg

checks the state of the TOD clock at power-on

note: i have seen $01 (mostly) but also $11 (rare) in the hour register when
      it is $11, often also the am/pm flag is 1, too. (gpz) 

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

- test the "autocorrection" for the time and alarm-time values (when do they
  happen, what exactly happens)
- test whether MSB of ctrlB makes reading of alarm time possible or not (it
  should always be the time)
- test if time stops updating when writing the hour register when either time or
  alarm is selected ("mapping the 64" claims it does)
