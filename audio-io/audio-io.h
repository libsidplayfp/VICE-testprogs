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

/* c64-drivers.s / cbm2-drivers.s */
void __fastcall__ sampler_4bit_userport_input_init(void);
unsigned char __fastcall__ sampler_4bit_userport_input(void);

/* c64-drivers.s / cbm5x0-drivers.s / plus4-drivers.s / vic20-drivers.s */
unsigned char __fastcall__ sampler_2bit_joy1_input(void);
unsigned char __fastcall__ sampler_4bit_joy1_input(void);

/* c64-drivers.s / cbm5x0-drivers.s / plus4-drivers.s */
unsigned char __fastcall__ sampler_2bit_joy2_input(void);
unsigned char __fastcall__ sampler_4bit_joy2_input(void);

/* c64-drivers.s / cbm5x0-drivers.s / vic20-drivers.s */
unsigned char __fastcall__ sampler_2bit_inception_j1p1_input(void);
unsigned char __fastcall__ sampler_2bit_inception_j1p2_input(void);
unsigned char __fastcall__ sampler_2bit_inception_j1p3_input(void);
unsigned char __fastcall__ sampler_2bit_inception_j1p4_input(void);
unsigned char __fastcall__ sampler_2bit_inception_j1p5_input(void);
unsigned char __fastcall__ sampler_2bit_inception_j1p6_input(void);
unsigned char __fastcall__ sampler_2bit_inception_j1p7_input(void);
unsigned char __fastcall__ sampler_2bit_inception_j1p8_input(void);
unsigned char __fastcall__ sampler_4bit_inception_j1p1_input(void);
unsigned char __fastcall__ sampler_4bit_inception_j1p2_input(void);
unsigned char __fastcall__ sampler_4bit_inception_j1p3_input(void);
unsigned char __fastcall__ sampler_4bit_inception_j1p4_input(void);
unsigned char __fastcall__ sampler_4bit_inception_j1p5_input(void);
unsigned char __fastcall__ sampler_4bit_inception_j1p6_input(void);
unsigned char __fastcall__ sampler_4bit_inception_j1p7_input(void);
unsigned char __fastcall__ sampler_4bit_inception_j1p8_input(void);

/* c64-drivers.s / cbm5x0-drivers.s */
unsigned char __fastcall__ sampler_2bit_inception_j2p1_input(void);
unsigned char __fastcall__ sampler_2bit_inception_j2p2_input(void);
unsigned char __fastcall__ sampler_2bit_inception_j2p3_input(void);
unsigned char __fastcall__ sampler_2bit_inception_j2p4_input(void);
unsigned char __fastcall__ sampler_2bit_inception_j2p5_input(void);
unsigned char __fastcall__ sampler_2bit_inception_j2p6_input(void);
unsigned char __fastcall__ sampler_2bit_inception_j2p7_input(void);
unsigned char __fastcall__ sampler_2bit_inception_j2p8_input(void);
unsigned char __fastcall__ sampler_4bit_inception_j2p1_input(void);
unsigned char __fastcall__ sampler_4bit_inception_j2p2_input(void);
unsigned char __fastcall__ sampler_4bit_inception_j2p3_input(void);
unsigned char __fastcall__ sampler_4bit_inception_j2p4_input(void);
unsigned char __fastcall__ sampler_4bit_inception_j2p5_input(void);
unsigned char __fastcall__ sampler_4bit_inception_j2p6_input(void);
unsigned char __fastcall__ sampler_4bit_inception_j2p7_input(void);
unsigned char __fastcall__ sampler_4bit_inception_j2p8_input(void);

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
