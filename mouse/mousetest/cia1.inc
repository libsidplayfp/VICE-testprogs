;ACME 0.96.4

!ifdef lib_cbm_c64_cia1_a !eof
lib_cbm_c64_cia1_a = 1

!source "cia.inc"	; chip stuff (same for both cias)
; stuff for cia 1 only:
!addr	cia1_base	= $dc00
	cia1_pra	= cia1_base + cia_port_a	; PA0..PA4 are joy port 2	PA6+PA7 select paddle port(s)
	cia1_prb	= cia1_base + cia_port_b	; PB0..PB4 are joy port 1
	; both ports are used for keyboard matrix
	cia1_ddra	= cia1_base + cia_data_direction_a
	cia1_ddrb	= cia1_base + cia_data_direction_b
	cia1_ta_lo	= cia1_base + cia_timer_a_low
	cia1_ta_hi	= cia1_base + cia_timer_a_high
	cia1_tb_lo	= cia1_base + cia_timer_b_low
	cia1_tb_hi	= cia1_base + cia_timer_b_high
	cia1_tod10ths	= cia1_base + cia_timeofday_10ths
	cia1_todsec	= cia1_base + cia_timeofday_seconds
	cia1_todmin	= cia1_base + cia_timeofday_minutes
	cia1_todhr	= cia1_base + cia_timeofday_hours
	cia1_sdr	= cia1_base + cia_serial_data
	cia1_icr	= cia1_base + cia_interrupt_control
	cia1_cra	= cia1_base + cia_control_a
	cia1_crb	= cia1_base + cia_control_b
; the interrupt output is connected to CPU's /IRQ input
; in the C128, the shift register is used for the fast serial port (burst mode)
