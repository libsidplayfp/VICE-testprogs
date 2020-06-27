Space:		
		.pet 13,13,"                                  SPACE"
		.db 0
Spacer:		
		.pet 13,13,"        SPACE - next, R/S - re-run test"
		.db 0
Testval:
		.pet $1e,"#$"
		.db 0
Testval2:
		.pet 5," -> $de00",13,13
		.db 0
t_vrfyc64ram:		
		.pet "vrfy -- C64 RAM: "
		.db 0
t_vrfyarram:		.pet "vrfy -- AR RAM : "
		.db 0
t_vrfyarioram:		.pet "vrfy -- AR IO RAM : "
		.db 0
Note3:
		.pet 13,13,13,5,"Note: ",$96,"FAIL",5," on the AR RAM read test",13
		.pet "      is correct in this mode.",13
		.pet "      C64 and AR IO RAM ",$1e,"have to PASS",5,"!",13
		.db 0
 
