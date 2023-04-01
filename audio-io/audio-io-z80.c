#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#include "z80-drivers.h"
#include "z80-defines.h"

#ifdef __C128NATIVE__
static void clrscr(void)
{
    printf("\014");
}
#endif

#ifdef __C128CPM__
static void clrscr(void)
{
    printf("\032");
}
#endif

#ifdef __C64CPM__
static void clrscr(void)
{
#asm
    ld e,12
    ld c,2
    call 5
#endasm
}
#endif

static unsigned char input_type = INPUT_NONE;
static unsigned char output_type = OUTPUT_NONE;

static void set_sid_addr(unsigned short addr) __z88dk_fastcall
{
#ifdef __C64CPM__
    set_sid_addr_asm(addr - 0x1000);
#endif

#if defined(__C128CPM__) || defined(__C128NATIVE__)
    set_sid_addr_asm(addr);
#endif
}

static void set_digimax_addr(unsigned short addr) __z88dk_fastcall
{
#ifdef __C64CPM__
    set_digimax_addr_asm(addr - 0x1000);
#endif

#if defined(__C128CPM__) || defined(__C128NATIVE__)
    set_digimax_addr_asm(addr);
#endif
}

static void input_init_function(unsigned char input_init_type) __z88dk_fastcall
{
    switch (input_init_type) {
        case INPUT_INIT_USERPORT_4BIT:
            return userport_4bit_input_init();
            break;
        case INPUT_INIT_USERPORT_JOY_4_2:
            return userport_2bit_4bit_input_init();
            break;
        case INPUT_INIT_USERPORT_CGA1:
            return userport_2bit_4bit_cga1_input_init();
            break;
        case INPUT_INIT_USERPORT_CGA2:
            return userport_2bit_4bit_cga2_input_init();
            break;
        case INPUT_INIT_USERPORT_KS1_SB2:
            return userport_2bit_4bit_ks1_sb2_input_init();
            break;
    }
}

static void output_init_function(unsigned char output_init_type) __z88dk_fastcall
{
    switch (output_init_type) {
        case OUTPUT_INIT_SID:
            return sid_output_init();
            break;
        case OUTPUT_INIT_SFX_EXPANDER:
            return sfx_expander_output_init();
            break;
        case OUTPUT_INIT_USERPORT_DIGIMAX:
            return userport_digimax_output_init();
            break;
        case OUTPUT_INIT_USERPORT_DAC:
            return userport_dac_output_init();
            break;
    }
}

/* -------------------------------------------------------------------------------------------------------- */

static unsigned sid_addresses_d4[] = { 0xd400, 0xd420, 0xd440, 0xd460, 0xd480, 0xd4a0, 0xd4c0, 0xd4e0, 0 };
#ifdef __C64CPM__
static unsigned sid_addresses_d5[] = { 0xd500, 0xd520, 0xd540, 0xd560, 0xd580, 0xd5a0, 0xd5c0, 0xd5e0, 0 };
static unsigned sid_addresses_d6[] = { 0xd600, 0xd620, 0xd640, 0xd660, 0xd680, 0xd6a0, 0xd6c0, 0xd6e0, 0 };
#endif
static unsigned sid_addresses_d7[] = { 0xd700, 0xd720, 0xd740, 0xd760, 0xd780, 0xd7a0, 0xd7c0, 0xd7e0, 0 };
static unsigned sid_addresses_de[] = { 0xde00, 0xde20, 0xde40, 0xde60, 0xde80, 0xdea0, 0xdec0, 0xdee0, 0 };
static unsigned sid_addresses_df[] = { 0xdf00, 0xdf20, 0xdf40, 0xdf60, 0xdf80, 0xdfa0, 0xdfc0, 0xdfe0, 0 };

#ifdef __C64CPM__
static unsigned *sid_addresses[] = { sid_addresses_d4, sid_addresses_d5, sid_addresses_d6, sid_addresses_d7, sid_addresses_de, sid_addresses_df, NULL };
#endif

