wtl_spawn    = $B000   ; spawn a process
wtl_suicide  = $B003   ; commit suicide
wtl_conbint  = $B006   ; connect to interrupts from bank switched routine
wtl_banksw   = $B009   ; perform a bank switched call
wtl_bankinit = $B00C   ; initialize for bank switching
wtl_stoi     = $B00F   ; convert string to integer
wtl_itos     = $B012   ; convert integer to string
wtl_itohs    = $B015   ; integer to hex conversion
wtl_hex      = $B018   ; convert character to hex byte
wtl_btohs    = $B01B   ; binary to hex string conversion
wtl_hstob    = $B01E   ; hex string to binary conversion
wtl_isalpha  = $B021   ; check for alphabetic character
wtl_isdigit  = $B024   ; check for numeric character
wtl_isdelim  = $B027   ; check for delimiter character
wtl_ishex    = $B02A   ; check for hex digit
wtl_isupper  = $B02D   ; check for upper case
wtl_islower  = $B030   ; check for lower case
wtl_upper    = $B033   ; map char to upper case
wtl_lower    = $B036   ; map char to lower case
wtl_zlostr   = $B039   ; map string to lower case
wtl_zupstr   = $B03C   ; map string to lower case
wtl_streq    = $B03F   ; compare two strings
wtl_equal    = $B042   ; compare memory
wtl_length   = $B045   ; get length of a string
wtl_copystr  = $B048   ; copy a string
wtl_copy     = $B04B   ; copy memory
wtl_prefixst = $B04E   ; insert a prefix to a string
wtl_suffixst = $B051   ; add a suffix to a string
wtl_decimal  = $B054   ; convert a decimal string to integer
wtl_tableloo = $B057   ; lookup a string in a table
wtl_RET      = $B05A   ; wsl compiler support routine
wtl_RET2     = $B05D   ; wsl compiler support routine
wtl_MUL      = $B060   ; wsl compiler support routine
wtl_NEG      = $B063   ; wsl compiler support routine
wtl_DIV      = $B066   ; wsl compiler support routine
wtl_MOD      = $B069   ; wsl compiler support routine
wtl_RSHIFT   = $B06C   ; wsl compiler support routine
wtl_LSHIFT   = $B06F   ; wsl compiler support routine
wtl_CARRYSET = $B072   ; check carry set
wtl_passthru = $B075   ; passthru mode to the host
wtl_tioinit  = $B078   ; initialize local terminal
wtl_tputchr  = $B07B   ; put a character to local terminal
wtl_tgetchr  = $B07E   ; get a character from local terminal
wtl_tbreak   = $B081   ; check for break on terminal
wtl_tgetcurs = $B084   ; get the cursor position on screen
wtl_tputcurs = $B087   ; set the cursor position on the screen
wtl_tsetchar = $B08A   ; set the terminal characteristics
wtl_tabset   = $B08D   ; set tab stops
wtl_tabget   = $B090   ; get current tab stops
wtl_sioinit  = $B093   ; initialize serial io port
wtl_sputchr  = $B096   ; put char to serial port
wtl_sgetchr  = $B099   ; get char from serial port
wtl_sbreak   = $B09C   ; check break on serial port
wtl_diropenf = $B09F   ; open a directory
wtl_dirreadf = $B0A2   ; read a directory
wtl_dirclose = $B0A5   ; close a directory
wtl_sysioIni = $B0A8   ; system dependent initialize for io
wtl_initstd  = $B0AB   ; initialize standard io
wtl_openf    = $B0AE   ; open a file
wtl_closef   = $B0B1   ; close a file
wtl_fseek    = $B0B4   ; seek to record
wtl_printf   = $B0B7   ; formatted print to standard output
wtl_putrec   = $B0BA   ; put record to standard output
wtl_putchar  = $B0BD   ; put character to standard output
wtl_putnl    = $B0C0   ; put newline to standard output
wtl_getrec   = $B0C3   ; get record from standard input
wtl_getchar  = $B0C6   ; get character from standard input
wtl_fprintf  = $B0C9   ; formatted print to a file
wtl_fputrec  = $B0CC   ; put record to a file
wtl_fputchar = $B0CF   ; put character to a file
wtl_fputnl   = $B0D2   ; put newline to a file
wtl_fgetrec  = $B0D5   ; get record from a file
wtl_fgetchar = $B0D8   ; get character from a file
wtl_eor      = $B0DB   ; end of record status of a file
wtl_eof      = $B0DE   ; end of file status of a file
wtl_errorf   = $B0E1   ; error status of a file
wtl_errormsg = $B0E4   ; error message of a file
wtl_mount    = $B0E7   ; mount new file system
wtl_scratchf = $B0EA   ; scratch a file
wtl_renamef  = $B0ED   ; rename a file
wtl_request  = $B0F0   ; request specified process function
wtl_setdate  = $B0F3   ; set the date
wtl_getdate  = $B0F6   ; get the date
wtl_settime  = $B0F9   ; set the time
wtl_gettime  = $B0FC   ; get the time
wtl_kbenable = $B0FF   ; enable the keyboard
wtl_kbdisabl = $B102   ; disable the keyboard
wtl_timeout  = $B105   ; set device time-out interval
wtl_sysread  = $B108   ; system dependent read
wtl_syswrite = $B10B   ; system dependent write
wtl_sysnl    = $B10E   ; system dependent newline
wtl_intpow10 = $B11a   ; integer powers of 10
wtl_devlist  = $B124   ; device name list


	ORG $0FFA

	.DW start
	.DW end-start
	.DW 0

