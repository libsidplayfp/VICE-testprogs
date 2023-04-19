#ifndef VICE_AUDIO_IO_H
#define VICE_AUDIO_IO_H

/* stream.s */
void __fastcall__ set_input_jsr(unsigned char __fastcall__ (*function)(void));
void __fastcall__ set_output_jsr(void __fastcall__ (*function)(unsigned char sample));
void __fastcall__ stream(void);
unsigned char __fastcall__ software_input(void);

/* c64-drivers.s / vic20-drivers.s */
unsigned char __fastcall__ sfx_input(void);
void __fastcall__ sfx_output(unsigned char sample);
void __fastcall__ set_digimax_addr(unsigned addr);
void __fastcall__ digimax_cart_output(unsigned char sample);
void __fastcall__ shortbus_digimax_output(unsigned char sample);
void __fastcall__ sfx_sound_expander_output_init(void);
void __fastcall__ sfx_sound_expander_output(unsigned char sample);

/* plus4-drivers.s */
unsigned char __fastcall__ digiblaster_fd5x_input(void);
unsigned char __fastcall__ digiblaster_fe9x_input(void);
void __fastcall__ digiblaster_fd5x_output(unsigned char sample);
void __fastcall__ digiblaster_fe9x_output(unsigned char sample);
void __fastcall__ ted_output(unsigned char sample);
unsigned char __fastcall__ sampler_2bit_sidcart_input(void);
unsigned char __fastcall__ sampler_4bit_sidcart_input(void);

/* c64-drivers.s / cbm2-common-drivers.s / pet-drivers.s / plus4-drivers.s / vic20-drivers.s */
void __fastcall__ sid_output_init(void);
void __fastcall__ sid_output(unsigned char sample);
void __fastcall__ set_sid_addr(unsigned addr);

/* vic20-drivers.s */
void __fastcall__ vic_output(unsigned char sample);
unsigned char __fastcall__ sfx_io_swapped_input(void);
void __fastcall__ sfx_io_swapped_output(unsigned char sample);
void __fastcall__ sfx_sound_expander_io_swapped_output_init(void);

/* c64-drivers.s / cbm2-drivers.s / pet-drivers.s / plus4-drivers.s / vic20-drivers.s */
void __fastcall__ userport_dac_output_init(void);
void __fastcall__ userport_dac_output(unsigned char sample);
void __fastcall__ sampler_2bit_hummer_input_init(void);
unsigned char __fastcall__ sampler_2bit_hummer_input(void);
void __fastcall__ sampler_4bit_hummer_input_init(void);
unsigned char __fastcall__ sampler_4bit_hummer_input(void);
void __fastcall__ sampler_2bit_spt_input_init(void);
unsigned char __fastcall__ sampler_2bit_spt_input(void);
void __fastcall__ sampler_4bit_spt_input_init(void);
unsigned char __fastcall__ sampler_4bit_spt_input(void);
void __fastcall__ sampler_2bit_oem_input_init(void);
unsigned char __fastcall__ sampler_2bit_oem_input(void);
void __fastcall__ sampler_4bit_oem_input_init(void);
unsigned char __fastcall__ sampler_4bit_oem_input(void);
void __fastcall__ sampler_2bit_pet1_input_init(void);
unsigned char __fastcall__ sampler_2bit_pet1_input(void);
void __fastcall__ sampler_4bit_pet1_input_init(void);
unsigned char __fastcall__ sampler_4bit_pet1_input(void);
void __fastcall__ sampler_2bit_pet2_input_init(void);
unsigned char __fastcall__ sampler_2bit_pet2_input(void);
void __fastcall__ sampler_4bit_pet2_input_init(void);
unsigned char __fastcall__ sampler_4bit_pet2_input(void);
void __fastcall__ sampler_2bit_syn1_input_init(void);
unsigned char __fastcall__ sampler_2bit_syn1_input(void);
void __fastcall__ sampler_4bit_syn1_input_init(void);
unsigned char __fastcall__ sampler_4bit_syn1_input(void);
void __fastcall__ sampler_2bit_syn2_input_init(void);
unsigned char __fastcall__ sampler_2bit_syn2_input(void);
void __fastcall__ sampler_4bit_syn2_input_init(void);
unsigned char __fastcall__ sampler_4bit_syn2_input(void);
void __fastcall__ sampler_2bit_syn3_input_init(void);
unsigned char __fastcall__ sampler_2bit_syn3_input(void);
void __fastcall__ sampler_4bit_syn3_input_init(void);
unsigned char __fastcall__ sampler_4bit_syn3_input(void);