#if defined(__C128CPM__) || defined(__C128NATIVE__)
static unsigned *sid_addresses[] = { sid_addresses_d4, sid_addresses_d7, sid_addresses_de, sid_addresses_df, NULL };
#endif

static unsigned digimax_addresses_de[] = { 0xde00, 0xde20, 0xde40, 0xde60, 0xde80, 0xdea0, 0xdec0, 0xdee0, 0 };
static unsigned digimax_addresses_df[] = { 0xdf00, 0xdf20, 0xdf40, 0xdf60, 0xdf80, 0xdfa0, 0xdfc0, 0xdfe0, 0 };

static unsigned *digimax_addresses[] = { digimax_addresses_de, digimax_addresses_df, NULL };

static unsigned shortbus_digimax_addresses_de4x[] = { 0xde40, 0xde48, 0 };

static unsigned *shortbus_digimax_addresses[] = { shortbus_digimax_addresses_de4x, NULL };

typedef struct input_device_s {
    char *device_name;
    unsigned char input_init_type;
    unsigned char input_type;
} input_device_t;

typedef struct menu_input_s {
    char key;
    char *displayname;
    struct menu_input_s *menu;
    input_device_t *device;
} menu_input_t;

typedef struct output_device_s {
    char *device_name;
    unsigned char output_init_type;
    unsigned char output_type;
} output_device_t;

typedef struct menu_output_s {
    char key;
    char *displayname;
    output_device_t *device;
} menu_output_t;

/* -------------------------------------------------------------------------------------------------------- */

static input_device_t sampler_2bit_hit1_input_device[] = {
    { "2 bit sampler on port 1 of userport HIT joy adapter", INPUT_INIT_USERPORT_JOY_4_2, INPUT_USERPORT_JOY_2 }
};

static input_device_t sampler_4bit_hit1_input_device[] = {
    { "4 bit sampler on port 1 of userport HIT joy adapter", INPUT_INIT_USERPORT_JOY_4_2, INPUT_USERPORT_JOY_4 }
};

static input_device_t sampler_2bit_hit2_input_device[] = {
    { "2 bit sampler on port 2 of userport HIT joy adapter", INPUT_INIT_USERPORT_JOY_4_2, INPUT_USERPORT_PET2 }
};

static input_device_t sampler_4bit_hit2_input_device[] = {
    { "4 bit sampler on port 2 of userport HIT joy adapter", INPUT_INIT_USERPORT_JOY_4_2, INPUT_USERPORT_4BIT }
};

static input_device_t sampler_2bit_kingsoft1_input_device[] = {
    { "2 bit sampler on port 1 of userport KingSoft joy adapter", INPUT_INIT_USERPORT_KS1_SB2, INPUT_USERPORT_KS1_2BIT }
};

static input_device_t sampler_4bit_kingsoft1_input_device[] = {
    { "4 bit sampler on port 1 of userport KingSoft joy adapter", INPUT_INIT_USERPORT_KS1_SB2, INPUT_USERPORT_KS1_4BIT }
};

static input_device_t sampler_2bit_kingsoft2_input_device[] = {
    { "2 bit sampler on port 2 of userport KingSoft joy adapter", INPUT_INIT_USERPORT_JOY_4_2, INPUT_USERPORT_KS2_2BIT }
};

static input_device_t sampler_4bit_kingsoft2_input_device[] = {
    { "4 bit sampler on port 2 of userport KingSoft joy adapter", INPUT_INIT_USERPORT_JOY_4_2, INPUT_USERPORT_KS2_4BIT }
};

static input_device_t sampler_2bit_starbyte1_input_device[] = {
    { "2 bit sampler on port 1 of userport StarByte joy adapter", INPUT_INIT_USERPORT_JOY_4_2, INPUT_USERPORT_SB1_2BIT }
};

static input_device_t sampler_4bit_starbyte1_input_device[] = {
    { "4 bit sampler on port 1 of userport StarByte joy adapter", INPUT_INIT_USERPORT_JOY_4_2, INPUT_USERPORT_SB1_4BIT }
};

