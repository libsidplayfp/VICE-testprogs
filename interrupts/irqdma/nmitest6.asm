TESTNUM = 6
B_MODE = 0
TEST_MODE = 1

!src "nmidma.asm"

!if TEST_MODE = 1 {
* = $2000
!bin "nmi6.dump",,2
}
