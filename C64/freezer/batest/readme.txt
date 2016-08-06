freezer stability test originally posted by mr.wegi in the polish c64power forum
http://c64power.com/forumng/index.php?topic=7315.msg97060

the program fills one page with the same byte ($80) and then creates some unrolled
code to shift around the bits. it then repeatedly calls that code and also checks
if after each iteration all bytes are still the same.

to check your freezer, run the program and repeatedly freeze/restart - the program
should always show a stable green border and all values copied to first page of
the screen should be the same also. you can interrupt the program by pressing space
and check the test area at $8000 manually.

results:

Action Replay 6 PAL: fails after couple of freeze/restart
Retro Replay PAL: seems stable
chameleon (menu freezer): seems stable
chameleon (emulated retro replay): seems stable
