#include <conio.h>
#include <stdio.h>
#include <6502.h>
#include <peekpoke.h>

#ifdef __CBM510__
#include <cbm510.h>
#endif

#ifdef __CBM610__
#include <cbm610.h>
#endif

/* chars used for drawing the joysticks */
#define upleft  205
#define up      194
#define upright 206
#define left    195
#define center  215

/* char for switching back to uppercase */
#define uppercase 142

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

/* draw a joystick at a certain position on the screen */
static void draw_joy(unsigned char status, unsigned char x,
                     unsigned char y, unsigned char textx,
                     unsigned char texty, char *text)
{
  if ((status & 1) && (status & 4))
      revers(1);
  cputcxy(0 + x, 0 + y, upleft);
  revers(0);

  if ((status & 1) && !(status &4) && !(status &8))
      revers(1);
  cputcxy(1 + x, 0 + y, up);
  revers(0);

  if ((status & 1) && (status & 8))
      revers(1);
  cputcxy(2 + x, 0 + y, upright);
  revers(0);

  if ((status & 4) && !(status & 1) && !(status & 2))
      revers(1);
  cputcxy(0 + x, 1 + y, left);
  revers(0);

  if (status & 16)
      revers(1);
  cputcxy(1 + x, 1 + y, center);
  revers(0);

  if ((status & 8) && !(status & 1) && !(status & 2))
      revers(1);
  cputcxy(2 + x, 1 + y, left);
  revers(0);

  if ((status & 2) && (status & 4))
      revers(1);
  cputcxy(0 + x, 2 + y, upright);
  revers(0);

  if ((status & 2) && !(status &4) && !(status &8))
      revers(1);
  cputcxy(1 + x, 2 + y, up);
  revers(0);

  if ((status & 2) && (status & 8))
      revers(1);
  cputcxy(2 + x, 2 + y, upleft);
  revers(0);

  gotoxy(0 + textx, 3 + texty);
  cprintf(text);
}

/* c64/c64dtv/c128 native joystick handling */
#if defined(__C64__) || defined(__C128__)
static unsigned char read_native_c64_joy1(void)
{
    unsigned char retval;

    POKE(C64_CIA1_PRA, 0x7F);
    retval = PEEK(C64_CIA1_PRB);
    retval &= 0x1F;
    retval ^= 0x1F;
    return retval;
}

static unsigned char read_native_c64_joy2(void)
{
    unsigned char retval;
    unsigned char temp;

    temp = PEEK(C64_CIA1_DDRA);
    POKE(C64_CIA1_DDRA, 0xFF);
    retval = PEEK(C64_CIA1_PRA);
    POKE(C64_CIA1_DDRA, temp);
    retval &= 0x1F;
    retval ^= 0x1F;
    return retval;
}
#endif

/* vic20 native joystick handling */
#ifdef __VIC20__
static unsigned char read_native_vic20_joy(void)
{
    unsigned char retval;
    unsigned char tmp;

    tmp = PEEK(VIC20_VIA1_PRA);
    retval = ((tmp & 0x1C) >> 2);
    retval |= ((tmp & 0x20) >> 1);
    POKE(VIC20_VIA2_DDRB, (PEEK(VIC20_VIA2_DDRB) & 0x7F));
    retval |= ((PEEK(VIC20_VIA2_PRB) & 0x80) >> 4);
    retval ^= 0x1F;
    return retval;
}
#endif

/* plus4 native and sidcart joystick handling */
#if defined(__PLUS4__) || defined(__C16__)
static unsigned char read_native_plus4_joy1(void)
{
    unsigned char retval;
    unsigned char temp;

    POKE(PLUS4_TED_KBD, 0xFA);
    temp = PEEK(PLUS4_TED_KBD);
    retval = temp & 0x0F;
    retval |= (temp & 64) ? 16 : 0;
    retval ^= 0x1F;
    return retval;
}

static unsigned char read_native_plus4_joy2(void)
{
    unsigned char retval;
    unsigned char temp;

    POKE(PLUS4_TED_KBD, 0xFD);
    temp = PEEK(PLUS4_TED_KBD);
    retval = temp & 0x0F;
    retval |= (temp & 128) ? 16 : 0;
    retval ^= 0x1F;
    return retval;
}

static unsigned char read_plus4_sidcart_joy(void)
{
    unsigned char retval;

    retval = PEEK(PLUS4_SIDCART_JOY) & 0x1F;
    retval ^= 0x1F;
    return retval;
}
#endif

