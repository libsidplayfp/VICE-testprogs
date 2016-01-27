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

/* c64/c64dtv/c128 userport addresses */
#if defined(__C128__) || defined(__C64__)
#define USERPORT_DATA 0xDD01
#define USERPORT_DDR  0xDD03
#endif

/* vic20 userport addresses */
#ifdef __VIC20__
#define USERPORT_DATA 0x9110
#define USERPORT_DDR  0x9112
#endif

/* pet userport addresses */
#ifdef __PET__
#define USERPORT_DATA 0xE841
#define USERPORT_DDR  0xE843
#endif

/* plus4 userport addresses */
#if defined(__PLUS4__) || defined(__C16__)
#define USERPORT_DATA 0xfd10
#define USERPORT_DDR  0xfdf0  /* free space, no ddr on plus4 */
#endif

/* cbm6x0/7x0 userport addresses,
   and way of poking/peeking */
#ifdef __CBM610__
#define USERPORT_DATA 0xDC01
#define USERPORT_DDR  0xDC03
#define USERPORTPOKE(x, y) pokebsys(x, y)
#define USERPORTPEEK(x) peekbsys(x)
#else
#define USERPORTPOKE(x, y) POKE(x, y)
#define USERPORTPEEK(x) PEEK(x)
#endif

/* c64 CIA1 addresses */
#define C64_CIA1_PRA          0xDC00
#define C64_CIA1_PRB          0xDC01
#define C64_CIA1_DDRA         0xDC02
#define C64_CIA1_TIMER_A_LOW  0xDC04
#define C64_CIA1_TIMER_A_HIGH 0xDC05
#define C64_CIA1_SR           0xDC0C
#define C64_CIA1_CRA          0xDC0E

/* c64 CIA2 addresses */
#define C64_CIA2_PRA          0xDD00
#define C64_CIA2_DDRA         0xDD02
#define C64_CIA2_TIMER_A_LOW  0xDD04
#define C64_CIA2_TIMER_A_HIGH 0xDD05
#define C64_CIA2_SR           0xDD0C
#define C64_CIA2_CRA          0xDD0E

/* vic20 VIA1/VIA2 addresses */
#define VIC20_VIA1_PRA        0x9111
#define VIC20_VIA2_PRB        0x9120
#define VIC20_VIA2_DDRB       0x9122

/* plus4 native and sidcart
   joystick addresses */
#define PLUS4_TED_KBD         0xFF08
#define PLUS4_SIDCART_JOY     0xFD80

/* cbm5x0 native joystick addresses */
#define CBM510_JOY_FIRE       0xDC00
#define CBM510_JOY_DIRECTIONS 0xDC01

/* C64/C128 SFX addresses */
#if defined(__C128__) || defined(__C64__)
#define SFX_ADDRESS_LATCH 0xDE00
#define SFX_ADDRESS_READ  0xDF00
#define SFX_ADDRESS_WRITE 0xDF00
#endif

/* VIC20 SFX addresses */
#if defined(__VIC20__)
#define SFX_ADDRESS_LATCH 0x9C00
#define SFX_ADDRESS_READ  0x9800
#define SFX_ADDRESS_WRITE 0x9800
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

typedef struct menu_input_s {
    char key;
    char *displayname;
    struct menu_input_s *menu;
    void (*function_init)(void);
    unsigned char (*function)(void);
} menu_input_t;

#if defined(__C64__) || defined(__C128__)
static menu_input_t input_hit1_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_hit1_input_init, sampler_2bit_hit1_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_hit1_input_init, sampler_4bit_hit1_input },
    { 0, NULL, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__)
static menu_input_t input_hit2_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_hit2_input_init, sampler_2bit_hit2_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_hit2_input_init, sampler_4bit_hit2_input },
    { 0, NULL, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__)
static menu_input_t input_hit_menu[] = {
    { '1', "port 1", input_hit1_menu, NULL, NULL },
    { '2', "port 2", input_hit2_menu, NULL, NULL },
    { 0, NULL, NULL, NULL, NULL },
};
#endif

