
; dummy-true0 - deliver "OK" (internal test for the framework)
; Returns: $00/00 (always)
; by Wolfram Sang (Ninja/The Dreams) - Public Domain
		
		#include "1541-tests.inc"
		
		* = $0300

		.start_test
		lda #0
		sta test_result
		sta test_errcode
		.end_test
; dummy! dreamass needs an extra line if the final line is a macro :(
