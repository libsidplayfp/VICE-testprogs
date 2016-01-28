#ifndef VICE_AUDIO_IO_H
#define VICE_AUDIO_IO_H

/* stream.s */
void __fastcall__ set_input_jsr(char __fastcall__ (*function)(void));
void __fastcall__ set_output_jsr(void __fastcall__ (*function)(unsigned char sample));
void __fastcall__ stream(void);

/* sfx-input-c64.s / sfx-input-vic20.s */
unsigned char __fastcall__ sfx_input(void);

/* digiblaster-input-plus4.s */
unsigned char __fastcall__ digiblaster_input(void);

/* sfx-output-c64.s / sfx-output-vic20.s */
void __fastcall__ sfx_output(unsigned char sample);

/* sid-output-c64.s / sid-output-cbm2.s / sid-output-pet.s / sid-output-plus4.s / sid-output-vic20.s */
void __fastcall__ sid_output_init(void);
void __fastcall__ sid_output(unsigned char sample);

/* digiblaster-output-plus4.s */
void __fastcall__ digiblaster_output(unsigned char sample);

/* vic-output-vic20.s */
void __fastcall__ vic_output(unsigned char sample);

/* digimax-cart-output-c64.s / digimax-cart-output-vic20.s */
void __fastcall__ digimax_cart_output(unsigned char sample);

/* userport-dac-output-c64.s / userport-dac-output-cbm2.s / userport-dac-output-pet.s / userport-dac-output-plus4.s / userport-dac-output-vic20.s */
void __fastcall__ userport_dac_output_init(void);
void __fastcall__ userport_dac_output(unsigned char sample);

/* sampler-4bit-joy1-input-c64.s / sampler-4bit-joy1-input-cbm2.s / sampler-4bit-joy1-input-plus4.s / sampler-4bit-joy1-input-vic20.s */
unsigned char __fastcall__ sampler_4bit_joy1_input(void);

/* stubs.s */
void __fastcall__ sampler_2bit_hit1_input_init(void);
void __fastcall__ sampler_2bit_hit2_input_init(void);
void __fastcall__ sampler_4bit_hit1_input_init(void);
void __fastcall__ sampler_4bit_hit2_input_init(void);
void __fastcall__ sampler_2bit_kingsoft1_input_init(void);
void __fastcall__ sampler_4bit_kingsoft1_input_init(void);
void __fastcall__ sampler_2bit_kingsoft2_input_init(void);
void __fastcall__ sampler_4bit_kingsoft2_input_init(void);
void __fastcall__ sampler_2bit_starbyte1_input_init(void);
void __fastcall__ sampler_4bit_starbyte1_input_init(void);
void __fastcall__ sampler_2bit_starbyte2_input_init(void);
void __fastcall__ sampler_4bit_starbyte2_input_init(void);
void __fastcall__ sampler_2bit_cga1_input_init(void);
void __fastcall__ sampler_4bit_cga1_input_init(void);
void __fastcall__ sampler_2bit_cga2_input_init(void);
void __fastcall__ sampler_4bit_cga2_input_init(void);
void __fastcall__ sampler_2bit_pet1_input_init(void);
void __fastcall__ sampler_4bit_pet1_input_init(void);
void __fastcall__ sampler_2bit_pet2_input_init(void);
void __fastcall__ sampler_4bit_pet2_input_init(void);
void __fastcall__ sampler_2bit_oem_input_init(void);
void __fastcall__ sampler_4bit_oem_input_init(void);
void __fastcall__ sampler_2bit_hummer_input_init(void);
void __fastcall__ sampler_4bit_hummer_input_init(void);
void __fastcall__ sampler_4bit_userport_input_init(void);
void __fastcall__ sampler_8bss_left_input_init(void);
void __fastcall__ sampler_8bss_right_input_init(void);
void __fastcall__ sampler_2bit_joy1_input_init(void);
void __fastcall__ sampler_2bit_joy2_input_init(void);
void __fastcall__ sampler_4bit_joy2_input_init(void);
void __fastcall__ sampler_2bit_sidcart_input_init(void);
void __fastcall__ sampler_4bit_sidcart_input_init(void);
void __fastcall__ daisy_input_init(void);
void __fastcall__ software_input_init(void);

unsigned char __fastcall__ sampler_2bit_hit1_input(void);
unsigned char __fastcall__ sampler_2bit_hit2_input(void);
unsigned char __fastcall__ sampler_4bit_hit1_input(void);
unsigned char __fastcall__ sampler_4bit_hit2_input(void);
unsigned char __fastcall__ sampler_2bit_kingsoft1_input(void);
unsigned char __fastcall__ sampler_4bit_kingsoft1_input(void);
unsigned char __fastcall__ sampler_2bit_kingsoft2_input(void);
unsigned char __fastcall__ sampler_4bit_kingsoft2_input(void);
unsigned char __fastcall__ sampler_2bit_starbyte1_input(void);
unsigned char __fastcall__ sampler_4bit_starbyte1_input(void);
unsigned char __fastcall__ sampler_2bit_starbyte2_input(void);
unsigned char __fastcall__ sampler_4bit_starbyte2_input(void);
unsigned char __fastcall__ sampler_2bit_cga1_input(void);
unsigned char __fastcall__ sampler_4bit_cga1_input(void);
unsigned char __fastcall__ sampler_2bit_cga2_input(void);
unsigned char __fastcall__ sampler_4bit_cga2_input(void);
unsigned char __fastcall__ sampler_2bit_pet1_input(void);
unsigned char __fastcall__ sampler_4bit_pet1_input(void);
unsigned char __fastcall__ sampler_2bit_pet2_input(void);
unsigned char __fastcall__ sampler_4bit_pet2_input(void);
unsigned char __fastcall__ sampler_2bit_oem_input(void);
unsigned char __fastcall__ sampler_4bit_oem_input(void);
unsigned char __fastcall__ sampler_2bit_hummer_input(void);
unsigned char __fastcall__ sampler_4bit_hummer_input(void);
unsigned char __fastcall__ sampler_4bit_userport_input(void);
unsigned char __fastcall__ sampler_8bss_left_input(void);
unsigned char __fastcall__ sampler_8bss_right_input(void);
unsigned char __fastcall__ sampler_2bit_joy1_input(void);
unsigned char __fastcall__ sampler_2bit_joy2_input(void);
unsigned char __fastcall__ sampler_4bit_joy2_input(void);
unsigned char __fastcall__ sampler_2bit_sidcart_input(void);
unsigned char __fastcall__ sampler_4bit_sidcart_input(void);
unsigned char __fastcall__ daisy_input(void);
unsigned char __fastcall__ software_input(void);

void __fastcall__ ted_output_init(void);
void __fastcall__ userport_digimax_output_init(void);

void __fastcall__ ted_output(unsigned char sample);
void __fastcall__ userport_digimax_output(unsigned char sample);
