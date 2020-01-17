
This test can be used to check if the JAM opcode(s) actually do what they are
supposed to do (halt the CPU).

jamirq.prg:
jamnmi.prg:

set up a timer irq which triggers after cpu has run into a JAM. that should
have no effect, the only way to recover from a JAM is reset.