/* cbm5x0 native joystick handling */
#ifdef __CBM510__
static unsigned char read_native_cbm510_joy1(void)
{
    unsigned char retval;

    retval = peekbsys(CBM510_JOY_DIRECTIONS) & 0x0F;
    retval |= ((peekbsys(CBM510_JOY_FIRE) & 0x40) >> 2);
    retval ^= 0x1F;
    return retval;
}

static unsigned char read_native_cbm510_joy2(void)
{
    unsigned char retval;

    retval = peekbsys(CBM510_JOY_DIRECTIONS) >> 4;
    retval |= ((peekbsys(CBM510_JOY_FIRE) & 0x80) >> 3);
    retval ^= 0x1F;
    return retval;
}
#endif

/* c64/c128 hit joystick handling */
#if defined(__C64__) || defined(__C128__)
static void setup_cnt12sp(void)
{
    POKE(USERPORT_DDR, 0);
    POKE(C64_CIA2_TIMER_A_LOW, 1);
    POKE(C64_CIA2_TIMER_A_HIGH, 0);
    POKE(C64_CIA2_CRA, 0x11);
    POKE(C64_CIA1_TIMER_A_LOW, 1);
    POKE(C64_CIA1_TIMER_A_HIGH, 0);
    POKE(C64_CIA1_CRA, 0x51);
}

static unsigned char read_c64_hit_joy1(void)
{
    unsigned char retval;
    unsigned char temp, temp2;

    setup_cnt12sp();
    temp = PEEK(C64_CIA2_PRA);
    temp2 = PEEK(C64_CIA2_DDRA);
    retval = (PEEK(USERPORT_DATA) & 0xf);
    POKE(C64_CIA2_DDRA, (PEEK(C64_CIA2_DDRA) & 0xFB));
    retval |= ((PEEK(C64_CIA2_PRA) & 4) << 2);
    POKE(C64_CIA2_PRA, temp);
    POKE(C64_CIA2_DDRA, temp2);
    retval ^= 0x1F;
    return retval;
}

static unsigned char read_c64_hit_joy2(void)
{
    unsigned char retval;

    setup_cnt12sp();
    retval = (PEEK(USERPORT_DATA) >> 4);
    POKE(C64_CIA1_SR, 0xFF);
    if (PEEK(C64_CIA2_SR) != 0)
    {
        retval |= 0x10;
    }
    retval ^= 0x1F;
    return retval;
}

static unsigned char read_c64_kingsoft_joy1(void)
{
    unsigned char retval = 0;
    unsigned char temp, temp2;

    setup_cnt12sp();
    temp = PEEK(C64_CIA2_PRA);
    temp2 = PEEK(C64_CIA2_DDRA);
    POKE(C64_CIA2_DDRA, (PEEK(C64_CIA2_DDRA) & 0xFB));
    retval |= ((PEEK(C64_CIA2_PRA) & 4) >> 2);
    retval |= ((PEEK(USERPORT_DATA) & 0x80) >> 6);
    retval |= ((PEEK(USERPORT_DATA) & 0x40) >> 4);
    retval |= ((PEEK(USERPORT_DATA) & 0x20) >> 2);
    retval |= (PEEK(USERPORT_DATA) & 0x10);
    POKE(C64_CIA2_PRA, temp);
    POKE(C64_CIA2_DDRA, temp2);
    retval ^= 0x1F;
    return retval;
}

static unsigned char read_c64_kingsoft_joy2(void)
{
    unsigned char retval = 0;

    setup_cnt12sp();
    retval |= ((PEEK(USERPORT_DATA) & 8) >> 3);
    retval |= ((PEEK(USERPORT_DATA) & 4) >> 1);
    retval |= ((PEEK(USERPORT_DATA) & 2) << 1);
    retval |= ((PEEK(USERPORT_DATA) & 1) << 3);
    POKE(C64_CIA1_SR, 0xFF);
    if (PEEK(C64_CIA2_SR) != 0)
    {
        retval |= 0x10;
    }
    retval ^= 0x1F;
    return retval;
}

static unsigned char read_c64_starbyte_joy1(void)
{
    unsigned char retval = 0;
    unsigned char temp;

    setup_cnt12sp();
    temp = PEEK(C64_CIA2_DDRA);
    POKE(C64_CIA1_SR, 0xFF);
    if (PEEK(C64_CIA2_SR) != 0)
    {
        retval |= 0x10;
    }
    retval |= ((PEEK(USERPORT_DATA) & 1) << 1);
    retval |= ((PEEK(USERPORT_DATA) & 2) << 2);
    retval |= (PEEK(USERPORT_DATA) & 4);
    retval |= ((PEEK(USERPORT_DATA) & 8) >> 3);
    POKE(C64_CIA2_DDRA, temp);
    retval ^= 0x1F;
    return retval;
}

