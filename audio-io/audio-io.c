#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <conio.h>
#include <peekpoke.h>
#include <6502.h>

#ifdef __CBM510__
#include <cbm510.h>
#endif

#ifdef __CBM610__
#include <cbm610.h>
#endif

#include "audio-io.h"

#if defined(__C64__) || defined(__C128__)
static unsigned sid_addresses_d4[] = { 0xd400, 0xd420, 0xd440, 0xd460, 0xd480, 0xd4a0, 0xd4c0, 0xd4e0, 0 };
static unsigned sid_addresses_d7[] = { 0xd700, 0xd720, 0xd740, 0xd760, 0xd780, 0xd7a0, 0xd7c0, 0xd7e0, 0 };
static unsigned sid_addresses_de[] = { 0xde00, 0xde20, 0xde40, 0xde60, 0xde80, 0xdea0, 0xdec0, 0xdee0, 0 };
static unsigned sid_addresses_df[] = { 0xdf00, 0xdf20, 0xdf40, 0xdf60, 0xdf80, 0xdfa0, 0xdfc0, 0xdfe0, 0 };
#endif

#if defined(__C64__)
static unsigned sid_addresses_d5[] = { 0xd500, 0xd520, 0xd540, 0xd560, 0xd580, 0xd5a0, 0xd5c0, 0xd5e0, 0 };
static unsigned sid_addresses_d6[] = { 0xd600, 0xd620, 0xd640, 0xd660, 0xd680, 0xd6a0, 0xd6c0, 0xd6e0, 0 };
#endif

#if defined(__CBM510__) || defined(__CBM610__)
static unsigned sid_addresses_da[] = { 0xda00, 0 };
#endif

#if defined(__PET__)
static unsigned sidcart_addresses_8f[] = { 0x8f00, 0 };
static unsigned sidcart_addresses_e9[] = { 0xe900, 0 };
#endif

#if defined(__PLUS4__) || defined(__C16__)
static unsigned sidcart_addresses_fd[] = { 0xfd40, 0 };
static unsigned sidcart_addresses_fe[] = { 0xfe80, 0 };
#endif

#if defined(__VIC20__)
static unsigned sidcart_addresses_98[] = { 0x9800, 0 };
static unsigned sidcart_addresses_9c[] = { 0x9c00, 0 };
#endif

#if defined(__C64__)
static unsigned *sid_addresses[] = { sid_addresses_d4, sid_addresses_d5, sid_addresses_d6, sid_addresses_d7, sid_addresses_de, sid_addresses_df, NULL };
#endif

#if defined(__C128__)
static unsigned *sid_addresses[] = { sid_addresses_d4, sid_addresses_d7, sid_addresses_de, sid_addresses_df, NULL };
#endif

#if defined(__CBM510__) || defined(__CBM610__)
static unsigned *sid_addresses[] = { sid_addresses_da, NULL };
#endif

#if defined(__PET__)
static unsigned *sid_addresses[] = { sidcart_addresses_8f, sidcart_addresses_e9, NULL };
#endif

#if defined(__PLUS4__) || defined(__C16__)
static unsigned *sid_addresses[] = { sidcart_addresses_fd, sidcart_addresses_fe, NULL };
#endif

#if defined(__VIC20__)
static unsigned *sid_addresses[] = { sidcart_addresses_98, sidcart_addresses_9c, NULL };
#endif

/* detection of c64dtv */
#if defined(__C64__)
static unsigned char isc64dtv = 0;

static void test_c64dtv(void)
{
    unsigned char temp1, temp2;

    POKE(0xD03F, 1);
    temp1 = PEEK(0xD040);
    POKE(0xD000, PEEK(0xD000) + 1);
    temp2 = PEEK(0xD000);
    if (PEEK(0xD040) == temp1)
        isc64dtv = 1;
    if (PEEK(0xD040) == temp2)
        isc64dtv = 0;
    POKE(0xD03F, 0);
}
#endif

typedef struct input_device_s {
    char *device_name;
    void (*function_init)(void);
    unsigned char (*function)(void);
} input_device_t;

typedef struct menu_input_s {
    char key;
    char *displayname;
    struct menu_input_s *menu;
    input_device_t *device;
} menu_input_t;

typedef struct output_device_s {
    char *device_name;
    void (*function_init)(void);
    void (*function)(unsigned char);
} output_device_t;

