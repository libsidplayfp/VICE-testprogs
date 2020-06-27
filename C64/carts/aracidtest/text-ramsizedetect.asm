Test2:
		.db 5,147
		.pet "Test 2: Basic AR RAM Size Detection",13,13
		.pet "data -> $8000 C64 RAM",13
		.pet "#$x3 -> $de00 walk through all banks",13
		.pet "chck -- Extended RAM kb found: ",$1e

		.db 0

Note2:
		.pet 13,13,13,5,"Note:  8kb - original AR/NP HW, VICE-AR",13
		.pet "      32kb - RR, 1541u, VICE-RR",13
		.pet "      64kb - EF2, VICE(dev), clones",13,13
		.pet "All >8kb banks should behave the same",13
		.pet "way and will not be tested for any",13
		.pet "further. Tbh - it's not worth the hazzle"
		.pet "and unlikely that an RR with $DE01 bit 1"
		.pet "(AllowBank) activated is around.",13
		.pet "RAM access through IO is a different",13
		.pet "story :)",13,13
		.pet "8kb carts will be checked with IO2 from",13
		.pet "here - larger carts using IO1 accesses."
		.db 0