static input_device_t sampler_2bit_starbyte2_input_device[] = {
    { "2 bit sampler on port 2 of userport StarByte joy adapter", INPUT_INIT_USERPORT_KS1_SB2, INPUT_USERPORT_SB2_2BIT }
};

static input_device_t sampler_4bit_starbyte2_input_device[] = {
    { "4 bit sampler on port 2 of userport StarByte joy adapter", INPUT_INIT_USERPORT_KS1_SB2, INPUT_USERPORT_SB2_4BIT }
};

static input_device_t sampler_2bit_cga1_input_device[] = {
    { "2 bit sampler on port 1 of userport CGA joy adapter", INPUT_INIT_USERPORT_CGA1, INPUT_USERPORT_JOY_2 }
};

static input_device_t sampler_4bit_cga1_input_device[] = {
    { "4 bit sampler on port 1 of userport CGA joy adapter", INPUT_INIT_USERPORT_CGA1, INPUT_USERPORT_JOY_4 }
};

static input_device_t sampler_2bit_cga2_input_device[] = {
    { "2 bit sampler on port 2 of userport CGA joy adapter", INPUT_INIT_USERPORT_CGA2, INPUT_USERPORT_JOY_2 }
};

static input_device_t sampler_4bit_cga2_input_device[] = {
    { "4 bit sampler on port 2 of userport CGA joy adapter", INPUT_INIT_USERPORT_CGA2, INPUT_USERPORT_JOY_4 }
};

static input_device_t sampler_2bit_pet1_input_device[] = {
    { "2 bit sampler on port 1 of userport PET joy adapter", INPUT_INIT_USERPORT_JOY_4_2, INPUT_USERPORT_JOY_2 }
};

static input_device_t sampler_4bit_pet1_input_device[] = {
    { "4 bit sampler on port 1 of userport PET joy adapter", INPUT_INIT_USERPORT_JOY_4_2, INPUT_USERPORT_JOY_2 }
};

static input_device_t sampler_2bit_pet2_input_device[] = {
    { "2 bit sampler on port 2 of userport PET joy adapter", INPUT_INIT_USERPORT_JOY_4_2, INPUT_USERPORT_PET2 }
};

static input_device_t sampler_4bit_pet2_input_device[] = {
    { "4 bit sampler on port 2 of userport PET joy adapter", INPUT_INIT_USERPORT_JOY_4_2, INPUT_USERPORT_4BIT }
};

static input_device_t sampler_2bit_oem_input_device[] = {
    { "2 bit sampler on userport OEM joy adapter", INPUT_INIT_USERPORT_JOY_4_2, INPUT_USERPORT_OEM2 }
};

static input_device_t sampler_4bit_oem_input_device[] = {
    { "4 bit sampler on userport OEM joy adapter", INPUT_INIT_USERPORT_JOY_4_2, INPUT_USERPORT_OEM4 }
};

static input_device_t sampler_2bit_hummer_input_device[] = {
    { "2 bit sampler on userport HUMMER joy adapter", INPUT_INIT_USERPORT_JOY_4_2, INPUT_USERPORT_JOY_2 }
};

static input_device_t sampler_4bit_hummer_input_device[] = {
    { "4 bit sampler on userport HUMMER joy adapter", INPUT_INIT_USERPORT_JOY_4_2, INPUT_USERPORT_JOY_4 }
};

static input_device_t sampler_4bit_userport_input_device[] = {
    { "4 bit userport sampler", INPUT_INIT_USERPORT_4BIT, INPUT_USERPORT_4BIT }
};

#if 0
static input_device_t sampler_8bss_left_input_device[] = {
    { "left channel of userport 8 bit stereo sampler", sampler_8bss_left_input_init, sampler_8bss_left_input }
};

static input_device_t sampler_8bss_right_input_device[] = {
    { "right channel of userport 8 bit stereo sampler", sampler_8bss_right_input_init, sampler_8bss_right_input }
};
#endif

static input_device_t sampler_2bit_joy1_input_device[] = {
    { "2 bit sampler on joystick port 1", INPUT_INIT_NONE, INPUT_JOY1_2BIT }
};

