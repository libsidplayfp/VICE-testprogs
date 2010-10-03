Readme for cia-int
------------------

Running on Breadbox ca 1983-84, regular 6526:

CIA-INT R03 / TLR

DC0C: A9 XX 60
--BBBb------------------
AACC--IIIIKK------------

DC0C: A5 XX 60
--BBBb------------------
AADDD-JJJJJLL-----------

DC0B: 0D A9 XX 60
--BBBBb-----------------
AAEEEE-KKKKKMM----------

DC0B: 19 FF XX 60
--BBBBb-----------------
AA-----LLLLLLNN---------

DC0C: AC XX A9 09 28 60
--BBBb------------------
AA----HHHMMMMMOO--------



-----------------------------------------------------------------------
It works like this:
- start timer
- jsr $dc0b or $dc0c depending on test.
- show contents of $dc0d at the time of ack and if an IRQ occured.

The test is done for timer values of 0-23 (timer B used).
The top line of each test shows the contents of $dc0d.
(B=$82, b=$02, -=$00)
The bottom line shows the number of cycles since starting the test until an IRQ occured. (- means no IRQ)

Test 1:  Ack in second cycle of 2 cycle imm instr.
DC0C A9 XX    LDA #$xx
DC0E 60       RTS

Test 2:  Ack in second cycle of 3 cycle zp instr.
DC0C A5 XX    LDA $xx
DC0E 60       RTS

Test 3:  Ack in third cycle of 4 cycle abs instr.
DC0B 0D A9 XX ORA $xxA9  <-- memory prefilled to do ORA #$xx (mostly)
DC0E 60       RTS

Test 4:  Ack in third cycle of 5 cycle abs instr. (force page crossing)
DC0B 19 FF XX ORA $xxFF,Y <-- memory prefilled to do ORA #$xx (mostly)
DC0E 60       RTS

Test 5:  Ack in second cycle of 4 cycle instr.
DC0C AC XX A9 LDY $A9xx  <-- memory prefilled to do LDY #$xx
DC0F 08       PHP  <-- this can also be ORA #$28 if the timer hasn't expired yet.
DC10 28       PLP
DC11 60       RTS

-----------------------------------------------------------------------
eof

