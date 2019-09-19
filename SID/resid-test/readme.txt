################################################################################
This directory contains the original reSID test programs written by Dag Lem
################################################################################

================================================================================
Envelope
================================================================================

boundary.prg:
boundary-dump.prg:
------------------

envelope test (decay)

boundary-dump.prg saves result to disk (97 blocks, $6000 bytes)
boundary.prg compares data on disk against sampled data

verified: C64C+8580,C64+6581


envdelay.prg:
-------------

tests the envelope delay bug

verified: C64C+8580,C64+6581 - output:

8011
8011
8011
8011
8011
8011
8011
8011
8011
8011
8011
8011
8011
8011


envrate.prg:
------------

measures the rate counter periods

verified: C64C+8580,C64+6581 - output:

0009
0020
003f
005f
0095
00dc
010b
0139
0188
03d1
07a2
0c36
0f43
2dc8
4c4c
7a13


envsample.prg:
envsample-dump.prg:
-------------------

envelope test (decay)

envsample-dump.prg saves result to disk (4 times 97 blocks, $6000 bytes)
envsample.prg compares saved data against sampled data

verified: C64C+8580,C64+6581


envsustain.prg:
---------------

measures envelope sustain values

verified: C64C+8580,C64+6581 -  output:

ff
ee
dd
cc
bb
aa
99
88
77
66
55
44
33
22
11
00


envtime.prg:
------------

measures time for a complete envelope (A=D=R=1111)

verified: C64C+8580,C64+6581 -  output:

7e60

================================================================================
Oscillator
================================================================================

oscsample0-dump.prg:
oscsample0-6581.prg:
oscsample0-8580.prg:
oscsample1-dump.prg:
oscsample1-6581.prg:
oscsample1-8580.prg:
--------------------

oscsample0-dump.prg/oscsample1-dump.prg samples OSC3 for all waveforms, 
saves result to disk (8 times 17 blocks, $1000 bytes)

Note: after dumping, confirm that the rebuild test passes on the same machine -
      apparently sometimes the noise waveform dump doesnt come out correctly.

oscsample0-6581.prg/oscsample1-6581.prg/oscsample0-8580.prg/oscsample1-8580.prg
compares sampled data with included reference

Note: only the regular "pure" waveforms have to match for the test to pass
      overall. the mixed waveforms contain random bits due to how they are
      combined in the SID, which makes them fail randomly too.

verified: C64C+8580,C64+6581

================================================================================
Noise LFSR
================================================================================

noisetest.prg:
--------------

checks the noise LFSR

verified: C64C+8580,C64+6581

================================================================================
Filter
================================================================================

The Filters can not be observed via software, so these programs can be used
for external measurements

extfilt.prg:
------------

enables ext-in and routes it through the filter. press 0-9 for different filter
cutoff.

sweep-kern.prg:
---------------

outputs a frequency sweep on voice 3

press 1-4 for different envelopes + filter settings, return to restart test

sweep-orig.prg:
---------------

outputs a frequency sweep on voice 3

press 1-8 for different envelopes + filter settings, return to restart test

sweep.prg:
----------

outputs a frequency sweep on voice 1-3

press 1-8 for different envelopes + filter settings, return to restart test

voice.prg:
----------
 
enables voice 1-3 and routes them through the filter, press 1-8 for different
sustain levels.

screen turns black while test is running, press return to start new test.

================================================================================
Misc
================================================================================

chipmodel.prg:
--------------

detects SID model.