static input_device_t sampler_4bit_joy1_input_device[] = {
    { "4 bit sampler on joystick port 1", INPUT_INIT_NONE, INPUT_JOY1_4BIT }
};

static input_device_t sampler_2bit_joy2_input_device[] = {
    { "2 bit sampler on joystick port 2", INPUT_INIT_NONE, INPUT_JOY2_2BIT }
};

static input_device_t sampler_4bit_joy2_input_device[] = {
    { "4 bit sampler on joystick port 2", INPUT_INIT_NONE, INPUT_JOY2_4BIT }
};

static input_device_t sfx_input_device[] = {
    { "SFX Sound Sampler", INPUT_INIT_NONE, INPUT_SFX_SAMPLER }
};

#if 0
static input_device_t daisy_input_device[] = {
    { "DAISY", daisy_input_init, daisy_input }
};
#endif

static input_device_t software_input_device[] = {
    { "software generated waveform", INPUT_INIT_NONE, INPUT_SOFTWARE }
};

/* -------------------------------------------------------------------------------------------------------- */

static output_device_t sid_output_device[] = {
    { "SID", OUTPUT_INIT_SID, OUTPUT_SID }
};

static output_device_t sfx_output_device[] = {
    { "SFX Sound Sampler", OUTPUT_INIT_NONE, OUTPUT_SFX_SAMPLER }
};

static output_device_t sfx_sound_expander_output_device[] = {
    { "SFX Sound Expander", OUTPUT_INIT_SFX_EXPANDER, OUTPUT_SFX_EXPANDER }
};

static output_device_t digimax_cart_output_device[] = {
    { "DigiMAX cartridge", OUTPUT_INIT_NONE, OUTPUT_CART_DIGIMAX }
};

static output_device_t shortbus_digimax_output_device[] = {
    { "DigiMAX shorbus expansion", OUTPUT_INIT_NONE, OUTPUT_SHORTBUS_DIGIMAX }
};

static output_device_t userport_digimax_output_device[] = {
    { "DigiMAX userport device", OUTPUT_INIT_USERPORT_DIGIMAX, OUTPUT_USERPORT_DIGIMAX }
};

static output_device_t userport_dac_output_device[] = {
    { "userport DAC", OUTPUT_INIT_USERPORT_DAC, OUTPUT_USERPORT_DAC }
};

/* -------------------------------------------------------------------------------------------------------- */

static menu_input_t input_hit1_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_hit1_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_hit1_input_device },
    { 0, NULL, NULL, NULL }
};

static menu_input_t input_hit2_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_hit2_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_hit2_input_device },
    { 0, NULL, NULL, NULL }
};

static menu_input_t input_hit_menu[] = {
    { '1', "port 1", input_hit1_menu, NULL },
    { '2', "port 2", input_hit2_menu, NULL },
    { 0, NULL, NULL, NULL },
};

static menu_input_t input_kingsoft1_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_kingsoft1_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_kingsoft1_input_device },
    { 0, NULL, NULL, NULL }
};

static menu_input_t input_kingsoft2_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_kingsoft2_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_kingsoft2_input_device },
    { 0, NULL, NULL, NULL }
};

static menu_input_t input_kingsoft_menu[] = {
    { '1', "port 1", input_kingsoft1_menu, NULL },
    { '2', "port 2", input_kingsoft2_menu, NULL },
    { 0, NULL, NULL, NULL },
};

static menu_input_t input_starbyte1_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_starbyte1_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_starbyte1_input_device },
    { 0, NULL, NULL, NULL }
};

static menu_input_t input_starbyte2_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_starbyte2_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_starbyte2_input_device },
    { 0, NULL, NULL, NULL }
};

static menu_input_t input_starbyte_menu[] = {
    { '1', "port 1", input_starbyte1_menu, NULL },
    { '2', "port 2", input_starbyte2_menu, NULL },
    { 0, NULL, NULL, NULL },
};

static menu_input_t input_cga1_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_cga1_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_cga1_input_device },
    { 0, NULL, NULL, NULL }
};

static menu_input_t input_cga2_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_cga2_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_cga2_input_device },
    { 0, NULL, NULL, NULL }
};