#if defined(__C64__) || defined(__C128__)
static menu_input_t input_kingsoft1_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_kingsoft1_input_init, sampler_2bit_kingsoft1_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_kingsoft1_input_init, sampler_4bit_kingsoft1_input },
    { 0, NULL, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__)
static menu_input_t input_kingsoft2_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_kingsoft2_input_init, sampler_2bit_kingsoft2_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_kingsoft2_input_init, sampler_4bit_kingsoft2_input },
    { 0, NULL, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__)
static menu_input_t input_kingsoft_menu[] = {
    { '1', "port 1", input_kingsoft1_menu, NULL, NULL },
    { '2', "port 2", input_kingsoft2_menu, NULL, NULL },
    { 0, NULL, NULL, NULL, NULL },
};
#endif

#if defined(__C64__) || defined(__C128__)
static menu_input_t input_starbyte1_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_starbyte1_input_init, sampler_2bit_starbyte1_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_starbyte1_input_init, sampler_4bit_starbyte1_input },
    { 0, NULL, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__)
static menu_input_t input_starbyte2_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_starbyte2_input_init, sampler_2bit_starbyte2_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_starbyte2_input_init, sampler_4bit_starbyte2_input },
    { 0, NULL, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__)
static menu_input_t input_starbyte_menu[] = {
    { '1', "port 1", input_starbyte1_menu, NULL, NULL },
    { '2', "port 2", input_starbyte2_menu, NULL, NULL },
    { 0, NULL, NULL, NULL, NULL },
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) defined(__CBM610__) || defined(__PET__)
static menu_input_t input_cga1_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_cga1_input_init, sampler_2bit_cga1_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_cga1_input_init, sampler_4bit_cga1_input },
    { 0, NULL, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) defined(__CBM610__) || defined(__PET__)
static menu_input_t input_cga2_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_cga2_input_init, sampler_2bit_cga2_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_cga2_input_init, sampler_4bit_cga2_input },
    { 0, NULL, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) defined(__CBM610__) || defined(__PET__)