typedef struct menu_output_s {
    char key;
    char *displayname;
    output_device_t *device;
} menu_output_t;

/* -------------------------------------------------------------------------------------------------------- */

#if defined(__C64__) || defined(__C128__)
static input_device_t sampler_2bit_hit1_input_device[] = {
    { "2 bit sampler on port 1 of userport HIT joy adapter", sampler_2bit_hit1_input_init, sampler_2bit_hit1_input }
};
#endif

#if defined(__C64__) || defined(__C128__)
static input_device_t sampler_4bit_hit1_input_device[] = {
    { "4 bit sampler on port 1 of userport HIT joy adapter", sampler_4bit_hit1_input_init, sampler_4bit_hit1_input }
};
#endif

#if defined(__C64__) || defined(__C128__)
static input_device_t sampler_2bit_hit2_input_device[] = {
    { "2 bit sampler on port 2 of userport HIT joy adapter", sampler_2bit_hit2_input_init, sampler_2bit_hit2_input }
};
#endif

#if defined(__C64__) || defined(__C128__)
static input_device_t sampler_4bit_hit2_input_device[] = {
    { "4 bit sampler on port 2 of userport HIT joy adapter", sampler_4bit_hit2_input_init, sampler_4bit_hit2_input }
};
#endif

#if defined(__C64__) || defined(__C128__)
static input_device_t sampler_2bit_kingsoft1_input_device[] = {
    { "2 bit sampler on port 1 of userport KingSoft joy adapter", sampler_2bit_kingsoft1_input_init, sampler_2bit_kingsoft1_input }
};
#endif

#if defined(__C64__) || defined(__C128__)
static input_device_t sampler_4bit_kingsoft1_input_device[] = {
    { "4 bit sampler on port 1 of userport KingSoft joy adapter", sampler_4bit_kingsoft1_input_init, sampler_4bit_kingsoft1_input }
};
#endif

#if defined(__C64__) || defined(__C128__)
static input_device_t sampler_2bit_kingsoft2_input_device[] = {
    { "2 bit sampler on port 2 of userport KingSoft joy adapter", sampler_2bit_kingsoft2_input_init, sampler_2bit_kingsoft2_input }
};
#endif

#if defined(__C64__) || defined(__C128__)
static input_device_t sampler_4bit_kingsoft2_input_device[] = {
    { "4 bit sampler on port 2 of userport KingSoft joy adapter", sampler_4bit_kingsoft2_input_init, sampler_4bit_kingsoft2_input }
};
#endif

#if defined(__C64__) || defined(__C128__)
static input_device_t sampler_2bit_starbyte1_input_device[] = {
    { "2 bit sampler on port 1 of userport StarByte joy adapter", sampler_2bit_starbyte1_input_init, sampler_2bit_starbyte1_input }
};
#endif

#if defined(__C64__) || defined(__C128__)
static input_device_t sampler_4bit_starbyte1_input_device[] = {
    { "4 bit sampler on port 1 of userport StarByte joy adapter", sampler_4bit_starbyte1_input_init, sampler_4bit_starbyte1_input }
};
#endif

#if defined(__C64__) || defined(__C128__)
static input_device_t sampler_2bit_starbyte2_input_device[] = {
    { "2 bit sampler on port 2 of userport StarByte joy adapter", sampler_2bit_starbyte2_input_init, sampler_2bit_starbyte2_input }
};
#endif

#if defined(__C64__) || defined(__C128__)
static input_device_t sampler_4bit_starbyte2_input_device[] = {
    { "4 bit sampler on port 2 of userport StarByte joy adapter", sampler_4bit_starbyte2_input_init, sampler_4bit_starbyte2_input }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) defined(__CBM610__) || defined(__PET__)
static input_device_t sampler_2bit_cga1_input_device[] = {
    { "2 bit sampler on port 1 of userport CGA joy adapter", sampler_2bit_cga1_input_init, sampler_2bit_cga1_input }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) defined(__CBM610__) || defined(__PET__)
static input_device_t sampler_4bit_cga1_input_device[] = {
    { "4 bit sampler on port 1 of userport CGA joy adapter", sampler_4bit_cga1_input_init, sampler_4bit_cga1_input }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) defined(__CBM610__) || defined(__PET__)