static menu_input_t input_cga_menu[] = {
    { '1', "port 1", input_cga1_menu, NULL },
    { '2', "port 2", input_cga2_menu, NULL },
    { 0, NULL, NULL, NULL },
};

static menu_input_t input_pet1_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_pet1_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_pet1_input_device },
    { 0, NULL, NULL, NULL }
};

static menu_input_t input_pet2_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_pet2_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_pet2_input_device },
    { 0, NULL, NULL, NULL }
};

static menu_input_t input_pet_menu[] = {
    { '1', "port 1", input_pet1_menu, NULL },
    { '2', "port 2", input_pet2_menu, NULL },
    { 0, NULL, NULL, NULL },
};

static menu_input_t input_oem_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_oem_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_oem_input_device },
    { 0, NULL, NULL, NULL }
};

static menu_input_t input_hummer_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_hummer_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_hummer_input_device },
    { 0, NULL, NULL, NULL }
};

static menu_input_t input_userport_joy_menu[] = {
    { 'd', "C64DTV HUMMER joystick adapter", input_hummer_menu, NULL },
    { 'o', "OEM joystick adapter", input_oem_menu, NULL },
    { 'p', "PET joystick adapter", input_pet_menu, NULL },
    { 'c', "CGA joystick adapter", input_cga_menu, NULL },
    { 's', "StarByte joystick adapter", input_starbyte_menu, NULL },
    { 'k', "KingSoft joystick adapter", input_kingsoft_menu, NULL },
    { 'h', "HIT joystick adapter", input_hit_menu, NULL },
    { 0, NULL, NULL, NULL }
};

static menu_input_t input_userport_menu[] = {
    { 'j', "userport joystick adapter", input_userport_joy_menu, NULL },
    { '4', "4 bit sampler", NULL, sampler_4bit_userport_input_device },
#if 0
    { 'l', "8BSS left", NULL, sampler_8bss_left_input_device },
    { 'r', "8BSS right", NULL, sampler_8bss_right_input_device },
#endif
    { 0, NULL, NULL, NULL }
};

static menu_input_t input_native_joy1_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_joy1_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_joy1_input_device },
    { 0, NULL, NULL, NULL }
};

static menu_input_t input_native_joy2_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_joy2_input_device },
    { '4', "4 bit sampler", NULL, sampler_4bit_joy2_input_device },
    { 0, NULL, NULL, NULL }
};

static menu_input_t input_joy_menu[] = {
    { '1', "native port 1", input_native_joy1_menu, NULL },
    { '2', "native port 2", input_native_joy2_menu, NULL },
    { 0, NULL, NULL, NULL },
};

static menu_input_t input_cart_menu[] = {
    { 's', "sfx sound sampler", NULL, sfx_input_device },
#if 0
    { 'd', "daisy", NULL, daisy_input_device },
#endif
    { 0, NULL, NULL, NULL },
};

static menu_input_t input_port_menu[] = {
    { 'c', "cartridge port", input_cart_menu, NULL },
    { 'j', "joystick port", input_joy_menu, NULL },
    { 'u', "userport", input_userport_menu, NULL },
    { 0, NULL, NULL, NULL }
};

static menu_input_t input_main_menu[] = {
    { 's', "software generated waveform", NULL, software_input_device },
    { 'h', "hardware device", input_port_menu, NULL },
    { 0, NULL, NULL, NULL }
};

/* -------------------------------------------------------------------------------------------------------- */

static menu_output_t output_menu[] = {
    { 's', "SID", sid_output_device },
    { 'x', "sfx sound sampler", sfx_output_device },
    { 'e', "sfx sound expander", sfx_sound_expander_output_device },
    { 'd', "digimax cartridge", digimax_cart_output_device },
    { 'h', "IDE64 shortbus digimax expansion", shortbus_digimax_output_device },
    { 'u', "userport digimax device", userport_digimax_output_device },
    { '8', "userport dac", userport_dac_output_device },
    { 0, NULL, NULL }
};