/* c64-drivers.s / cbm2-drivers.s / pet-drivers.s / vic20-drivers.s */
void __fastcall__ sampler_2bit_cga1_input_init(void);
unsigned char __fastcall__ sampler_2bit_cga1_input(void);
void __fastcall__ sampler_4bit_cga1_input_init(void);
unsigned char __fastcall__ sampler_4bit_cga1_input(void);
void __fastcall__ sampler_2bit_cga2_input_init(void);
unsigned char __fastcall__ sampler_2bit_cga2_input(void);
void __fastcall__ sampler_4bit_cga2_input_init(void);
unsigned char __fastcall__ sampler_4bit_cga2_input(void);

/* c64-drivers.s / cbm2-drivers.s */
void __fastcall__ sampler_2bit_hit1_input_init(void);
unsigned char __fastcall__ sampler_2bit_hit1_input(void);
void __fastcall__ sampler_4bit_hit1_input_init(void);
unsigned char __fastcall__ sampler_4bit_hit1_input(void);
void __fastcall__ sampler_2bit_hit2_input_init(void);
unsigned char __fastcall__ sampler_2bit_hit2_input(void);
void __fastcall__ sampler_4bit_hit2_input_init(void);
unsigned char __fastcall__ sampler_4bit_hit2_input(void);
void __fastcall__ sampler_2bit_kingsoft1_input_init(void);
unsigned char __fastcall__ sampler_2bit_kingsoft1_input(void);
void __fastcall__ sampler_4bit_kingsoft1_input_init(void);
unsigned char __fastcall__ sampler_4bit_kingsoft1_input(void);
void __fastcall__ sampler_2bit_kingsoft2_input_init(void);
unsigned char __fastcall__ sampler_2bit_kingsoft2_input(void);
void __fastcall__ sampler_4bit_kingsoft2_input_init(void);
unsigned char __fastcall__ sampler_4bit_kingsoft2_input(void);
void __fastcall__ sampler_2bit_starbyte1_input_init(void);
unsigned char __fastcall__ sampler_2bit_starbyte1_input(void);
void __fastcall__ sampler_4bit_starbyte1_input_init(void);
unsigned char __fastcall__ sampler_4bit_starbyte1_input(void);
void __fastcall__ sampler_2bit_starbyte2_input_init(void);
unsigned char __fastcall__ sampler_2bit_starbyte2_input(void);
void __fastcall__ sampler_4bit_starbyte2_input_init(void);
unsigned char __fastcall__ sampler_4bit_starbyte2_input(void);
void __fastcall__ sampler_4bit_userport_input_init(void);
unsigned char __fastcall__ sampler_4bit_userport_input(void);

/* c64-drivers.s / cbm5x0-drivers.s / plus4-drivers.s / vic20-drivers.s */
unsigned char __fastcall__ sampler_2bit_joy1_input(void);
unsigned char __fastcall__ sampler_4bit_joy1_input(void);

/* c64-drivers.s / cbm5x0-drivers.s / plus4-drivers.s */
unsigned char __fastcall__ sampler_2bit_joy2_input(void);
unsigned char __fastcall__ sampler_4bit_joy2_input(void);

/* c64-drivers.s / cbm2-drivers.s */
void __fastcall__ userport_digimax_output_init(void);
void __fastcall__ userport_digimax_output(unsigned char sample);

/* c64-drivers.s */
void __fastcall__ siddtv_output_init(void);
void __fastcall__ siddtv_output(unsigned char sample);

/* stubs.s */
void __fastcall__ sampler_8bss_left_input_init(void);
void __fastcall__ sampler_8bss_right_input_init(void);
void __fastcall__ daisy_input_init(void);

unsigned char __fastcall__ sampler_8bss_left_input(void);
unsigned char __fastcall__ sampler_8bss_right_input(void);
unsigned char __fastcall__ daisy_input(void);

/* all */
void __fastcall__ show_sample(unsigned char sample);

#endif
