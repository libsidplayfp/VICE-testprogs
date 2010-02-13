TESTNUM = 6
B_MODE = 1
TEST_MODE = 1

!src "nmidma.asm"

!if TEST_MODE = 1 {
* = $2000
!bin "nmi6b.dump",,2
}