start:

main:
	; put the stack at $0fff and use it instead of the default 40 byte stack
	lds #$0fff
	jsr wtl_initstd
	jsr main_input_menu
	jsr main_output_menu
	jmp stream

main_input_menu:
	jsr cls
	ldx #choose_input_main_menu_text
	jsr print_string

main_input_menu_choose:
	jsr wtl_getchar
	cmpb #'s'
	beq setup_software_input_jmp
	cmpb #'h'
	beq hardware_input_menu
	bra main_input_menu_choose

setup_software_input_jmp:
	jmp setup_software_input

hardware_input_menu:
	jsr cls
	ldx #choose_input_hardware_menu_text
	jsr print_string

hardware_input_menu_choose:
	jsr wtl_getchar
	cmpb #'d'
	beq userport_hummer_input_menu
	cmpb #'o'
	beq userport_oem_input_menu
	cmpb #'t'
	beq userport_spt_input_menu
	cmpb #'y'
	beq userport_syn_input_menu_jmp
	cmpb #'p'
	beq userport_pet_input_menu
	cmpb #'c'
	beq userport_cga_input_menu_jmp
	bra hardware_input_menu_choose

userport_syn_input_menu_jmp:
	jmp userport_syn_input_menu

userport_cga_input_menu_jmp:
	jmp userport_cga_input_menu

userport_hummer_input_menu:
	jsr cls
	ldx #choose_input_samplers_menu_text
	jsr print_string

userport_hummer_input_menu_choose:
	jsr wtl_getchar
	cmpb #'4'
	beq setup_userport_hummer_4bit_input_jmp
	cmpb #'2'
	beq setup_userport_hummer_2bit_input_jmp
	bra userport_hummer_input_menu_choose

setup_userport_hummer_4bit_input_jmp
	jmp setup_userport_hummer_4bit_input

setup_userport_hummer_2bit_input_jmp:
	jmp setup_userport_hummer_2bit_input

userport_oem_input_menu:
	jsr cls
	ldx #choose_input_samplers_menu_text
	jsr print_string

userport_oem_input_menu_choose:
	jsr wtl_getchar
	cmpb #'4'
	beq setup_userport_oem_4bit_input_jmp
	cmpb #'2'
	beq setup_userport_oem_2bit_input_jmp
	bra userport_oem_input_menu_choose

setup_userport_oem_4bit_input_jmp:
	jmp setup_userport_oem_4bit_input

setup_userport_oem_2bit_input_jmp:
	jmp setup_userport_oem_2bit_input

userport_spt_input_menu:
	jsr cls
	ldx #choose_input_samplers_menu_text
	jsr print_string

userport_spt_input_menu_choose:
	jsr wtl_getchar
	cmpb #'4'
	beq setup_userport_spt_4bit_input_jmp
	cmpb #'2'
	beq setup_userport_spt_2bit_input_jmp
	bra userport_spt_input_menu_choose

setup_userport_spt_4bit_input_jmp:
	jmp setup_userport_spt_4bit_input

setup_userport_spt_2bit_input_jmp:
	jmp setup_userport_spt_2bit_input

userport_pet_input_menu:
	jsr cls
	ldx #choose_input_ports_menu_text
	jsr print_string