static input_device_t sampler_2bit_cga2_input_device[] = {
    { "2 bit sampler on port 2 of userport CGA joy adapter", sampler_2bit_cga2_input_init, sampler_2bit_cga2_input }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) defined(__CBM610__) || defined(__PET__)
static input_device_t sampler_4bit_cga2_input_device[] = {
    { "4 bit sampler on port 2 of userport CGA joy adapter", sampler_4bit_cga2_input_init, sampler_4bit_cga2_input }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__CBM610__) || defined(__PET__)
static input_device_t sampler_2bit_pet1_input_device[] = {
    { "2 bit sampler on port 1 of userport PET joy adapter", sampler_2bit_pet1_input_init, sampler_2bit_pet1_input }
};
#endif

#if defined(__C16__) || defined(__PLUS4__)
static input_device_t sampler_2bit_pet1_input_device[] = {
    { "2 bit sampler on port 1 of userport PET joy adapter", NULL, sampler_2bit_pet1_input }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__CBM610__) || defined(__PET__)
static input_device_t sampler_4bit_pet1_input_device[] = {
    { "4 bit sampler on port 1 of userport PET joy adapter", sampler_4bit_pet1_input_init, sampler_4bit_pet1_input }
};
#endif

#if defined(__C16__) || defined(__PLUS4__)
static input_device_t sampler_4bit_pet1_input_device[] = {
    { "4 bit sampler on port 1 of userport PET joy adapter", NULL, sampler_4bit_pet1_input }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__CBM610__) || defined(__PET__)
static input_device_t sampler_2bit_pet2_input_device[] = {
    { "2 bit sampler on port 2 of userport PET joy adapter", sampler_2bit_pet2_input_init, sampler_2bit_pet2_input }
};
#endif

#if defined(__C16__) || defined(__PLUS4__)
static input_device_t sampler_2bit_pet2_input_device[] = {
    { "2 bit sampler on port 2 of userport PET joy adapter", NULL, sampler_2bit_pet2_input }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__CBM610__) || defined(__PET__)
static input_device_t sampler_4bit_pet2_input_device[] = {
    { "4 bit sampler on port 2 of userport PET joy adapter", sampler_4bit_pet2_input_init, sampler_4bit_pet2_input }
};
#endif

#if defined(__C16__) || defined(__PLUS4__)
static input_device_t sampler_4bit_pet2_input_device[] = {
    { "4 bit sampler on port 2 of userport PET joy adapter", NULL, sampler_4bit_pet2_input }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__CBM610__) || defined(__PET__)
static input_device_t sampler_2bit_oem_input_device[] = {
    { "2 bit sampler on userport OEM joy adapter", sampler_2bit_oem_input_init, sampler_2bit_oem_input }
};
#endif

#if defined(__C16__) || defined(__PLUS4__)
static input_device_t sampler_2bit_oem_input_device[] = {
    { "2 bit sampler on userport OEM joy adapter", NULL, sampler_2bit_oem_input }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__CBM610__) || defined(__PET__)
static input_device_t sampler_4bit_oem_input_device[] = {
    { "4 bit sampler on userport OEM joy adapter", sampler_4bit_oem_input_init, sampler_4bit_oem_input }
};
#endif

#if defined(__C16__) || defined(__PLUS4__)
static input_device_t sampler_4bit_oem_input_device[] = {
    { "4 bit sampler on userport OEM joy adapter", NULL, sampler_4bit_oem_input }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__CBM610__) || defined(__PET__)
static input_device_t sampler_2bit_hummer_input_device[] = {
    { "2 bit sampler on userport HUMMER joy adapter", sampler_2bit_hummer_input_init, sampler_2bit_hummer_input }
};
#endif

#if defined(__C16__) || defined(__PLUS4__)
static input_device_t sampler_2bit_hummer_input_device[] = {
    { "2 bit sampler on userport HUMMER joy adapter", NULL, sampler_2bit_hummer_input }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__CBM610__) || defined(__PET__)
static input_device_t sampler_4bit_hummer_input_device[] = {
    { "4 bit sampler on userport HUMMER joy adapter", sampler_4bit_hummer_input_init, sampler_4bit_hummer_input }
};
#endif