static unsigned char read_c64_starbyte_joy2(void)
{
    unsigned char retval;
    unsigned char temp, temp2;

    setup_cnt12sp();
    temp = PEEK(C64_CIA2_PRA);
    temp2 = PEEK(C64_CIA2_DDRA);
    retval = ((PEEK(USERPORT_DATA) & 0x20) >> 4);
    retval |= ((PEEK(USERPORT_DATA) & 0x40) >> 3);
    retval |= ((PEEK(USERPORT_DATA) & 0x80) >> 5);
    retval |= (PEEK(USERPORT_DATA) & 0x10);
    POKE(C64_CIA2_DDRA, (PEEK(C64_CIA2_DDRA) & 0xFB));
    retval |= ((PEEK(C64_CIA2_PRA) & 4) >> 2);
    POKE(C64_CIA2_PRA, temp);
    POKE(C64_CIA2_DDRA, temp2);
    retval ^= 0x1F;
    return retval;
}
#endif

/* detection of c64dtv */
#if defined(__C64__) || defined(__C128__)
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

/* handling of userport joysticks
   which cannot be used by plus4
   or cbm5x0 */
#if !defined(__PLUS4__) && !defined(__C16__) && !defined(__CBM510__)
static unsigned char read_cga_joy1(void)
{
    unsigned char retval;

    USERPORTPOKE(USERPORT_DDR, 0x80);
    USERPORTPOKE(USERPORT_DATA, 0x80);
    retval = USERPORTPEEK(USERPORT_DATA);
    retval &= 0x1F;
    retval ^= 0x1F;
    return retval;
}

static unsigned char read_cga_joy2(void)
{
    unsigned char retval;

    USERPORTPOKE(USERPORT_DDR, 0x80);
    USERPORTPOKE(USERPORT_DATA, 0);
    retval = USERPORTPEEK(USERPORT_DATA);
    retval &= 0x0F;
    retval |= ((USERPORTPEEK(USERPORT_DATA) & 0x20) >> 1);
    retval ^= 0x1F;
    return retval;
}
#endif

#if !defined(__CBM510__)
static unsigned char read_pet_joy1(void)
{
    unsigned char retval;

    USERPORTPOKE(USERPORT_DDR, 0);
    retval = USERPORTPEEK(USERPORT_DATA);
    retval &= 0x0F;
    if (retval == 0x0C)
        retval = 0x0F;
    else
        retval |= 0x10;
    retval ^= 0x1F;
    return retval;
}

static unsigned char read_pet_joy2(void)
{
    unsigned char retval;

    USERPORTPOKE(USERPORT_DDR, 0);
    retval = (USERPORTPEEK(USERPORT_DATA) >> 4);
    if (retval == 0x0C)
        retval = 0x0F;
    else
        retval |= 0x10;
    retval ^= 0x1F;
    return retval;
}

static unsigned char read_hummer_joy(void)
{
    unsigned char retval;

    USERPORTPOKE(USERPORT_DDR, 0);
    retval = USERPORTPEEK(USERPORT_DATA);
    retval &= 0x1F;
    retval ^= 0x1F;
    return retval;
}

static unsigned char read_oem_joy(void)
{
    unsigned char retval;
    unsigned char temp;

    USERPORTPOKE(USERPORT_DDR, 0);
    temp = USERPORTPEEK(USERPORT_DATA);
    retval = ((temp & 128) >> 7);
    retval |= ((temp & 64) >> 5);
    retval |= ((temp & 32) >> 3);
    retval |= ((temp & 16) >> 1);
    retval |= ((temp & 8) << 1);
    retval ^= 0x1F;
    return retval;
}
#endif

/* c64/c64dtv/c128 joystick test */
#if defined(__C64__) || defined(__C128__)
int main(void)
{
    printf("%c",uppercase);
    test_c64dtv();
    bgcolor(COLOR_BLACK);
    bordercolor(COLOR_BLACK);
    textcolor(COLOR_WHITE);
    clrscr();
    SEI();
    while (1)
    {
        draw_joy(read_native_c64_joy1(), 2, 0, 0, 0, "native1");
        draw_joy(read_native_c64_joy2(), 10, 0, 8, 0, "native2");
        draw_joy(read_hummer_joy(), 18, 0, 16, 0, "hummer");
        draw_joy(read_cga_joy1(), 2, 5, 1, 5, "cga-1");
        draw_joy(read_cga_joy2(), 10, 5, 9, 5, "cga-2");
        draw_joy(read_oem_joy(), 18, 5, 18, 5, "oem");
        draw_joy(read_pet_joy1(), 2, 10, 1, 10, "pet-1");
        draw_joy(read_pet_joy2(), 10, 10, 9, 10, "pet-2");
        if (isc64dtv == 0)
        {
            draw_joy(read_c64_hit_joy1(), 2, 15, 1, 15, "hit-1");
            draw_joy(read_c64_hit_joy2(), 10, 15, 9, 15, "hit-2");
            draw_joy(read_c64_kingsoft_joy1(), 18, 15, 17, 15, "king1");
            draw_joy(read_c64_kingsoft_joy2(), 26, 15, 25, 15, "king2");
            draw_joy(read_c64_starbyte_joy1(), 18, 10, 17, 10, "star1");
            draw_joy(read_c64_starbyte_joy2(), 26, 10, 25, 10, "star2");
        }
    }
}
#endif