userport_pet_input_menu_choose:
	jsr wtl_getchar
	cmpb #'1'
	beq userport_pet1_input_menu
	cmpb #'2'
	beq userport_pet2_input_menu
	bra userport_pet_input_menu_choose

userport_pet1_input_menu:
	jsr cls
	ldx #choose_input_samplers_menu_text
	jsr print_string

userport_pet1_input_menu_choose:
	jsr wtl_getchar
	cmpb #'4'
	beq setup_userport_pet1_4bit_input_jmp
	cmpb #'2'
	beq setup_userport_pet1_2bit_input_jmp
	bra userport_pet1_input_menu_choose

setup_userport_pet1_4bit_input_jmp:
	jmp setup_userport_pet1_4bit_input

setup_userport_pet1_2bit_input_jmp:
	jmp setup_userport_pet1_2bit_input

userport_pet2_input_menu:
	jsr cls
	ldx #choose_input_samplers_menu_text
	jsr print_string

userport_pet2_input_menu_choose:
	jsr wtl_getchar
	cmpb #'4'
	beq setup_userport_pet2_4bit_input_jmp
	cmpb #'2'
	beq setup_userport_pet2_2bit_input_jmp
	bra userport_pet2_input_menu_choose

setup_userport_pet2_4bit_input_jmp:
	jmp setup_userport_pet2_4bit_input

setup_userport_pet2_2bit_input_jmp:
	jmp setup_userport_pet2_2bit_input

userport_syn_input_menu:
	jsr cls
	ldx #choose_input_ports_3_menu_text
	jsr print_string

userport_syn_input_menu_choose:
	jsr wtl_getchar
	cmpb #'1'
	beq userport_syn1_input_menu
	cmpb #'2'
	beq userport_syn2_input_menu
	cmpb #'3'
	beq userport_syn3_input_menu
	bra userport_syn_input_menu_choose

userport_syn1_input_menu:
	jsr cls
	ldx #choose_input_samplers_menu_text
	jsr print_string

userport_syn1_input_menu_choose:
	jsr wtl_getchar
	cmpb #'4'
	beq setup_userport_syn1_4bit_input_jmp
	cmpb #'2'
	beq setup_userport_syn1_2bit_input_jmp
	bra userport_syn1_input_menu_choose

setup_userport_syn1_4bit_input_jmp:
	jmp setup_userport_syn1_4bit_input

setup_userport_syn1_2bit_input_jmp:
	jmp setup_userport_syn1_2bit_input

userport_syn2_input_menu:
	jsr cls
	ldx #choose_input_samplers_menu_text
	jsr print_string

userport_syn2_input_menu_choose:
	jsr wtl_getchar
	cmpb #'4'
	beq setup_userport_syn2_4bit_input_jmp
	cmpb #'2'
	beq setup_userport_syn2_2bit_input_jmp
	bra userport_syn2_input_menu_choose

setup_userport_syn2_4bit_input_jmp:
	jmp setup_userport_syn2_4bit_input

setup_userport_syn2_2bit_input_jmp:
	jmp setup_userport_syn2_2bit_input

userport_syn3_input_menu:
	jsr cls
	ldx #choose_input_samplers_menu_text
	jsr print_string

userport_syn3_input_menu_choose:
	jsr wtl_getchar
	cmpb #'4'
	beq setup_userport_syn3_4bit_input_jmp
	cmpb #'2'
	beq setup_userport_syn3_2bit_input_jmp
	bra userport_syn2_input_menu_choose

setup_userport_syn3_4bit_input_jmp:
	jmp setup_userport_syn3_4bit_input

setup_userport_syn3_2bit_input_jmp:
	jmp setup_userport_syn3_2bit_input

userport_cga_input_menu:
	jsr cls
	ldx #choose_input_ports_menu_text
	jsr print_string

userport_cga_input_menu_choose:
	jsr wtl_getchar
	cmpb #'1'
	beq userport_cga1_input_menu
	cmpb #'2'
	beq userport_cga2_input_menu
	bra userport_cga_input_menu_choose

userport_cga1_input_menu:
	jsr cls
	ldx #choose_input_samplers_menu_text
	jsr print_string

userport_cga1_input_menu_choose:
	jsr wtl_getchar
	cmpb #'4'
	beq setup_userport_cga1_4bit_input_jmp
	cmpb #'2'
	beq setup_userport_cga1_2bit_input_jmp
	bra userport_cga1_input_menu_choose

