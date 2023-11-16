
referring to http://forum.6502.org/viewtopic.php?f=1&t=7640

"JSR has two operand bytes, and it has to do two stack pushes, and in a real
6502 the sequence is that the first operand byte is read, then the two stack
pushes happen, and then the second operand byte is read. So the test is to
arrange that the second operand byte is overwritten by the stack. Truly self-
modifying code."
