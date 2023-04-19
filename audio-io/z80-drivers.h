extern unsigned char test_os(void) __z88dk_fastcall;

extern void set_sid_addr_asm(unsigned short addr) __z88dk_fastcall;

extern void set_digimax_addr_asm(unsigned short addr) __z88dk_fastcall;

extern void userport_4bit_input_init(void) __z88dk_fastcall;

extern void userport_2bit_4bit_input_init(void) __z88dk_fastcall;

extern void userport_2bit_4bit_cga1_input_init(void) __z88dk_fastcall;

extern void userport_2bit_4bit_cga2_input_init(void) __z88dk_fastcall;

extern void userport_2bit_4bit_ks1_sb2_input_init(void) __z88dk_fastcall;

extern void userport_2bit_4bit_syn1_input_init(void) __z88dk_fastcall;
extern void userport_2bit_4bit_syn2_input_init(void) __z88dk_fastcall;
extern void userport_2bit_4bit_syn3_input_init(void) __z88dk_fastcall;

extern void sid_output_init(void) __z88dk_fastcall;

extern void sfx_expander_output_init(void) __z88dk_fastcall;

extern void userport_digimax_output_init(void) __z88dk_fastcall;

extern void userport_dac_output_init(void) __z88dk_fastcall;

extern void set_input_function(unsigned char input_type)  __z88dk_fastcall;

extern void set_output_function(unsigned char input_type)  __z88dk_fastcall;

extern void stream(void)  __z88dk_fastcall;

extern void disable_irq(void)  __z88dk_fastcall;