setup_userport_cga1_4bit_input_jmp:
	jmp setup_userport_cga1_4bit_input

setup_userport_cga1_2bit_input_jmp:
	jmp setup_userport_cga1_2bit_input

userport_cga2_input_menu:
	jsr cls
	ldx #choose_input_samplers_menu_text
	jsr print_string

userport_cga2_input_menu_choose:
	jsr wtl_getchar
	cmpb #'4'
	beq setup_userport_cga2_4bit_input_jmp
	cmpb #'2'
	beq setup_userport_cga2_2bit_input_jmp
	bra userport_cga2_input_menu_choose

setup_userport_cga2_4bit_input_jmp:
	jmp setup_userport_cga2_4bit_input

setup_userport_cga2_2bit_input_jmp:
	jmp setup_userport_cga2_2bit_input

setup_userport_hummer_2bit_input:
	ldx #userport_h_o_p_input_init
	stx input_init_function
	ldx #userport_h2_p12_c2_input
	stx input_function
	ldx #userport_hummer_2bit_text
	stx input_text
	rts

setup_userport_hummer_4bit_input:
	ldx #userport_h_o_p_input_init
	stx input_init_function
	ldx #userport_h4_p14_c4_input
	stx input_function
	ldx #userport_hummer_4bit_text
	stx input_text
	rts

setup_userport_syn1_2bit_input:
	ldx #userport_syn1_input_init
	stx input_init_function
	ldx #userport_h2_p12_c2_input
	stx input_function
	ldx #userport_syn1_2bit_text
	stx input_text
	rts

setup_userport_syn1_4bit_input:
	ldx #userport_syn1_input_init
	stx input_init_function
	ldx #userport_h4_p14_c4_input
	stx input_function
	ldx #userport_syn1_4bit_text
	stx input_text
	rts

setup_userport_syn2_2bit_input:
	ldx #userport_syn2_input_init
	stx input_init_function
	ldx #userport_h2_p12_c2_input
	stx input_function
	ldx #userport_syn2_2bit_text
	stx input_text
	rts

setup_userport_syn2_4bit_input:
	ldx #userport_syn2_input_init
	stx input_init_function
	ldx #userport_h4_p14_c4_input
	stx input_function
	ldx #userport_syn2_4bit_text
	stx input_text
	rts

setup_userport_syn3_2bit_input:
	ldx #userport_syn3_input_init
	stx input_init_function
	ldx #userport_h2_p12_c2_input
	stx input_function
	ldx #userport_syn3_2bit_text
	stx input_text
	rts

setup_userport_syn3_4bit_input:
	ldx #userport_syn3_input_init
	stx input_init_function
	ldx #userport_h4_p14_c4_input
	stx input_function
	ldx #userport_syn3_4bit_text
	stx input_text
	rts

setup_userport_pet1_2bit_input:
	ldx #userport_h_o_p_input_init
	stx input_init_function
	ldx #userport_h2_p12_c2_input
	stx input_function
	ldx #userport_pet1_2bit_text
	stx input_text
	rts

setup_userport_pet1_4bit_input:
	ldx #userport_h_o_p_input_init
	stx input_init_function
	ldx #userport_h4_p14_c4_input
	stx input_function
	ldx #userport_pet1_4bit_text
	stx input_text
	rts

setup_userport_pet2_2bit_input:
	ldx #userport_h_o_p_input_init
	stx input_init_function
	ldx #userport_pet2_2bit_input
	stx input_function
	ldx #userport_pet2_2bit_text
	stx input_text
	rts

setup_userport_pet2_4bit_input:
	ldx #userport_h_o_p_input_init
	stx input_init_function
	ldx #userport_pet2_4bit_input
	stx input_function
	ldx #userport_pet2_4bit_text
	stx input_text
	rts

setup_userport_cga1_2bit_input:
	ldx #userport_cga1_input_init
	stx input_init_function
	ldx #userport_h2_p12_c2_input
	stx input_function
	ldx #userport_cga1_2bit_text
	stx input_text
	rts

setup_userport_cga1_4bit_input:
	ldx #userport_cga1_input_init
	stx input_init_function
	ldx #userport_h4_p14_c4_input
	stx input_function
	ldx #userport_cga1_4bit_text
	stx input_text
	rts

