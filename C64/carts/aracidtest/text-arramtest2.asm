Test5:
		.db 5,147
		.pet "Test 5: Extended AR RAM Write Test -No.",13,13
		.pet "data -> $8000 C64 RAM",13
		.pet "data -> $8000 AR RAM using:",13
		.db 0

Note5a:		.pet 13,13,13,"Note: This ",$96,"FAILS completely",5," on most",13
		.pet "      modern soft/hardware emulations.",13,13
		.pet "      Original 80s hardware will report ",$1e
		.pet "      OK",5," for both AR RAM tests. ",$96,"FAIL",5, " for"
		.pet "      C64 RAM is correct. The data IS",13
		.pet "      written to both RAMs! As this mode"
		.pet "      is used by some tools they do",13
		.pet "      fail on some emus and clones.",13
		.db 0

Note5b:		.pet 13,13,13,"Note: This ",$96,"has to FAIL completely",5," on",13
		.pet "      any architecture. That is correct!"
		.db 0


Note5c:		.pet 13,13,13,$1e,"Note: ",5,"This has to show ",$1e,"OK",5," on all tests."
		.db 0
