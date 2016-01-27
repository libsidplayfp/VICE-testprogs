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
    unsigned char (*function)(unsigned char init);
} menu_input_t;

static unsigned char software_retval = 0;

static unsigned char software_input(unsigned char init)
{
    if (init) {
        return 0;
    }

    /* simple saw tooth generation */
    ++software_retval;

    return software_retval;
}

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__)
static unsigned char sfx_input(unsigned char init)
{
    unsigned char retval;

    if (init) {
        cprintf("Reading samples from sfx sound sampler at $04X\r\n", SFX_ADDRESS_READ);
        POKE(SFX_ADDRESS_LATCH, 0);
        return 0;
    }
    retval = PEEK(SFX_ADDRESS_READ);
    POKE(SFX_ADDRESS_LATCH, 0);
    return retval;
}
#endif

#if defined(__C64__) || defined(__C128__)
static unsigned char daisy_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C16__) || defined(__PLUS4__)
static unsigned char digiblaster_input(unsigned char init)
{
    if (init) {
        cprintf("Reading samples from digiblaster at $FD5F\r\n");
        return 0;
    }
    return PEEK(0xFD5F);
}
#endif

#if defined(__C64__) || defined(__C128__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM510__) || defined(__VIC20__)
static unsigned char sampler_2bit_joy1_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM510__) || defined(__VIC20__)
static unsigned char sampler_4bit_joy1_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM510__)
static unsigned char sampler_2bit_joy2_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM510__)
static unsigned char sampler_4bit_joy2_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C16__) || defined(__PLUS4__)
static unsigned char sampler_2bit_sidcart_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C16__) || defined(__PLUS4__)
static unsigned char sampler_4bit_sidcart_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__CBM610__) || defined(__PET__)
static unsigned char sampler_4bit_userport_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__) || defined(__CBM610__)
static unsigned char sampler_8bss_left_input(unsigned char init)
{
    return init;
    /* TODO */
}

static unsigned char sampler_8bss_right_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
static unsigned char sampler_2bit_hummer_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
static unsigned char sampler_4bit_hummer_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
static unsigned char sampler_2bit_oem_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
static unsigned char sampler_4bit_oem_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
static unsigned char sampler_2bit_pet1_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
static unsigned char sampler_4bit_pet1_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
static unsigned char sampler_2bit_pet2_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
static unsigned char sampler_4bit_pet2_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) defined(__CBM610__) || defined(__PET__)
static unsigned char sampler_2bit_cga1_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) defined(__CBM610__) || defined(__PET__)
static unsigned char sampler_4bit_cga1_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) defined(__CBM610__) || defined(__PET__)
static unsigned char sampler_2bit_cga2_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) defined(__CBM610__) || defined(__PET__)
static unsigned char sampler_4bit_cga2_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__)
static unsigned char sampler_2bit_starbyte1_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__)
static unsigned char sampler_4bit_starbyte1_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__)
static unsigned char sampler_2bit_starbyte2_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__)
static unsigned char sampler_4bit_starbyte2_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__)
static unsigned char sampler_2bit_kingsoft1_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__)
static unsigned char sampler_4bit_kingsoft1_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__)
static unsigned char sampler_2bit_kingsoft2_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__)
static unsigned char sampler_4bit_kingsoft2_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__)
static unsigned char sampler_2bit_hit1_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__)
static unsigned char sampler_4bit_hit1_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__)
static unsigned char sampler_2bit_hit2_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__)
static unsigned char sampler_4bit_hit2_input(unsigned char init)
{
    return init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__)
static menu_input_t input_hit1_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_hit1_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_hit1_input },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__)
static menu_input_t input_hit2_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_hit2_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_hit2_input },
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
    { '2', "2 bit sampler", NULL, sampler_2bit_kingsoft1_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_kingsoft1_input },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__)
static menu_input_t input_kingsoft2_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_kingsoft2_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_kingsoft2_input },
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
    { '2', "2 bit sampler", NULL, sampler_2bit_starbyte1_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_starbyte1_input },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__)
static menu_input_t input_starbyte2_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_starbyte2_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_starbyte2_input },
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
    { '2', "2 bit sampler", NULL, sampler_2bit_cga1_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_cga1_input },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) defined(__CBM610__) || defined(__PET__)
static menu_input_t input_cga2_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_cga2_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_cga2_input },
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
    { '2', "2 bit sampler", NULL, sampler_2bit_pet1_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_pet1_input },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
static menu_input_t input_pet2_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_pet2_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_pet2_input },
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
    { '2', "2 bit sampler", NULL, sampler_2bit_oem_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_oem_input },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
static menu_input_t input_hummer_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_hummer_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_hummer_input },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
static menu_input_t input_userport_joy_menu[] = {
    { 'h', "HUMMER joystick adapter", input_hummer_menu, NULL },
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
#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__CBM610__) || defined(__PET__)
    { '4', "4 bit sampler", NULL, sampler_4bit_userport_input },
#endif
#if defined(__C64__) || defined(__C128__) || defined(__CBM610__)
    { 'l', "8BSS left", NULL, sampler_8bss_left_input },
    { 'r', "8BSS right", NULL, sampler_8bss_right_input },
#endif
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM510__) || defined(__VIC20__)
static menu_input_t input_native_joy1_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_joy1_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_joy1_input },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__) || defined(__C128__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM510__)
static menu_input_t input_native_joy2_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_joy2_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_joy2_input },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C16__) || defined(__PLUS4__)
static menu_input_t input_sidcart_joy_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_sidcart_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_sidcart_input },
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
    { 's', "sfx sound sampler", NULL, sfx_input },