setup_userport_cga2_2bit_input:
	ldx #userport_cga2_input_init
	stx input_init_function
	ldx #userport_h2_p12_c2_input
	stx input_function
	ldx #userport_cga2_2bit_text
	stx input_text
	rts

setup_userport_cga2_4bit_input:
	ldx #userport_cga2_input_init
	stx input_init_function
	ldx #userport_h4_p14_c4_input
	stx input_function
	ldx #userport_cga2_4bit_text
	stx input_text
	rts

setup_userport_oem_2bit_input:
	ldx #userport_h_o_p_input_init
	stx input_init_function
	ldx #userport_oem_2bit_input
	stx input_function
	ldx #userport_oem_2bit_text
	stx input_text
	rts

setup_userport_oem_4bit_input:
	ldx #userport_h_o_p_input_init
	stx input_init_function
	ldx #userport_oem_4bit_input
	stx input_function
	ldx #userport_oem_4bit_text
	stx input_text
	rts

setup_userport_spt_2bit_input:
	ldx #userport_h_o_p_input_init
	stx input_init_function
	ldx #userport_spt_2bit_input
	stx input_function
	ldx #userport_spt_2bit_text
	stx input_text
	rts

setup_userport_spt_4bit_input:
	ldx #userport_h_o_p_input_init
	stx input_init_function
	ldx #userport_spt_4bit_input
	stx input_function
	ldx #userport_spt_4bit_text
	stx input_text
	rts

main_output_menu:
	jsr cls
	ldx #choose_output_main_menu_text
	jsr print_string

main_output_menu_choose:
	jsr wtl_getchar
	cmpb #'s'
	beq sidcard_output_menu
	cmpb #'8'
	beq setup_userport_dac_output
	bra main_output_menu_choose

sidcard_output_menu:
	jsr cls
	ldx #choose_output_sidcard_menu_text
	jsr print_string

sidcard_output_menu_choose:
	jsr wtl_getchar
	cmpb #'8'
	beq setup_sidcard_8f00_output
	cmpb #'e'
	beq setup_sidcard_e900_output
	jmp sidcard_output_menu_choose

setup_software_input:
	ldx #software_input
	stx input_function
	ldx #software_text
	stx input_text
	rts

setup_userport_dac_output:
	ldx #userport_dac_output_init
	stx output_init_function
	ldx #userport_dac_output
	stx output_function
	ldx #userport_dac_text
	stx output_text
	rts

setup_sidcard_8f00_output:
	ldx #$8f00
	stx sid_address
	ldx #sidcart_8f00_text
	stx output_text
setup_sidcard_output:
	ldx #sidcard_output_init
	stx output_init_function
	ldx #sidcard_output
	stx output_function
	rts

setup_sidcard_e900_output:
	ldx #$e900
	stx sid_address
	ldx #sidcart_e900_text
	stx output_text
	jmp setup_sidcard_output

userport_h_o_p_input_init:
	lda #$00
	sta $e843
	rts

userport_cga1_input_init:
	ldb #$80
	stb $e843
storex_e841:
	stb $e841
	rts

userport_cga2_input_init:
	ldb #$80
	stb $e843
	ldb #$00
	jmp storex_e841

userport_syn1_input_init:
	ldb #$E0
	stb $e843
	ldb #$C0
	jmp storex_e841

userport_syn2_input_init:
	ldb #$E0
	stb $e843
	ldb #$A0
	jmp storex_e841

userport_syn3_input_init:
	ldb #$E0
	stb $e843
	ldb #$60
	jmp storex_e841

; sample return in B
userport_h2_p12_c2_input:
	ldb $e841
	aslb
	aslb
do_asl4:
	aslb
	aslb
	aslb
	aslb
	rts

; sample return in B
userport_h4_p14_c4_input:
	ldb $e841
	jmp do_asl4

; sample return in B
userport_oem_2bit_input:
	ldb $e841
	stb $87f2
	andb #$40
	aslb
	stb $87f1
	ldb $87f2
	andb #$80
	lsrb
	orb $87f1
	rts

; sample return in B
userport_oem_4bit_input:
	ldb $e841
	stb $87f2
	andb #$10
	aslb
	aslb
	aslb
	stb $87f1
	ldb $87f2
	andb #$20
	aslb
	orb $87f1
	stb $87f1
	ldb $87f2
	andb #$40
	lsrb
	orb $87f1
	stb $87f1
	ldb $87f2
	andb #$80
	lsrb
	lsrb
	lsrb
	orb $87f1
	rts

