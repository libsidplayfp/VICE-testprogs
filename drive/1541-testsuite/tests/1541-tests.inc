
test_result	= $14
test_errcode	= $15

#macro start_test {
}

#macro end_test {
	#ifdef VHDL_SIMULATION
		brk
	#else
		rts
	#endif
}