int main(void)
{
    menu_input_t *current_input_menu = NULL;
    menu_output_t *current_output_menu = NULL;
    input_device_t *input_device = NULL;
    output_device_t *output_device = NULL;
    unsigned **addresses = NULL;
    void (*device_function)(unsigned addr) __z88dk_fastcall = NULL;
    unsigned char index;
    unsigned char sid_index;
    signed char valid_key = -1;
    char key;
    unsigned char max_key = 0;

    if (!test_os()) {
        clrscr();
#if defined(__C128CPM__) || defined(__C128NATIVE__)
        printf("this program will only run on a C128!\n");
#endif
#ifdef __C64CPM__
        printf("this program will only run on a C64!\n");
#endif
        exit(0);
    }

    current_input_menu = input_main_menu;

    while (input_device == NULL) {
        clrscr();
        printf("Choose input\n\n");
        for (index = 0; current_input_menu[index].key; ++index) {
            printf("%c: %s\n", current_input_menu[index].key, current_input_menu[index].displayname);
        }
        valid_key = -1;
        while (valid_key < 0) {
            key = (unsigned char)tolower(getkey());
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

    current_output_menu = output_menu;

    while (output_device == NULL) {
        clrscr();
        printf("Choose output\n\n");
        for (index = 0; current_output_menu[index].key; ++index) {
            printf("%c: %s\n", current_output_menu[index].key, current_output_menu[index].displayname);
        }
        valid_key = -1;
        while (valid_key < 0) {
            key = (unsigned char)tolower(getkey());
            for (index = 0; current_output_menu[index].key && valid_key < 0; ++index) {
                if (key == current_output_menu[index].key) {
                    valid_key = index;
                }
            }
        }
        output_device = current_output_menu[valid_key].device;
    }

    if (!addresses && output_device->output_type == OUTPUT_SID) {
        addresses = sid_addresses;
        device_function = set_sid_addr;
    }

    if (!addresses && output_device->output_type == OUTPUT_CART_DIGIMAX) {
        addresses = digimax_addresses;
        device_function = set_digimax_addr;
    }

    if (!addresses && output_device->output_type == OUTPUT_SHORTBUS_DIGIMAX) {
        addresses = shortbus_digimax_addresses;
        device_function = set_digimax_addr;
    }

    if (addresses) {
        clrscr();
        printf("Choose %s address range\n\n", output_device->device_name);
        for (index = 0; addresses[index]; ++index) {
            printf("%c: $%02Xxx\n", 'a' + index, addresses[index][0] >> 8);
            ++max_key;
        }
        valid_key = -1;
        while (valid_key < 0) {
            key = (unsigned char)tolower(getkey());
            if (key >= 'a' && key < 'a' + max_key) {
                valid_key = key - 'a';
            }
        }
        sid_index = valid_key;
        clrscr();
        printf("Choose %s address\n\n", output_device->device_name);
        max_key = 0;
        for (index = 0; addresses[sid_index][index]; ++index) {
            printf("%c: $%04X\n", 'a' + index, addresses[sid_index][index]);
            ++max_key;
        }
        valid_key = -1;
        while (valid_key < 0) {
            key = (unsigned char)tolower(getkey());
            if (key >= 'a' && key < 'a' + max_key) {
                valid_key = key - 'a';
            }
        }
        if (device_function) {
            device_function(addresses[sid_index][valid_key]);
        }
    }

    input_type = input_device->input_type;
    output_type = output_device->output_type;

    clrscr();
    printf("Streaming from\n\n%s\n\nto\n\n", input_device->device_name);
    if (addresses) {
        printf("%s at $%04X\n", output_device->device_name, addresses[sid_index][valid_key]);
    } else {
        printf("%s\n", output_device->device_name);
    }

    disable_irq();

    if (input_device->input_init_type != INPUT_INIT_NONE) {
        input_init_function(input_device->input_init_type);
    }
    if (output_device->output_init_type != OUTPUT_INIT_NONE) {
        output_init_function(output_device->output_init_type);
    }

    set_input_function(input_device->input_type);
    set_output_function(output_device->output_type);

    stream();

    return 0;
}