#if defined(__C16__) || defined(__PLUS4__)
static input_device_t sampler_4bit_hummer_input_device[] = {
    { "4 bit sampler on userport HUMMER joy adapter", NULL, sampler_4bit_hummer_input }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__CBM610__)
static input_device_t sampler_4bit_userport_input_device[] = {
    { "4 bit userport sampler", sampler_4bit_userport_input_init, sampler_4bit_userport_input }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__CBM610__)
static input_device_t sampler_8bss_left_input_device[] = {
    { "left channel of userport 8 bit stereo sampler", sampler_8bss_left_input_init, sampler_8bss_left_input }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__CBM610__)
static input_device_t sampler_8bss_right_input_device[] = {
    { "right channel of userport 8 bit stereo sampler", sampler_8bss_right_input_init, sampler_8bss_right_input }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM510__)
static input_device_t sampler_2bit_joy1_input_device[] = {
    { "2 bit sampler on joystick port 1", NULL, sampler_2bit_joy1_input }
};
#endif

#if defined(__VIC20__)
static input_device_t sampler_2bit_joy1_input_device[] = {
    { "2 bit sampler on joystick port", NULL, sampler_2bit_joy1_input }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM510__)
static input_device_t sampler_4bit_joy1_input_device[] = {
    { "4 bit sampler on joystick port 1", NULL, sampler_4bit_joy1_input }
};
#endif

#if defined(__VIC20__)
static input_device_t sampler_4bit_joy1_input_device[] = {
    { "4 bit sampler on joystick port", NULL, sampler_4bit_joy1_input }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM510__)
static input_device_t sampler_2bit_joy2_input_device[] = {
    { "2 bit sampler on joystick port 2", NULL, sampler_2bit_joy2_input }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM510__)
static input_device_t sampler_4bit_joy2_input_device[] = {
    { "4 bit sampler on joystick port 2", NULL, sampler_4bit_joy2_input }
};
#endif

#if defined(__C16__) || defined(__PLUS4__)
static input_device_t sampler_2bit_sidcart_input_device[] = {
    { "2 bit sampler on sidcart joystick port", NULL, sampler_2bit_sidcart_input }
};
#endif

#if defined(__C16__) || defined(__PLUS4__)
static input_device_t sampler_4bit_sidcart_input_device[] = {
    { "4 bit sampler on sidcart joystick port", NULL, sampler_4bit_sidcart_input }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__)
static input_device_t sfx_input_device[] = {
    { "SFX Sound Sampler", NULL, sfx_input }
};
#endif

#if defined(__C64__) || defined(__C128__)
static input_device_t daisy_input_device[] = {
    { "DAISY", daisy_input_init, daisy_input }
};
#endif

#if defined(__C16__) || defined(__PLUS4__)
static input_device_t digiblaster_input_device[] = {
    { "DigiBlaster", NULL, digiblaster_input }
};
#endif

static input_device_t software_input_device[] = {
    { "software generated waveform", NULL, software_input }
};

/* -------------------------------------------------------------------------------------------------------- */

#if defined(__C64__) || defined(__C128__) || defined(__CBM510__) || defined(__CBM610__)
static output_device_t sid_output_device[] = {
    { "SID", sid_output_init, sid_output }
};
#endif

#if defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__PET__)
static output_device_t sid_output_device[] = {
    { "SIDcart", sid_output_init, sid_output }
};
#endif

#if defined(__C16__) || defined(__PLUS4__)
static output_device_t ted_output_device[] = {
    { "TED", NULL, ted_output }
};
#endif

#if defined(__C64__)
static output_device_t siddtv_output_device[] = {
    { "SIDDTV", siddtv_output_init, siddtv_output }
};
#endif

#if defined(__VIC20__)
static output_device_t vic_output_device[] = {
    { "VIC", NULL, vic_output }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__)
static output_device_t sfx_output_device[] = {
    { "SFX Sound Sampler", NULL, sfx_output }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__)
static output_device_t sfx_sound_expander_output_device[] = {
    { "SFX Sound Expander", sfx_sound_expander_output_init, sfx_sound_expander_output }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__)
static output_device_t digimax_cart_output_device[] = {
    { "DigiMAX cartridge", NULL, digimax_cart_output }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__CBM610__)
static output_device_t userport_digimax_output_device[] = {
    { "DigiMAX userport device", userport_digimax_output_init, userport_digimax_output }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__CBM610__) || defined(__PET__)