static menu_input_t input_cga_menu[] = {
    { '1', "port 1", input_cga1_menu, NULL, NULL },
    { '2', "port 2", input_cga2_menu, NULL, NULL },
    { 0, NULL, NULL, NULL, NULL },
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
static menu_input_t input_pet1_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_pet1_input_init, sampler_2bit_pet1_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_pet1_input_init, sampler_4bit_pet1_input },
    { 0, NULL, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
static menu_input_t input_pet2_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_pet2_input_init, sampler_2bit_pet2_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_pet2_input_init, sampler_4bit_pet2_input },
    { 0, NULL, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
static menu_input_t input_pet_menu[] = {
    { '1', "port 1", input_pet1_menu, NULL, NULL },
    { '2', "port 2", input_pet2_menu, NULL, NULL },
    { 0, NULL, NULL, NULL, NULL },
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
static menu_input_t input_oem_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_oem_input_init, sampler_2bit_oem_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_oem_input_init, sampler_4bit_oem_input },
    { 0, NULL, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
static menu_input_t input_hummer_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_hummer_input_init, sampler_2bit_hummer_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_hummer_input_init, sampler_4bit_hummer_input },
    { 0, NULL, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
static menu_input_t input_userport_joy_menu[] = {
    { 'h', "HUMMER joystick adapter", input_hummer_menu, NULL, NULL },
    { 'o', "OEM joystick adapter", input_oem_menu, NULL, NULL },
    { 'p', "PET joystick adapter", input_pet_menu, NULL, NULL },
#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) defined(__CBM610__) || defined(__PET__)
    { 'c', "CGA joystick adapter", input_cga_menu, NULL, NULL },
#endif
#if defined(__C64__) || defined(__C128__)
    { 's', "StarByte joystick adapter", input_starbyte_menu, NULL, NULL },
    { 'k', "KingSoft joystick adapter", input_kingsoft_menu, NULL, NULL },
    { 'h', "HIT joystick adapter", input_hit_menu, NULL, NULL },
#endif
    { 0, NULL, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
static menu_input_t input_userport_menu[] = {
    { 'j', "userport joystick adapter", input_userport_joy_menu, NULL, NULL },
#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__CBM610__) || defined(__PET__)
    { '4', "4 bit sampler", NULL, sampler_4bit_userport_input_init, sampler_4bit_userport_input },
#endif
#if defined(__C64__) || defined(__C128__) || defined(__CBM610__)
    { 'l', "8BSS left", NULL, sampler_8bss_left_input_init, sampler_8bss_left_input },
    { 'r', "8BSS right", NULL, sampler_8bss_right_input_init, sampler_8bss_right_input },
#endif
    { 0, NULL, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM510__) || defined(__VIC20__)
static menu_input_t input_native_joy1_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_joy1_input_init, sampler_2bit_joy1_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_joy1_input_init, sampler_4bit_joy1_input },
    { 0, NULL, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM510__)
static menu_input_t input_native_joy2_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_joy2_input_init, sampler_2bit_joy2_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_joy2_input_init, sampler_4bit_joy2_input },
    { 0, NULL, NULL, NULL, NULL }
};
#endif

#if defined(__C16__) || defined(__PLUS4__)
static menu_input_t input_sidcart_joy_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_sidcart_input_init, sampler_2bit_sidcart_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_sidcart_input_init, sampler_4bit_sidcart_input },
    { 0, NULL, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM510__)
static menu_input_t input_joy_menu[] = {
#if defined(__C64__) || defined(__C128__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM510__)
    { '1', "native port 1", input_native_joy1_menu, NULL, NULL },
    { '2', "native port 2", input_native_joy2_menu, NULL, NULL },
#endif
#if defined(__VIC20__)
    { '1', "native port", input_native_joy1_menu, NULL, NULL },
#endif
#if defined(__C16__) || defined(__PLUS4__)
    { 's', "sidcart port", input_sidcart_joy_menu, NULL, NULL },
#endif
    { 0, NULL, NULL, NULL, NULL },
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__)
static menu_input_t input_cart_menu[] = {
#if defined(__C64__) || defined(__C128__) || defined(__VIC20__)
    { 's', "sfx sound sampler", NULL, sfx_input_init, sfx_input },
#endif
#if defined(__C64__) || defined(__C128__)
    { 'd', "daisy", NULL, daisy_input_init, daisy_input },
#endif
#if defined(__C16__) || defined(__PLUS4__)
    { 'd', "digiblaster", NULL, digiblaster_input_init, digiblaster_input },
#endif
    { 0, NULL, NULL, NULL, NULL },
};
#endif

static menu_input_t input_port_menu[] = {
#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__)
    { 'c', "cartridge port", input_cart_menu, NULL, NULL },
#endif
#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM510__)
    { 'j', "joystick port", input_joy_menu, NULL, NULL },
#endif
#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
    { 'u', "userport", input_userport_menu, NULL, NULL },
#endif
    { 0, NULL, NULL, NULL, NULL }
};

static menu_input_t input_main_menu[] = {
    { 's', "software generated waveform", NULL, software_input_init, software_input },
    { 'h', "hardware device", input_port_menu, NULL, NULL },
    { 0, NULL, NULL, NULL, NULL }
};

#if defined(__C64__)
static menu_input_t input_port1_c64dtv_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_joy1_input_init, sampler_2bit_joy1_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_joy1_input_init, sampler_4bit_joy1_input },
    { 0, NULL, NULL, NULL, NULL }
};
#endif

#if defined(__C64__)
static menu_input_t input_port2_c64dtv_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_joy2_input_init, sampler_2bit_joy2_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_joy2_input_init, sampler_4bit_joy2_input },
    { 0, NULL, NULL, NULL, NULL }
};
#endif

#if defined(__C64__)
static menu_input_t input_hummer_c64dtv_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_hummer_input_init, sampler_2bit_hummer_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_hummer_input_init, sampler_4bit_hummer_input },
    { 0, NULL, NULL, NULL, NULL }
};
#endif

