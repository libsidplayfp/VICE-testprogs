TESTNUM = 6
B_MODE = 0
TEST_MODE = 1

!src "irqdma.asm"

!if TEST_MODE = 1 {
* = $2000
!bin "irq6-newcia.dump",,2
}
