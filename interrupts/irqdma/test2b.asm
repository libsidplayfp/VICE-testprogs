TESTNUM = 2
B_MODE = 1
TEST_MODE = 1

!src "irqdma.asm"

!if TEST_MODE = 1 {
* = $2000
!bin "irq2b.dump",,2
}
