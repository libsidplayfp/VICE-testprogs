TESTNUM = 3
B_MODE = 1
TEST_MODE = 1

!src "irqdma.asm"

!if TEST_MODE = 1 {
* = $2000
!bin "irq3b-newcia.dump",,2
}