static output_device_t userport_dac_output_device[] = {
    { "userport DAC", userport_dac_output_init, userport_dac_output }
};
#endif

#if defined(__C16__) || defined(__PLUS4__)
static output_device_t userport_dac_output_device[] = {
    { "userport DAC", NULL, userport_dac_output }
};
#endif

#if defined(__C16__) || defined(__PLUS4__)
static output_device_t digiblaster_output_device[] = {
    { "DigiBlaster", NULL, digiblaster_output }
};
#endif

/* -------------------------------------------------------------------------------------------------------- */

#if defined(__C64__) || defined(__C128__)
static menu_input_t input_hit1_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_hit1_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_hit1_input_device },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__)
static menu_input_t input_hit2_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_hit2_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_hit2_input_device },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__)
static menu_input_t input_hit_menu[] = {
    { '1', "port 1", input_hit1_menu, NULL },
    { '2', "port 2", input_hit2_menu, NULL },
    { 0, NULL, NULL, NULL },
};
#endif

#if defined(__C64__) || defined(__C128__)
static menu_input_t input_kingsoft1_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_kingsoft1_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_kingsoft1_input_device },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__)
static menu_input_t input_kingsoft2_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_kingsoft2_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_kingsoft2_input_device },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__)
static menu_input_t input_kingsoft_menu[] = {
    { '1', "port 1", input_kingsoft1_menu, NULL },
    { '2', "port 2", input_kingsoft2_menu, NULL },
    { 0, NULL, NULL, NULL },
};
#endif

#if defined(__C64__) || defined(__C128__)
static menu_input_t input_starbyte1_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_starbyte1_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_starbyte1_input_device },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__)
static menu_input_t input_starbyte2_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_starbyte2_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_starbyte2_input_device },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__)
static menu_input_t input_starbyte_menu[] = {
    { '1', "port 1", input_starbyte1_menu, NULL },
    { '2', "port 2", input_starbyte2_menu, NULL },
    { 0, NULL, NULL, NULL },
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) defined(__CBM610__) || defined(__PET__)
static menu_input_t input_cga1_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_cga1_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_cga1_input_device },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) defined(__CBM610__) || defined(__PET__)
static menu_input_t input_cga2_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_cga2_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_cga2_input_device },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) defined(__CBM610__) || defined(__PET__)
static menu_input_t input_cga_menu[] = {
    { '1', "port 1", input_cga1_menu, NULL },
    { '2', "port 2", input_cga2_menu, NULL },
    { 0, NULL, NULL, NULL },
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
static menu_input_t input_pet1_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_pet1_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_pet1_input_device },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
static menu_input_t input_pet2_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_pet2_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_pet2_input_device },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
static menu_input_t input_pet_menu[] = {
    { '1', "port 1", input_pet1_menu, NULL },
    { '2', "port 2", input_pet2_menu, NULL },
    { 0, NULL, NULL, NULL },
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
static menu_input_t input_oem_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_oem_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_oem_input_device },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
static menu_input_t input_hummer_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_hummer_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_hummer_input_device },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
static menu_input_t input_userport_joy_menu[] = {
    { 'd', "C64DTV HUMMER joystick adapter", input_hummer_menu, NULL },
    { 'o', "OEM joystick adapter", input_oem_menu, NULL },
    { 'p', "PET joystick adapter", input_pet_menu, NULL },
#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) defined(__CBM610__) || defined(__PET__)
    { 'c', "CGA joystick adapter", input_cga_menu, NULL },
#endif
#if defined(__C64__) || defined(__C128__)
    { 's', "StarByte joystick adapter", input_starbyte_menu, NULL },
    { 'k', "KingSoft joystick adapter", input_kingsoft_menu, NULL },
    { 'h', "HIT joystick adapter", input_hit_menu, NULL },
#endif
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
static menu_input_t input_userport_menu[] = {
    { 'j', "userport joystick adapter", input_userport_joy_menu, NULL },
#if defined(__C64__) || defined(__C128__) || defined(__CBM610__)
    { '4', "4 bit sampler", NULL, sampler_4bit_userport_input_device },
#endif
#if defined(__C64__) || defined(__C128__) || defined(__CBM610__)
    { 'l', "8BSS left", NULL, sampler_8bss_left_input_device },
    { 'r', "8BSS right", NULL, sampler_8bss_right_input_device },
#endif
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM510__) || defined(__VIC20__)
static menu_input_t input_native_joy1_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_joy1_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_joy1_input_device },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM510__)
static menu_input_t input_native_joy2_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_joy2_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_joy2_input_device },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C16__) || defined(__PLUS4__)
static menu_input_t input_sidcart_joy_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_sidcart_input_device },




    { '4', "4 bit sampler", NULL, sampler_4bit_sidcart_input_device },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM510__)
