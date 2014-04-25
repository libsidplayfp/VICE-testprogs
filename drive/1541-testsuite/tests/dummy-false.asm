
; dummy-false - deliver "FAILED (FE/03)" (internal test for the framework)
; Returns: $FE/03 (always)
; by Wolfram Sang (Ninja/The Dreams) - Public Domain
		
		#include "1541-tests.inc"
		
		* = $0300

		.start_test
		lda #$fe
		sta test_result
		lda #$03
		sta test_errcode
		.end_test
; dummy! dreamass needs an extra line if the final line is a macro :(
