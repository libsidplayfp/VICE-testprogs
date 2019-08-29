################################################################################
This directory contains the original reSID test programs written by Dag Lem
################################################################################

================================================================================
Envelope
================================================================================

boundary.prg:
-------------

envelope test (decay), saves result to disk (97 blocks)

TODO: include reference data

envboundary.prg:
----------------

BUGBUG: hangs in endless loop

TODO: fix(?)

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
--------------

envelope test (decay), saves result to disk (4 times 97 blocks)

TODO: include reference data

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

oscsample.prg:
--------------

samples OSC3 for all waveforms, saves result to disk (8 times 17 blocks)

TODO: include reference data

test.prg:
---------

samples OSC3 for all waveforms, saves result to disk (8 times 17 blocks)

TODO: include reference data

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

detect SID model.

chipmodel-testbit.prg:
----------------------

detect SID model.

BUGBUG: shows 6581 on 8580 too!