static menu_input_t input_joy_menu[] = {
#if defined(__C64__) || defined(__C128__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM510__)
    { '1', "native port 1", input_native_joy1_menu, NULL },
    { '2', "native port 2", input_native_joy2_menu, NULL },
#endif
#if defined(__VIC20__)
    { '1', "native port", input_native_joy1_menu, NULL },
#endif
#if defined(__C16__) || defined(__PLUS4__)
    { 's', "sidcart port", input_sidcart_joy_menu, NULL },
#endif
    { 0, NULL, NULL, NULL },
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__)
static menu_input_t input_cart_menu[] = {
#if defined(__C64__) || defined(__C128__) || defined(__VIC20__)
    { 's', "sfx sound sampler", NULL, sfx_input_device },
#endif
#if defined(__C64__) || defined(__C128__)
    { 'd', "daisy", NULL, daisy_input_device },
#endif
#if defined(__C16__) || defined(__PLUS4__)
    { 'd', "digiblaster", NULL, digiblaster_input_device },
#endif
    { 0, NULL, NULL, NULL },
};
#endif

static menu_input_t input_port_menu[] = {
#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__)
    { 'c', "cartridge port", input_cart_menu, NULL },
#endif
#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM510__)
    { 'j', "joystick port", input_joy_menu, NULL },
#endif
#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
    { 'u', "userport", input_userport_menu, NULL },
#endif
    { 0, NULL, NULL, NULL }
};

static menu_input_t input_main_menu[] = {
    { 's', "software generated waveform", NULL, software_input_device },
    { 'h', "hardware device", input_port_menu, NULL },
    { 0, NULL, NULL, NULL }
};

#if defined(__C64__)
static menu_input_t input_port1_c64dtv_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_joy1_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_joy1_input_device },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__)
static menu_input_t input_port2_c64dtv_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_joy2_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_joy2_input_device },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__)
static menu_input_t input_hummer_c64dtv_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_hummer_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_hummer_input_device },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__)
static menu_input_t input_port_c64dtv_menu[] = {
    { '1', "native port 1", input_port1_c64dtv_menu, NULL },
    { '2', "native port 2", input_port2_c64dtv_menu, NULL },
    { 'h', "hummer joystick adapter", input_hummer_c64dtv_menu, NULL },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__)
static menu_input_t input_main_c64dtv_menu[] = {
    { 's', "software generated waveform", NULL, software_input_device },
    { 'h', "hardware device", input_port_c64dtv_menu, NULL },
    { 0, NULL, NULL, NULL }
};
#endif

/* -------------------------------------------------------------------------------------------------------- */

static menu_output_t output_menu[] = {
#if defined(__C64__) || defined(__C128__) || defined(__CBM510__) || defined(__CBM610__)
    { 's', "SID", sid_output_device },
#endif
#if defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__PET__)
    { 's', "SIDcart", sid_output_device },
#endif
#if defined(__C16__) || defined(__PLUS4__)
    { 't', "TED", ted_output_device },
#endif
#if defined(__VIC20__)
    { 'v', "VIC", vic_output_device },
#endif
#if defined(__C64__) || defined(__C128__) || defined(__VIC20__)
    { 'x', "sfx sound sampler", sfx_output_device },
#endif
#if defined(__C64__) || defined(__C128__) || defined(__VIC20__)
    { 'e', "sfx sound expander", sfx_sound_expander_output_device },
#endif
#if defined(__C64__) || defined(__C128__) || defined(__VIC20__)
    { 'd', "digimax cartridge", digimax_cart_output_device },
#endif
#if defined(__C64__) || defined(__C128__) || defined(__CBM610__)
    { 'u', "userport digimax device", userport_digimax_output_device },
#endif
#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
    { '8', "userport dac", userport_dac_output_device },
#endif
#if defined(__C16__) || defined(__PLUS4__)
    { 'b', "digiblaster", digiblaster_output_device },
#endif
    { 0, NULL, NULL }
};