; sample return in B
userport_spt_2bit_input:
	ldb $e841
	andb #$0c
	jmp do_asl4

; sample return in B
userport_spt_4bit_input:
	ldb $e841
	stb $87f1
	andb #$0c
	lsrb
	lsrb
	stb $87f2
	ldb $87f1
	andb #$03
	aslb
	aslb
	orb $87f2
	jmp do_asl4

; sample return in B
userport_pet2_2bit_input:
	ldb $e841
	andb #$30
	aslb
	aslb
	rts

; sample return in B
userport_pet2_4bit_input:
	ldb $e841
	andb #$f0
	rts

; base address in X, offset in A, sample in B
store_sid:
	stb a,x
	rts

; sidcard output init
sidcard_output_init:
	ldx sid_address
	lda #$00
	ldb #$00
sidcard_init_loop:
	jsr store_sid
	inca
	cmpa #$20
	bne sidcard_init_loop
	ldb #$ff
	lda #$06
	jsr store_sid
	lda #$0d
	jsr store_sid
	lda #$14
	jsr store_sid
	ldb #$49
	lda #$04
	jsr store_sid
	lda #$0b
	jsr store_sid
	lda #$12
	jmp store_sid

sidcard_output:
	ldx sid_address
	lsrb
	lsrb
	lsrb
	lsrb
	lda #$18
	jmp store_sid

; software input, sample return in B
software_input:
	ldb $87f0
	incb
	stb $87f0
	rts

; userport dac output init
userport_dac_output_init:
	ldb #$ff
	stb $e843
	rts

; userport dac output, sample in B
userport_dac_output:
	stb $e841
	rts

; show the sample on screen, sample in B
show_sample:
	stb $8020
	rts

; stream
stream:
	jsr cls
	ldx #streaming_text
	jsr print_string
	ldx #from_text
	jsr print_string
	ldx input_text
	jsr print_string
	ldx #to_text
	jsr print_string
	ldx output_text
	jsr print_string
	ldx #input_init_function
	ldb [,x]
	cmpb #0
	beq exec_output_init_function
	jsr [,x]
exec_output_init_function:
	ldx #output_init_function
	ldb [,x]
	cmpb #0
	beq stream_loop
	jsr [,x]
stream_loop:
	ldx #input_function
	jsr [,x]
	jsr show_sample
	ldx #output_function
	jsr [,x]
	bra stream_loop

; clear the screen
cls:
	ldx #$8000
	lda #$20
clsloop:
	sta ,x+
	cmpx #$87ef
	bne clsloop
	ldd #$0101
	jmp wtl_tputcurs

; print a '0' terminated string, address of the string in reg X
print_string:
	ldb ,x+
	cmpb #$00
	beq end_print_string
	pshs x
	jsr wtl_putchar
	puls x
	bra print_string
end_print_string:
	rts

input_text:
	.DW 0

input_init_function:
	.DW 0

input_function:
	.DW 0

output_text:
	.DW 0

output_init_function:
	.DW 0

output_function:
	.DW 0

sid_address:
	.DW 0

choose_input_main_menu_text:
	fcc "Choose input"
	fcb $0d
	fcb $0d
	fcc "s: software generated waveform"
	fcb $0d
	fcc "h: hardware device"
	fcb $0d
	fcb $00

choose_input_hardware_menu_text:
	fcc "Choose input"
	fcb $0d
	fcb $0d
	fcc "d: C64DTV HUMMER userport joystick adapter"
	fcb $0d
	fcc "o: OEM userport joystick adapter"
	fcb $0d
	fcc "t: SPT userport joystick adapter"
	fcb $0d
	fcc "p: PET userport joystick adapter"
	fcb $0d
	fcc "c: CGA userport joystick adapter"
	fcb $0d
	fcc "y: Synergy userport joystick adapter"
	fcb $0d
	fcb $00

choose_input_samplers_menu_text:
	fcc "Choose input"
	fcb $0d
	fcb $0d
	fcc "2: 2 bit sampler"
	fcb $0d
	fcc "4: 4 bit sampler"
	fcb $0d
	fcb $00

choose_input_ports_menu_text:
	fcc "Choose input"
	fcb $0d
	fcb $0d
	fcc "1: port 1"
	fcb $0d
	fcc "2: port 2"
	fcb $0d
	fcb $00

