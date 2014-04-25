
; dummy-true-23 - deliver "OK (23/42)" (internal test for the framework)
; Returns: $23/42 (always)
; by Wolfram Sang (Ninja/The Dreams) - Public Domain
		
		#include "1541-tests.inc"
		
		* = $0300

		.start_test
		lda #$23
		sta test_result
		lda #$42
		sta test_errcode
		.end_test
; dummy! dreamass needs an extra line if the final line is a macro :(