/* cbm5x0 joystick test */
#ifdef __CBM510__
int main(void)
{
    printf("%c",uppercase);
    bgcolor(COLOR_BLACK);
    bordercolor(COLOR_BLACK);
    textcolor(COLOR_WHITE);
    clrscr();
    SEI();
    while (1)
    {
        draw_joy(read_native_cbm510_joy1(), 2, 0, 0, 0, "native1");
        draw_joy(read_native_cbm510_joy2(), 10, 0, 8, 0, "native2");
    }
}
#endif

/* cbm6x0/7x0 joystick test */
#ifdef __CBM610__
int main(void)
{
    printf("%c",uppercase);
    clrscr();
    SEI();
    while (1)
    {
        draw_joy(read_cga_joy1(), 2, 0, 1, 0, "cga-1");
        draw_joy(read_cga_joy2(), 10, 0, 9, 0, "cga-2");
        draw_joy(read_hummer_joy(), 18, 0, 16, 0, "hummer");
        draw_joy(read_pet_joy1(), 2, 5, 1, 5, "pet-1");
        draw_joy(read_pet_joy2(), 10, 5, 9, 5, "pet-2");
        draw_joy(read_oem_joy(), 18, 5, 18, 5, "oem");
    }
}
#endif

/* pet joystick test */
#ifdef __PET__
int main(void)
{
    printf("%c",uppercase);
    clrscr();
    SEI();
    while (1)
    {
        draw_joy(read_cga_joy1(), 2, 0, 1, 0, "cga-1");
        draw_joy(read_cga_joy2(), 10, 0, 9, 0, "cga-2");
        draw_joy(read_hummer_joy(), 18, 0, 16, 0, "hummer");
        draw_joy(read_pet_joy1(), 2, 5, 1, 5, "pet-1");
        draw_joy(read_pet_joy2(), 10, 5, 9, 5, "pet-2");
        draw_joy(read_oem_joy(), 18, 5, 18, 5, "oem");
    }
}
#endif

/* c16/c232/plus4 joystick test */
#if defined(__C16__) || defined(__PLUS4__)
int main(void)
{
    printf("%c",uppercase);
    bgcolor(COLOR_BLACK);
    bordercolor(COLOR_BLACK);
    textcolor(COLOR_WHITE);
    clrscr();
    SEI();
    while (1)
    {
        draw_joy(read_native_plus4_joy1(), 2, 0, 0, 0, "native1");
        draw_joy(read_native_plus4_joy2(), 10, 0, 8, 0, "native2");
        draw_joy(read_plus4_sidcart_joy(), 18, 0, 16, 0, "sidcart");
        draw_joy(read_pet_joy1(), 2, 5, 1, 5, "pet-1");
        draw_joy(read_pet_joy2(), 10, 5, 9, 5, "pet-2");
        draw_joy(read_oem_joy(), 18, 5, 18, 5, "oem");
        draw_joy(read_hummer_joy(), 2, 10, 0, 10, "hummer");
    }
}
#endif

/* vic20 joystick test */
#ifdef __VIC20__
int main(void)
{
    printf("%c",uppercase);
    bgcolor(COLOR_BLACK);
    bordercolor(COLOR_BLACK);
    textcolor(COLOR_WHITE);
    clrscr();
    SEI();
    while (1)
    {
        draw_joy(read_native_vic20_joy(), 2, 0, 0, 0, "native");
        draw_joy(read_cga_joy1(), 10, 0, 9, 0, "cga-1");
        draw_joy(read_cga_joy2(), 18, 0, 17, 0, "cga-2");
        draw_joy(read_pet_joy1(), 2, 5, 1, 5, "pet-1");
        draw_joy(read_pet_joy2(), 10, 5, 9, 5, "pet-2");
        draw_joy(read_oem_joy(), 18, 5, 18, 5, "oem");
        draw_joy(read_hummer_joy(), 2, 10, 0, 10, "hummer");
    }
}
#endif