choose_input_ports_3_menu_text:
	fcc "Choose input"
	fcb $0d
	fcb $0d
	fcc "1: port 1"
	fcb $0d
	fcc "2: port 2"
	fcb $0d
	fcc "3: port 3"
	fcb $0d
	fcb $00

choose_output_main_menu_text:
	fcc "Choose output"
	fcb $0d
	fcb $0d
	fcc "s: SIDcart"
	fcb $0d
	fcc "8: userport dac"
	fcb $0d
	fcb $00

choose_output_sidcard_menu_text:
	fcc "Choose SIDcart address"
	fcb $0d
	fcb $0d
	fcc "8: $8F00"
	fcb $0d
	fcc "e: $E900"
	fcb $0d
	fcb $00

streaming_text:
	fcc "Streaming"
	fcb $0d
	fcb $0d
	fcb $00

from_text:
	fcc "from"
	fcb $0d
	fcb $00

userport_hummer_2bit_text:
	fcc "2 bit sampler on userport HUMMER joy adapter"
	fcb $0d
	fcb $00

userport_hummer_4bit_text:
	fcc "4 bit sampler on userport HUMMER joy adapter"
	fcb $0d
	fcb $00

userport_pet1_2bit_text:
	fcc "2 bit sampler on port 1 of userport PET joy adapter"
	fcb $0d
	fcb $00

userport_pet1_4bit_text:
	fcc "4 bit sampler on port 1 of userport PET joy adapter"
	fcb $0d
	fcb $00

userport_pet2_2bit_text:
	fcc "2 bit sampler on port 2 of userport PET joy adapter"
	fcb $0d
	fcb $00

userport_pet2_4bit_text:
	fcc "4 bit sampler on port 2 of userport PET joy adapter"
	fcb $0d
	fcb $00

userport_cga1_2bit_text:
	fcc "2 bit sampler on port 1 of userport CGA joy adapter"
	fcb $0d
	fcb $00

userport_cga1_4bit_text:
	fcc "4 bit sampler on port 1 of userport CGA joy adapter"
	fcb $0d
	fcb $00

userport_cga2_2bit_text:
	fcc "2 bit sampler on port 2 of userport CGA joy adapter"
	fcb $0d
	fcb $00

userport_cga2_4bit_text:
	fcc "4 bit sampler on port 2 of userport CGA joy adapter"
	fcb $0d
	fcb $00

userport_oem_2bit_text:
	fcc "2 bit sampler on userport OEM joy adapter"
	fcb $0d
	fcb $00

userport_oem_4bit_text:
	fcc "4 bit sampler on userport OEM joy adapter"
	fcb $0d
	fcb $00

userport_spt_2bit_text:
	fcc "2 bit sampler on userport SPT joy adapter"
	fcb $0d
	fcb $00

userport_spt_4bit_text:
	fcc "4 bit sampler on userport SPT joy adapter"
	fcb $0d
	fcb $00

userport_syn1_2bit_text:
	fcc "2 bit sampler on port 1 of userport Synergy joy adapter"
	fcb $0d
	fcb $00

userport_syn1_4bit_text:
	fcc "4 bit sampler on port 1 of userport Synergy joy adapter"
	fcb $0d
	fcb $00

userport_syn2_2bit_text:
	fcc "2 bit sampler on port 2 of userport Synergy joy adapter"
	fcb $0d
	fcb $00

userport_syn2_4bit_text:
	fcc "4 bit sampler on port 2 of userport Synergy joy adapter"
	fcb $0d
	fcb $00

userport_syn3_2bit_text:
	fcc "2 bit sampler on port 3 of userport Synergy joy adapter"
	fcb $0d
	fcb $00

userport_syn3_4bit_text:
	fcc "4 bit sampler on port 3 of userport Synergy joy adapter"
	fcb $0d
	fcb $00

to_text:
	fcb $0d
	fcc "to"
	fcb $0d
	fcb $00

software_text:
	fcc "software generated waveform"
	fcb $0d
	fcb $00

userport_dac_text:
	fcc "userport DAC"
	fcb $0d
	fcb $00

sidcart_8f00_text:
	fcc "SIDcart at $8F00"
	fcb $0d
	fcb $00

sidcart_e900_text:
	fcc "SIDcart at $E900"
	fcb $0d
	fcb $00

end:

	.DW 0
	.DW 0
	.DW $0200