#if defined(__C64__)
static menu_output_t output_c64dtv_menu[] = {
    { 's', "SID", sid_output_device },
    { 'd', "SIDDTV", siddtv_output_device },
    { 0, NULL, NULL }
};
#endif

int main(void)
{
    menu_input_t *current_input_menu = NULL;
    menu_output_t *current_output_menu = NULL;
    input_device_t *input_device = NULL;
    output_device_t *output_device = NULL;
    unsigned char index;
    unsigned char sid_index;
    signed char valid_key = -1;
    char key;
    unsigned char max_key = 0;

#if defined(__C64__)
    test_c64dtv();
    if (isc64dtv) {
        current_input_menu = input_main_c64dtv_menu;
    } else {
        current_input_menu = input_main_menu;
    }
#else
    current_input_menu = input_main_menu;
#endif

    while (input_device == NULL) {
        clrscr();
        cprintf("Choose input\r\n\r\n");
        for (index = 0; current_input_menu[index].key; ++index) {
            cprintf("%c: %s\r\n", current_input_menu[index].key, current_input_menu[index].displayname);
        }
        valid_key = -1;
        while (valid_key < 0) {
            key = cgetc();
            for (index = 0; current_input_menu[index].key && valid_key < 0; ++index) {
                if (key == current_input_menu[index].key) {
                    valid_key = index;
                }
            }
        }
        if (current_input_menu[valid_key].menu) {
            current_input_menu = current_input_menu[valid_key].menu;
        } else {
            input_device = current_input_menu[valid_key].device;
        }
    }

#if defined(__C64__)
    if (isc64dtv) {
        current_output_menu = output_c64dtv_menu;
    } else {
        current_output_menu = output_menu;
    }
#else
    current_output_menu = output_menu;
#endif

    while (output_device == NULL) {
        clrscr();
        cprintf("Choose output\r\n\r\n");
        for (index = 0; current_output_menu[index].key; ++index) {
            cprintf("%c: %s\r\n", current_output_menu[index].key, current_output_menu[index].displayname);
        }
        valid_key = -1;
        while (valid_key < 0) {
            key = cgetc();
            for (index = 0; current_output_menu[index].key && valid_key < 0; ++index) {
                if (key == current_output_menu[index].key) {
                    valid_key = index;
                }
            }
        }
        output_device = current_output_menu[valid_key].device;
    }

    if (output_device->function == sid_output) {
        clrscr();
        cprintf("Choose SID address range\r\n\r\n");
        for (index = 0; sid_addresses[index]; ++index) {
            cprintf("%c: $%02Xxx\r\n", 'a' + index, sid_addresses[index][0] >> 8);
            ++max_key;
        }
        valid_key = -1;
        while (valid_key < 0) {
            key = cgetc();
            if (key >= 'a' && key < 'a' + max_key) {
                valid_key = key - 'a';
            }
        }
        sid_index = valid_key;
        clrscr();
        cprintf("Choose SID address\r\n\r\n");
        max_key = 0;
        for (index = 0; sid_addresses[sid_index][index]; ++index) {
            cprintf("%c: $%04X\r\n", 'a' + index, sid_addresses[sid_index][index]);
            ++max_key;
        }
        valid_key = -1;
        while (valid_key < 0) {
            key = cgetc();
            if (key >= 'a' && key < 'a' + max_key) {
                valid_key = key - 'a';
            }
        }
        set_sid_addr(sid_addresses[sid_index][valid_key]);
    }

    clrscr();
    SEI();
    set_input_jsr(input_device->function);
    set_output_jsr(output_device->function);

    if (input_device->function_init) {
        input_device->function_init();
    }
    if (output_device->function_init) {
        output_device->function_init();
    }
    cprintf("Streaming from\r\n\r\n%s\r\n\r\nto\r\n\r\n", input_device->device_name);
    if (output_device->function == sid_output) {
        cprintf("%s at $%04X\r\n", output_device->device_name, sid_addresses[sid_index][valid_key]);
    } else {
        cprintf("%s\r\n", output_device->device_name);
    }
    stream();

    return 0;
}
