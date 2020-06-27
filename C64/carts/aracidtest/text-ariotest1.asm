Test3:
		.db 5,147
		.pet "Test 3: AR RAM IO Write Access -Run No.",13,13

#ifdef DEBUG
		.pet 13,13,13,13,13,13
#endif		
Test3a:
		.pet "data -> $9x00 C64 RAM",13

Test3c:
		.pet "data -> $Dx00 IO1/IO2 AR RAM using:",13
		.db 0



