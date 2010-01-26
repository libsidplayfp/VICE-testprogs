TESTNUM = 6
B_MODE = 1
TEST_MODE = 1

!src "irqdma.asm"

!if TEST_MODE = 1 {
* = $2000
!bin "irq6b.dump",,2
}