#endif
#if defined(__C64__) || defined(__C128__)
    { 'd', "daisy", NULL, daisy_input },
#endif
#if defined(__C16__) || defined(__PLUS4__)
    { 'd', "digiblaster", NULL, digiblaster_input },
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
    { 's', "software generated waveform", NULL, software_input },
    { 'h', "hardware device", input_port_menu, NULL },
    { 0, NULL, NULL, NULL }
};

#if defined(__C64__)
static menu_input_t input_port1_c64dtv_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_joy1_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_joy1_input },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__)
static menu_input_t input_port2_c64dtv_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_joy2_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_joy2_input },
    { 0, NULL, NULL, NULL }
};
#endif

#if defined(__C64__)
static menu_input_t input_hummer_c64dtv_menu[] = {
    { '2', "2 bit sampler", NULL, sampler_2bit_hummer_input },
    { '4', "4 bit sampler", NULL, sampler_4bit_hummer_input },
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
    { 's', "software generated waveform", NULL, software_input },
    { 'h', "hardware device", input_port_c64dtv_menu, NULL },
    { 0, NULL, NULL, NULL }
};
#endif

typedef struct menu_output_s {
    char key;
    char *displayname;
    void (*function)(unsigned char sample, unsigned char init);
} menu_output_t;

#if defined(__C64__) || defined(__C128__) || defined(__CBM510__) || defined(__CBM610__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__PET__)
static void sid_output(unsigned char sample, unsigned char init)
{
    sample = sample;
    init = init;
    /* TODO */
}
#endif

#if defined(__C16__) || defined(__PLUS4__)
static void ted_output(unsigned char sample, unsigned char init)
{
    sample = sample;
    init = init;
    /* TODO */
}
#endif

#if defined(__VIC20__)
static void vic_output(unsigned char sample, unsigned char init)
{
    sample = sample;
    init = init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__)
static void sfx_output(unsigned char sample, unsigned char init)
{
    if (init) {
        cprintf("Writing samples to sfx sound sampler at $%04X\r\n", SFX_ADDRESS_WRITE);
    } else {
        POKE(SFX_ADDRESS_WRITE, sample);
    }
}
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__)
static void digimax_cart_output(unsigned char sample, unsigned char init)
{
    sample = sample;
    init = init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__) || defined(__CBM610__)
static void userport_digimax_output(unsigned char sample, unsigned char init)
{
    sample = sample;
    init = init;
    /* TODO */
}
#endif

#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
static void userport_dac_output(unsigned char sample, unsigned char init)
{
    sample = sample;
    init = init;
    /* TODO */
}
#endif

#if defined(__C16__) || defined(__PLUS4__)
static void digiblaster_output(unsigned char sample, unsigned char init)
{
    if (init) {
        cprintf("Writing samples to digiblaster at $FD5E\r\n");
    } else {
        POKE(0xFD5E, sample);
    }
}
#endif

static menu_output_t output_menu[] = {
#if defined(__C64__) || defined(__C128__) || defined(__CBM510__) || defined(__CBM610__)
    { 's', "SID", sid_output },
#endif
#if defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__PET__)
    { 's', "SIDcart", sid_output },
#endif
#if defined(__C16__) || defined(__PLUS4__)
    { 't', "TED", ted_output },
#endif
#if defined(__VIC20__)
    { 'v', "VIC", vic_output },
#endif
#if defined(__C64__) || defined(__C128__) || defined(__VIC20__)
    { 'x', "sfx sound sampler", sfx_output },
#endif
#if defined(__C64__) || defined(__C128__) || defined(__VIC20__)
    { 'd', "digimax cartridge", digimax_cart_output },
#endif
#if defined(__C64__) || defined(__C128__) || defined(__CBM610__)
    { 'u', "userport digimax device", userport_digimax_output },
#endif
#if defined(__C64__) || defined(__C128__) || defined(__VIC20__) || defined(__C16__) || defined(__PLUS4__) || defined(__CBM610__) || defined(__PET__)
    { '8', "userport dac", userport_dac_output },
#endif
#if defined(__C16__) || defined(__PLUS4__)
    { 'b', "digiblaster", digiblaster_output },
#endif
    { 0, NULL, NULL }
};

#if defined(__C64__)
static menu_output_t output_c64dtv_menu[] = {
    { 's', "SID", sid_output },
    { 0, NULL, NULL }
};
#endif

int main(void)
{
    menu_input_t *current_input_menu = NULL;
    menu_output_t *current_output_menu = NULL;
    unsigned char (*input_function)(unsigned char init) = NULL;
    void (*output_function)(unsigned char sample, unsigned char init) = NULL;
    unsigned char index;
    signed char valid_key = -1;
    char key;
    unsigned char sample;

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
            output_function = current_output_menu[valid_key].function;
        }
    }

    clrscr();
    SEI();
    (void)input_function(1);
    output_function(0, 1);
    while (1) {
        sample = input_function(0);
        output_function(sample, 0);
    }

    return 0;

}