#if defined(__C64__)
static menu_input_t input_port_c64dtv_menu[] = {
    { '1', "native port 1", input_port1_c64dtv_menu, NULL, NULL },
    { '2', "native port 2", input_port2_c64dtv_menu, NULL, NULL },
    { 'h', "hummer joystick adapter", input_hummer_c64dtv_menu, NULL, NULL },
    { 0, NULL, NULL, NULL, NULL }
};
#endif

#if defined(__C64__)
static menu_input_t input_main_c64dtv_menu[] = {
    { 's', "software generated waveform", NULL, software_input_init, software_input },
    { 'h', "hardware device", input_port_c64dtv_menu, NULL, NULL },
    { 0, NULL, NULL, NULL, NULL }
};
#endif

typedef struct menu_output_s {
    char key;
    char *displayname;
    void (*function_init)(void);
    void (*function)(unsigned char sample);
} menu_output_t;

static menu_output_t output_menu[] = {
#if defined(__C64__) || defined(__C128__) || defined(__CBM510__) || defined(__CBM610__)
    { 's', "SID", sid_output_init, sid_output },
#endif
#if defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__PET__)
    { 's', "SIDcart", sid_output_init, sid_output },
#endif
#if defined(__C16__) || defined(__PLUS4__)
    { 't', "TED", ted_output_init, ted_output },
#endif
#if defined(__VIC20__)
    { 'v', "VIC", vic_output_init, vic_output },
#endif
#if defined(__C64__) || defined(__C128__) || defined(__VIC20__)
    { 'x', "sfx sound sampler", sfx_output_init, sfx_output },
#endif
#if defined(__C64__) || defined(__C128__) || defined(__VIC20__)
    { 'd', "digimax cartridge", digimax_cart_output_init, digimax_cart_output },
#endif
#if defined(__C64__) || defined(__C128__) || defined(__CBM610__)
    { 'u', "userport digimax device", userport_digimax_output_init, userport_digimax_output },
#endif
#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
    { '8', "userport dac", userport_dac_output_init, userport_dac_output },
#endif
#if defined(__C16__) || defined(__PLUS4__)
    { 'b', "digiblaster", digiblaster_output_init, digiblaster_output },
#endif
    { 0, NULL, NULL, NULL }
};

#if defined(__C64__)
static menu_output_t output_c64dtv_menu[] = {
    { 's', "SID", sid_output_init, sid_output },
    { 0, NULL, NULL, NULL }
};
#endif

int main(void)
{
    menu_input_t *current_input_menu = NULL;
    menu_output_t *current_output_menu = NULL;
    void (*input_function_init)(void) = NULL;
    unsigned char (*input_function)(void) = NULL;
    void (*output_function_init)(void) = NULL;
    void (*output_function)(unsigned char sample) = NULL;
    unsigned char index;
    signed char valid_key = -1;
    char key;

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

    while (input_function == NULL) {
        for (index = 0; current_input_menu[index].key; ++index) {
        }
        if (index == 1) {
            if (current_input_menu[0].menu) {
                current_input_menu = current_input_menu[0].menu;
            } else {
                input_function_init = current_input_menu[0].function_init;
                input_function = current_input_menu[0].function;
            }
        } else {
            clrscr();
            cprintf("Choose input\r\n%d\r\n", index);
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
                input_function_init = current_input_menu[valid_key].function_init;
                input_function = current_input_menu[valid_key].function;
            }
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

    while (output_function == NULL) {
        for (index = 0; current_output_menu[index].key; ++index) {
        }
        if (index == 1) {
            output_function_init = current_output_menu[0].function_init;
            output_function = current_output_menu[0].function;
        } else {
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
            output_function_init = current_output_menu[valid_key].function_init;
            output_function = current_output_menu[valid_key].function;
        }
    }

    clrscr();
    SEI();
    set_input_jsr(input_function);
    set_output_jsr(output_function);

    if (input_function_init) {
        input_function_init();
    }
    if (output_function_init) {
        output_function_init();
    }
    stream();

    return 0;
}
