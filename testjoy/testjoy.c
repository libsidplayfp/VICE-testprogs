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

#define SNESPAD_BUTTON_B        0
#define SNESPAD_BUTTON_Y        1
#define SNESPAD_BUTTON_SELECT   2
#define SNESPAD_BUTTON_START    3
#define SNESPAD_UP              4
#define SNESPAD_DOWN            5
#define SNESPAD_LEFT            6
#define SNESPAD_RIGHT           7
#define SNESPAD_BUTTON_A        8
#define SNESPAD_BUTTON_X        9
#define SNESPAD_BUMPER_LEFT    10
#define SNESPAD_BUMPER_RIGHT   11

/* c64/c64dtv/c128 userport addresses */
#if defined(__C128__) || defined(__C64__)
#define USERPORT_DATA 0xDD01
#define USERPORT_DDR  0xDD03
#define POTX_DATA     0xD419
#define POTY_DATA     0xD41A
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
#define POTX_DATA     0xFD59
#define POTY_DATA     0xFD5A
#endif

/* cbm5x0 sid addresses */
#ifdef __CBM510__
#define POTX_DATA     0xDA19
#define POTY_DATA     0xDA1A
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
#define C64_CIA1_DDRB         0xDC03
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
#define VIC20_VIA1_DDRA       0x9113
#define VIC20_VIA2_PRB        0x9120
#define VIC20_VIA2_PRA        0x9121
#define VIC20_VIA2_DDRB       0x9122
#define VIC20_VIA2_DDRA       0x9123

/* plus4 native and sidcart
   joystick addresses */
#define PLUS4_TED_KBD         0xFF08
#define PLUS4_SIDCART_JOY     0xFD80
#define PLUS4_KEY_SELECT      0xFD30

/* cbm5x0 native joystick addresses */
#define CBM510_CIA2_PRA       0xDC00
#define CBM510_CIA2_PRB       0xDC01
#define CBM510_CIA2_DDRA      0xDC02
#define CBM510_CIA2_DDRB      0xDC03

/* cbm6x0 cia addresses */
#define CBM6x0_CIA2_PRA       0xDC00
#define CBM6x0_CIA2_DDRA      0xDC02

/* pet keyboard scan addresses */
#define PET_KEY_INDEX_SEL     0xE810
#define PET_KEY_ROW           0xE812

/* cbm5x0/6x0/7x0 keyboard scan addresses */
#define CBM2_KEY_ROW_SEL1     0xDF00
#define CBM2_KEY_ROW_SEL2     0xDF01
#define CBM2_KEY_ROW_READ     0xDF02

/* C64/C128/C64DTV display page numbers */
#define PAGE_C64_JOYSTICKS          0
#define PAGE_C64_JOYPORT_SNESPADS   1
#define PAGE_C64_PETSCII_SNESPAD    2
#define PAGE_C64_USERPORT_SNESPADS  3
#define PAGE_C64_PROTOPADS          4
#define PAGE_C64_8JOY               5
#define PAGE_C64_INCEPTION          6
#define PAGE_C64_MAX                7

/* CBM5x0 display page numbers */
#define PAGE_CBM5x0_JOYSTICKS    0
#define PAGE_CBM5x0_SNESPADS     1
#define PAGE_CBM5x0_8JOY         2
#define PAGE_CBM5x0_INCEPTION    3
#define PAGE_CBM5x0_MAX          4

/* CBM6x0 display page numbers */
#define PAGE_CBM6x0_JOYSTICKS           0
#define PAGE_CBM6x0_PETSCII_SNESPAD     1
#define PAGE_CBM6x0_USERPORT_SNESPADS   2
#define PAGE_CBM6x0_MAX                 3

/* PET display page numbers */
#define PAGE_PET_JOYSTICKS    0
#define PAGE_PET_SNESPADS     1
#define PAGE_PET_MAX          2

/* VIC20 display page numbers */
#define PAGE_VIC20_JOYSTICKS          0
#define PAGE_VIC20_SNESPADS           1
#define PAGE_VIC20_PROTOPADS          2
#define PAGE_VIC20_USERPORT_SNESPADS  3
#define PAGE_VIC20_8JOY               4
#define PAGE_VIC20_INCEPTION          5
#define PAGE_VIC20_MAX                6

#if !defined(__PLUS4__) && !defined(__C16__)
static unsigned short snes_status[8];
#endif

#if !defined(__PLUS4__) && !defined(__C16__) && !defined(__PET__) && !defined(__CBM610__)
static unsigned char joy8_status[8];
#endif

#if !defined(__PLUS4__) && !defined(__C16__)
static unsigned char current_page = 0;

#ifdef __PET__
static char *page_message = "1> next  3> previous";
#else
static char *page_message = "f1> next  f3> previous";
#endif
#endif

/* draw a joystick at a certain position on the screen */
static void draw_joy(unsigned char status, unsigned char x,
                     unsigned char y, unsigned char textx,
                     unsigned char texty, char *text,
                     unsigned char extra_buttons)
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

#if defined(__C128__) || defined(__C64__) || defined(__PLUS4__) || defined(__C16__) || defined(__CBM510__)
  if (extra_buttons) {
      if (status & 32)
          revers(1);
      cputcxy(-1 + x, 1 + y, center);
      revers(0);

      if (status & 64)
          revers(1);
      cputcxy(3 + x, 1 + y, center);
      revers(0);
  }
#endif

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

#if !defined(__PLUS4__) && !defined(__C16__)
/* draw a snes pad at a certain position on the screen */
static void draw_snes(unsigned short status, unsigned char x,
                      unsigned char y, char *text)
{
  gotoxy(x, y);
  cprintf(text);

  if (status & (1 << SNESPAD_UP))
    revers(1);
  cputcxy(x + 1, y + 2, 'u');
  revers(0);

  if (status & (1 << SNESPAD_LEFT))
    revers(1);
  cputcxy(x, y + 3, 'l');
  revers(0);

  if (status & (1 << SNESPAD_RIGHT))
    revers(1);
  cputcxy(x + 2, y + 3, 'r');
  revers(0);

  if (status & (1 << SNESPAD_DOWN))
    revers(1);
  cputcxy(x + 1, y + 4, 'd');
  revers(0);

  if (status & (1 << SNESPAD_BUMPER_LEFT))
    revers(1);
  cputcxy(x + 4, y + 3, 'b');
  cputcxy(x + 5, y + 3, 'l');
  revers(0);

  if (status & (1 << SNESPAD_BUTTON_SELECT))
    revers(1);
  cputcxy(x + 7, y + 3, 's');
  cputcxy(x + 8, y + 3, 'l');
  revers(0);

  if (status & (1 << SNESPAD_BUTTON_START))
    revers(1);
  cputcxy(x + 10, y + 3, 's');
  cputcxy(x + 11, y + 3, 't');
  revers(0);

  if (status & (1 << SNESPAD_BUMPER_RIGHT))
    revers(1);
  cputcxy(x + 13, y + 3, 'b');
  cputcxy(x + 14, y + 3, 'r');
  revers(0);

  if (status & (1 << SNESPAD_BUTTON_Y))
    revers(1);
  cputcxy(x + 16, y + 3, 'y');
  revers(0);

  if (status & (1 << SNESPAD_BUTTON_X))
    revers(1);
  cputcxy(x + 17, y + 2, 'x');
  revers(0);

  if (status & (1 << SNESPAD_BUTTON_B))
    revers(1);
  cputcxy(x + 17, y + 4, 'b');
  revers(0);

  if (status & (1 << SNESPAD_BUTTON_A))
    revers(1);
  cputcxy(x + 18, y + 3, 'a');
  revers(0);
}
#endif

/* check keys to see if we need to switch pages (c64/c64dtv/c128) */
#if defined(__C64__) || defined(__C128__)
unsigned char row_scan[8] = { 0x7F, 0xBF, 0xDF, 0xEF, 0xF7, 0xFB, 0xFD, 0xFE };

static unsigned char isc64dtv = 0;

/* returns which key is pressed:
   0 = no key
   1 = F1
   2 = F3
 */
static unsigned char check_keys(void)
{
    unsigned char val = 0xFF;
    unsigned char col = 0;
    unsigned char row = 0;
    unsigned char i;

    POKE(C64_CIA1_DDRB, 0x00);
    POKE(C64_CIA1_DDRA, 0xFF);
    POKE(C64_CIA1_PRA, 0x00);
    col = PEEK(C64_CIA1_PRB);
    if (col != 0xFF) {
        for (i = 0; i < 8 && val == 0xFF; i++) {
            row = row_scan[i];
            POKE(C64_CIA1_PRA, row);
            val = PEEK(C64_CIA1_PRB);
        }
    }

    if (val != 0xFF) {
        /* 'F1' was pressed */
        if (col == 0xEF && row == 0xFE) {
            return 1;
        }

        /* 'F3' was pressed */
        if ((col == 0xDF || col == 0xBF) && row == 0xFE) {
            return 2;
        }
    }
    return 0;
}
#endif

/* check keys to see if we need to switch pages (vic20) */
#if defined(__VIC20__)
unsigned char row_scan[8] = { 0x7F, 0xBF, 0xDF, 0xEF, 0xF7, 0xFB, 0xFD, 0xFE };

/* returns which key is pressed:
   0 = no key
   1 = F1
   2 = F3
 */
static unsigned char check_keys(void)
{
    unsigned char val = 0xFF;
    unsigned char col = 0;
    unsigned char row = 0;
    unsigned char i;

    POKE(VIC20_VIA2_DDRA, 0x00);
    POKE(VIC20_VIA2_DDRB, 0xFF);
    POKE(VIC20_VIA2_PRB, 0x00);
    col = PEEK(VIC20_VIA2_PRA);
    if (col != 0xFF) {
        for (i = 0; i < 8 && val == 0xFF; i++) {
            row = row_scan[i];
            POKE(VIC20_VIA2_PRB, row);
            val = PEEK(VIC20_VIA2_PRA);
        }
    }

    if (val != 0xFF) {

        /* 'F1' was pressed */
        if (col == 0x7F && row == 0xEF) {
            return 1;
        }

        /* 'F3' was pressed */
        if (col == 0x7F && row == 0xDF) {
            return 2;
        }
    }
    return 0;
}
#endif

/* currently not used */
#if 0
/* check keys to see if we need to switch pages (c16/plus4) */
#if defined(__PLUS4__) || defined(__C16__)
unsigned char row_scan[8] = { 0x7F, 0xBF, 0xDF, 0xEF, 0xF7, 0xFB, 0xFD, 0xFE };

/* returns which key is pressed:
   0 = no key
   1 = F1
   2 = F3
 */
static unsigned char check_keys(void)
{
    unsigned char row = 0;
    unsigned char val = 0xFF;
    unsigned char i;

    for (i = 0; i < 8 && val == 0xFF; i++) {
        row = row_scan[i];
        POKE(PLUS4_KEY_SELECT, row);
        POKE(PLUS4_TED_KBD, 0xFF);
        val = PEEK(PLUS4_TED_KBD);
    }

    if (val != 0xFF) {
        /* 'F1' was pressed */
        if (val == 0xEF && row == 0xFE) {
            return 1;
        }

        /* 'F3' was pressed */
        if (val == 0xBF && row == 0xFE) {
            return 2;
        }
    }
    return 0;
}
#endif
#endif

/* check keys to see if we need to switch pages (pet) */
#if defined(__PET__)
/* returns which key is pressed:
   0 = no key
   1 = 1
   2 = 3
 */
static unsigned char check_keys(void)
{
    unsigned char row = 0;
    unsigned char val = 0xFF;
    unsigned char tmp = PEEK(PET_KEY_INDEX_SEL) & 0xf0;

    for (row = 0; row < 16 && val == 0xFF; row++) {
        POKE(PET_KEY_INDEX_SEL, tmp | row);
        val = PEEK(PET_KEY_ROW);
    }

    if (val != 0xFF) {
        /* '1' was pressed */
        if (row == 2 && val == 0xFE) {
            return 1;
        }

        /* '3' was pressed */
        if (row == 10 && val == 0xFD) {
            return 2;
        }
    }
    return 0;
}
#endif

/* check keys to see if we need to switch pages (pet) */
#if defined(__CBM510__) || defined(__CBM610__)
unsigned char row_scan[8] = { 0x7F, 0xBF, 0xDF, 0xEF, 0xF7, 0xFB, 0xFD, 0xFE };

/* returns which key is pressed:
   0 = no key
   1 = F1
   2 = F3
 */
unsigned char check_keys(void)
{
    unsigned char row = 0;
    unsigned char val = 0x3F;
    unsigned char i;

    pokebsys(CBM2_KEY_ROW_SEL2, 0xFF);
    for (i = 0; i < 8 && val == 0x3F; i++) {
        row++;
        pokebsys(CBM2_KEY_ROW_SEL1, row_scan[i]);
        val = peekbsys(CBM2_KEY_ROW_READ) & 0x3F;
    }
    if (val == 0x3F) {
        pokebsys(CBM2_KEY_ROW_SEL1, 0xFF);
        for (i = 0; i < 8 && val == 0x3F; i++) {
            row++;
            pokebsys(CBM2_KEY_ROW_SEL2, row_scan[i]);
            val = peekbsys(CBM2_KEY_ROW_READ) & 0x3F;
        }
    }

    if (val != 0x3F) {
        /* 'F1' was pressed */
        if (row == 0x10 && val == 0x3E) {
            return 1;
        }

        /* 'F3' was pressed */
        if (row == 0x0E && val == 0x3E) {
            return 2;
        }
    }
    return 0;
}
#endif

/* c64/c64dtv/c128 native joystick handling */
#if defined(__C64__) || defined(__C128__)
static void read_inception_c64_joy1(void)
{
    unsigned char i;

    POKE(C64_CIA1_DDRB, 0x1F);
    POKE(C64_CIA1_PRB, 0x00);
    POKE(C64_CIA1_DDRB, 0x10);
    for (i = 0; i < 8; i++) {
        POKE(C64_CIA1_PRB, 0x10);
        joy8_status[i] = PEEK(C64_CIA1_PRB) << 4;
        POKE(C64_CIA1_PRB, 0);
        joy8_status[i] |= PEEK(C64_CIA1_PRB);
    }
    for (i = 0; i < 8; i++) {
        POKE(C64_CIA1_PRB, 0x10);
        POKE(C64_CIA1_PRB, 0);
    }
}

static void read_inception_c64_joy2(void)
{
    unsigned char i;

    POKE(C64_CIA1_DDRA, 0x1F);
    POKE(C64_CIA1_PRA, 0x00);
    POKE(C64_CIA1_DDRA, 0x10);
    for (i = 0; i < 8; i++) {
        POKE(C64_CIA1_PRA, 0x10);
        joy8_status[i] = PEEK(C64_CIA1_PRA) << 4;
        POKE(C64_CIA1_PRA, 0);
        joy8_status[i] |= PEEK(C64_CIA1_PRA);
    }
    for (i = 0; i < 8; i++) {
        POKE(C64_CIA1_PRB, 0x10);
        POKE(C64_CIA1_PRB, 0);
    }
}

static void read_spaceballs_c64_joy1(void)
{
    unsigned char i;

    POKE(C64_CIA1_DDRB, 0);
    POKE(USERPORT_DDR, 0xFF);

    for (i = 0; i < 8; ++i) {
        POKE(USERPORT_DATA, row_scan[7 - i]);
        joy8_status[i] = (PEEK(C64_CIA1_PRB) & 0x1F) ^ 0x1F;
    }
}

static void read_spaceballs_c64_joy2(void)
{
    unsigned char i;

    for (i = 0; i < 8; ++i) {
        POKE(USERPORT_DATA, row_scan[7 - i]);
        joy8_status[i] = (PEEK(C64_CIA1_PRA) & 0x1F) ^ 0x1F;
    }
}

static void read_multijoy_c64_joy1(void)
{
    unsigned char i;

    POKE(C64_CIA1_DDRA, 0x1F);    
    POKE(C64_CIA1_DDRB, 0);
    for (i = 0; i < 8; ++i) {
        POKE(C64_CIA1_PRA, i);
        joy8_status[i] = (PEEK(C64_CIA1_PRB) & 0x1F) ^ 0x1F;
    }
}

static void read_multijoy_c64_joy2(void)
{
    unsigned char i;

    POKE(C64_CIA1_DDRB, 0x1F);    
    POKE(C64_CIA1_DDRA, 0);
    for (i = 0; i < 8; ++i) {
        POKE(C64_CIA1_PRB, i);
        joy8_status[i] = (PEEK(C64_CIA1_PRA) & 0x1F) ^ 0x1F;
    }
}

static void read_snes_c64_joy1(void)
{
    unsigned char i;
    unsigned char data;

    POKE(C64_CIA1_DDRA, 0x00);
    POKE(C64_CIA1_DDRB, 0xF8);
    POKE(C64_CIA1_PRB, 0x10);
    POKE(C64_CIA1_PRB, 0x00);

    snes_status[0] = 0;
    snes_status[1] = 0;
    snes_status[2] = 0;

    for (i = 0; i < 12; i++) {
        data = ~PEEK(C64_CIA1_PRB);
        snes_status[0] |= ((data & 0x01) << i);
        snes_status[1] |= (((data & 0x02) >> 1) << i);
        snes_status[2] |= (((data & 0x04) >> 2) << i);
        POKE(C64_CIA1_PRB, 0x08);
        POKE(C64_CIA1_PRB, 0x00);
    }
}

static void read_snes_c64_joy2(void)
{
    unsigned char i;
    unsigned char data;

    POKE(C64_CIA1_DDRB, 0x00);
    POKE(C64_CIA1_DDRA, 0xF8);
    POKE(C64_CIA1_PRA, 0x10);
    POKE(C64_CIA1_PRA, 0x00);

    snes_status[0] = 0;
    snes_status[1] = 0;
    snes_status[2] = 0;

    for (i = 0; i < 12; i++) {
        data = ~PEEK(C64_CIA1_PRA);
        snes_status[0] |= ((data & 0x01) << i);
        snes_status[1] |= (((data & 0x02) >> 1) << i);
        snes_status[2] |= (((data & 0x04) >> 2) << i);
        POKE(C64_CIA1_PRA, 0x08);
        POKE(C64_CIA1_PRA, 0x00);
    }
}

static void read_protopad_c64_joy1(void)
{
    unsigned char b1;
    unsigned char b2;
    unsigned char b3;
    unsigned char b4;

    POKE(C64_CIA1_DDRB, 0xFF);
    POKE(C64_CIA1_PRB, 0x00);
    POKE(C64_CIA1_DDRB, 0xF8);
    POKE(C64_CIA1_PRB, 0x08);
    b1 = ~PEEK(C64_CIA1_PRB) & 7;
    POKE(C64_CIA1_PRB, 0x00);
    b2 = ~PEEK(C64_CIA1_PRB) & 7;
    POKE(C64_CIA1_PRB, 0x08);
    b3 = ~PEEK(C64_CIA1_PRB) & 7;
    POKE(C64_CIA1_PRB, 0x00);
    b4 = ~PEEK(C64_CIA1_PRB) & 7;
    POKE(C64_CIA1_DDRB, 0x00);
    snes_status[0] = (b1 & 0x04) ? 0x0001 : 0x0000;
    snes_status[0] |= (b4 & 0x02) ? 0x0002 : 0x0000;
    snes_status[0] |= (b3 & 0x02) ? 0x0004 : 0x0000;
    snes_status[0] |= (b3 & 0x04) ? 0x0008 : 0x0000;
    snes_status[0] |= (b2 & 0x01) ? 0x0010 : 0x0000;
    snes_status[0] |= (b2 & 0x02) ? 0x0020 : 0x0000;
    snes_status[0] |= (b2 & 0x04) ? 0x0040 : 0x0000;
    snes_status[0] |= (b1 & 0x01) ? 0x0080 : 0x0000;
    snes_status[0] |= (b1 & 0x02) ? 0x0100 : 0x0000;
    snes_status[0] |= (b4 & 0x01) ? 0x0200 : 0x0000;
    snes_status[0] |= (b4 & 0x04) ? 0x0400 : 0x0000;
    snes_status[0] |= (b3 & 0x01) ? 0x0800 : 0x0000;
}

static void read_protopad_c64_joy2(void)
{
    unsigned char b1;
    unsigned char b2;
    unsigned char b3;
    unsigned char b4;

    POKE(C64_CIA1_DDRA, 0xFF);
    POKE(C64_CIA1_PRA, 0x00);
    POKE(C64_CIA1_DDRA, 0xF8);
    POKE(C64_CIA1_PRA, 0x08);
    b1 = ~PEEK(C64_CIA1_PRA) & 7;
    POKE(C64_CIA1_PRA, 0x00);
    b2 = ~PEEK(C64_CIA1_PRA) & 7;
    POKE(C64_CIA1_PRA, 0x08);
    b3 = ~PEEK(C64_CIA1_PRA) & 7;
    POKE(C64_CIA1_PRA, 0x00);
    b4 = ~PEEK(C64_CIA1_PRA) & 7;
    POKE(C64_CIA1_DDRA, 0x00);
    snes_status[0] = (b1 & 0x04) ? 0x0001 : 0x0000;
    snes_status[0] |= (b4 & 0x02) ? 0x0002 : 0x0000;
    snes_status[0] |= (b3 & 0x02) ? 0x0004 : 0x0000;
    snes_status[0] |= (b3 & 0x04) ? 0x0008 : 0x0000;
    snes_status[0] |= (b2 & 0x01) ? 0x0010 : 0x0000;
    snes_status[0] |= (b2 & 0x02) ? 0x0020 : 0x0000;
    snes_status[0] |= (b2 & 0x04) ? 0x0040 : 0x0000;
    snes_status[0] |= (b1 & 0x01) ? 0x0080 : 0x0000;
    snes_status[0] |= (b1 & 0x02) ? 0x0100 : 0x0000;
    snes_status[0] |= (b4 & 0x01) ? 0x0200 : 0x0000;
    snes_status[0] |= (b4 & 0x04) ? 0x0400 : 0x0000;
    snes_status[0] |= (b3 & 0x01) ? 0x0800 : 0x0000;
}

static unsigned char read_native_c64_joy1(void)
{
    unsigned char retval;

    retval = PEEK(C64_CIA1_PRB);
    POKE(C64_CIA1_DDRA, 0xff);
    POKE(C64_CIA1_PRA, 0x40);
    retval &= 0x1F;
    if (PEEK(POTX_DATA)) {
        retval |= 0x20;
    }
    if (PEEK(POTY_DATA)) {
        retval |= 0x40;
    }
    retval ^= 0x7F;
    return retval;
}

static unsigned char read_native_c64_joy2(void)
{
    unsigned char retval;
    unsigned char temp;

    POKE(C64_CIA1_DDRA, 0);
    retval = PEEK(C64_CIA1_PRA);
    retval &= 0x1F;
    POKE(C64_CIA1_DDRA, 0xFF);
    POKE(C64_CIA1_PRA, 0x80);
    if (PEEK(POTX_DATA)) {
        retval |= 0x20;
    }
    if (PEEK(POTY_DATA)) {
        retval |= 0x40;
    }
    POKE(C64_CIA1_DDRA, temp);
    retval ^= 0x7F;
    return retval;
}
#endif

/* vic20 native joystick handling */
#ifdef __VIC20__
static void read_inception_vic20_joy(void)
{
    unsigned char i;
    unsigned char ddra = PEEK(VIC20_VIA1_DDRA);
    unsigned char ddrb = PEEK(VIC20_VIA2_DDRB);

    POKE(VIC20_VIA2_DDRB, 0x80);
    POKE(VIC20_VIA1_DDRA, 0x3C);
    POKE(VIC20_VIA2_PRB, 0);
    POKE(VIC20_VIA1_PRA, 0);
    POKE(VIC20_VIA2_DDRB, 0);
    POKE(VIC20_VIA1_DDRA, 0x20);
    for (i = 0; i < 8; i++) {
        POKE(VIC20_VIA1_PRA, 0x20);
        joy8_status[i] = PEEK(VIC20_VIA2_PRB) & 0x80;
        joy8_status[i] |= (PEEK(VIC20_VIA1_PRA) & 0x1C) << 3;
        POKE(VIC20_VIA1_PRA, 0);
        joy8_status[i] |= (PEEK(VIC20_VIA2_PRB) & 0x80) >> 4;
        joy8_status[i] |= (PEEK(VIC20_VIA1_PRA) & 0x1C) >> 2;
    }
    for (i = 0; i < 8; i++) {
        POKE(VIC20_VIA1_PRA, 0x20);
        POKE(VIC20_VIA1_PRA, 0);
    }
    POKE(VIC20_VIA2_DDRB, ddrb);
    POKE(VIC20_VIA1_DDRA, ddra);
}

static void read_spaceballs_vic20_joy(void)
{
    unsigned char i;
    unsigned char tmp;

    POKE(USERPORT_DDR, 0xFF);

    for (i = 0; i < 8; ++i) {
        POKE(USERPORT_DATA, row_scan[7 - i]);
        tmp = PEEK(VIC20_VIA1_PRA);
        joy8_status[i] = ((tmp & 0x1C) >> 2);
        joy8_status[i] |= ((tmp & 0x20) >> 1);
        POKE(VIC20_VIA2_DDRB, (PEEK(VIC20_VIA2_DDRB) & 0x7F));
        joy8_status[i] |= ((PEEK(VIC20_VIA2_PRB) & 0x80) >> 4);
        joy8_status[i] ^= 0x1F;
    }
}

static void read_snes_vic20_joy(void)
{
    unsigned char i;
    unsigned char data;
    unsigned char ddra = PEEK(VIC20_VIA1_DDRA);
    unsigned char ddrb = PEEK(VIC20_VIA2_DDRB);

    POKE(VIC20_VIA1_DDRA, 0x20);
    POKE(VIC20_VIA2_DDRB, 0x80);

    POKE(VIC20_VIA1_PRA, 0x20);
    POKE(VIC20_VIA1_PRA, 0x00);

    snes_status[0] = 0;
    snes_status[1] = 0;
    snes_status[2] = 0;

    for (i = 0; i < 12; i++) {
        data = ~PEEK(VIC20_VIA1_PRA);
        snes_status[0] |= (((data & 0x04) >> 2) << i);
        snes_status[1] |= (((data & 0x08) >> 3) << i);
        snes_status[2] |= (((data & 0x10) >> 4) << i);
        POKE(VIC20_VIA2_PRB, 0x80);
        POKE(VIC20_VIA2_PRB, 0x00);
    }
    POKE(VIC20_VIA1_DDRA, ddra);
    POKE(VIC20_VIA2_DDRB, ddrb);
}

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

static void read_protopad_vic20_joy(void)
{
    unsigned char b1;
    unsigned char b2;
    unsigned char b3;
    unsigned char b4;
    unsigned char ddra = PEEK(VIC20_VIA1_DDRA);
    unsigned char ddrb = PEEK(VIC20_VIA2_DDRB);
    unsigned char tddra, tddrb;
    unsigned char pra, prb;
    unsigned char tmp1, tmp2;

    tddra = ddra & 0xC3;
    tddrb = ddrb & 0x7F;

    tmp1 = tddra | 0x3C;
    tmp2 = tddrb | 0x80;

    POKE(VIC20_VIA1_DDRA, tmp1);
    POKE(VIC20_VIA2_DDRB, tmp2);

    tmp1 = tddra | 0x20;
    POKE(VIC20_VIA1_DDRA, tmp1);

    pra = PEEK(VIC20_VIA1_PRA);
    prb = PEEK(VIC20_VIA2_PRB);
    
    pra &= 0xC3;
    prb &= 0x7F;
    
    tmp2 = prb | 0x80;

    POKE(VIC20_VIA2_PRB, tmp2);
    b1 = ~PEEK(VIC20_VIA1_PRA);
    POKE(VIC20_VIA2_PRB, prb);
    b2 = ~PEEK(VIC20_VIA1_PRA);
    POKE(VIC20_VIA2_PRB, tmp2);
    b3 = ~PEEK(VIC20_VIA1_PRA);
    POKE(VIC20_VIA2_PRB, prb);
    b4 = ~PEEK(VIC20_VIA1_PRA);
    POKE(VIC20_VIA1_DDRA, tddra);
    POKE(VIC20_VIA2_DDRB, tddrb);

    snes_status[0] = (b1 & 0x10) ? 0x0001 : 0x0000;
    snes_status[0] |= (b4 & 0x08) ? 0x0002 : 0x0000;
    snes_status[0] |= (b3 & 0x08) ? 0x0004 : 0x0000;
    snes_status[0] |= (b3 & 0x10) ? 0x0008 : 0x0000;
    snes_status[0] |= (b2 & 0x04) ? 0x0010 : 0x0000;
    snes_status[0] |= (b2 & 0x08) ? 0x0020 : 0x0000;
    snes_status[0] |= (b2 & 0x10) ? 0x0040 : 0x0000;
    snes_status[0] |= (b1 & 0x04) ? 0x0080 : 0x0000;
    snes_status[0] |= (b1 & 0x08) ? 0x0100 : 0x0000;
    snes_status[0] |= (b4 & 0x04) ? 0x0200 : 0x0000;
    snes_status[0] |= (b4 & 0x10) ? 0x0400 : 0x0000;
    snes_status[0] |= (b3 & 0x04) ? 0x0800 : 0x0000;
}
#endif

/* plus4 native and sidcart joystick handling */
#if defined(__PLUS4__) || defined(__C16__)
static unsigned char read_native_plus4_joy1(void)
{
    unsigned char retval;
    unsigned char temp;

    POKE(PLUS4_KEY_SELECT, 0xFF);
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

    POKE(PLUS4_KEY_SELECT, 0xFF);
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
    if (PEEK(POTX_DATA)) {
        retval |= 0x20;
    }
    if (PEEK(POTY_DATA)) {
        retval |= 0x40;
    }
    retval ^= 0x7F;
    return retval;
}
#endif

/* cbm6x0 joystick handling */
#ifdef __CBM610__
static void read_superpad(void)
{
    unsigned char ddra = peekbsys(CBM6x0_CIA2_DDRA);
    unsigned char pra;
    unsigned char i;
    unsigned char data;

    pokebsys(CBM6x0_CIA2_DDRA, (ddra & 0xFB) | 4);
    pra = peekbsys(CBM6x0_CIA2_PRA);
    pokebsys(CBM6x0_CIA2_PRA, (pra & 0xFB) | 4);
    pokebsys(CBM6x0_CIA2_PRA, pra & 0xFB);
    pokebsys(USERPORT_DDR, 0);

    for (i = 0; i < 8; i++) {
        snes_status[i] = 0;
    }

    for (i = 0; i < 12; i++) {
        data = ~peekbsys(USERPORT_DATA);
        snes_status[0] |= ((data & 0x01) << i);
        snes_status[1] |= (((data & 0x02) >> 1) << i);
        snes_status[2] |= (((data & 0x04) >> 2) << i);
        snes_status[3] |= (((data & 0x08) >> 3) << i);
        snes_status[4] |= (((data & 0x10) >> 4) << i);
        snes_status[5] |= (((data & 0x20) >> 5) << i);
        snes_status[6] |= (((data & 0x40) >> 6) << i);
        snes_status[7] |= (((data & 0x80) >> 7) << i);
    }
    pokebsys(CBM6x0_CIA2_PRA, pra);
    pokebsys(CBM6x0_CIA2_DDRA, ddra);
}
#endif

/* cbm5x0 native joystick handling */
#ifdef __CBM510__
static void read_inception_cbm5x0_joy1(void)
{
    unsigned char i;
    unsigned char ddra = peekbsys(CBM510_CIA2_DDRA);
    unsigned char ddrb = peekbsys(CBM510_CIA2_DDRB);

    pokebsys(CBM510_CIA2_PRA, 0);
    pokebsys(CBM510_CIA2_PRB, 0);
    pokebsys(CBM510_CIA2_DDRA, 0x40);
    pokebsys(CBM510_CIA2_DDRB, 0x0F);
    pokebsys(CBM510_CIA2_PRA, 0);
    pokebsys(CBM510_CIA2_PRB, 0);
    pokebsys(CBM510_CIA2_DDRB, 0);

    for (i = 0; i < 8; i++) {
        pokebsys(CBM510_CIA2_PRA, 0x40);
        joy8_status[i] = peekbsys(CBM510_CIA2_PRB) << 4;
        pokebsys(CBM510_CIA2_PRA, 0);
        joy8_status[i] |= peekbsys(CBM510_CIA2_PRB) & 0xF;
    }
    for (i = 0; i < 8; i++) {
        pokebsys(CBM510_CIA2_PRA, 0x40);
        pokebsys(CBM510_CIA2_PRA, 0);
    }
    pokebsys(CBM510_CIA2_DDRA, ddra);
    pokebsys(CBM510_CIA2_DDRB, ddrb);
}

static void read_inception_cbm5x0_joy2(void)
{
    unsigned char i;
    unsigned char ddra = peekbsys(CBM510_CIA2_DDRA);
    unsigned char ddrb = peekbsys(CBM510_CIA2_DDRB);

    pokebsys(CBM510_CIA2_DDRB, 0xF0);
    pokebsys(CBM510_CIA2_DDRA, 0x80);
    pokebsys(CBM510_CIA2_PRA, 0);
    pokebsys(CBM510_CIA2_PRB, 0);
    pokebsys(CBM510_CIA2_DDRB, 0);

    for (i = 0; i < 8; i++) {
        pokebsys(CBM510_CIA2_PRA, 0x80);
        joy8_status[i] = peekbsys(CBM510_CIA2_PRB) & 0xF0;
        pokebsys(CBM510_CIA2_PRA, 0);
        joy8_status[i] |= peekbsys(CBM510_CIA2_PRB) >> 4;
    }
    for (i = 0; i < 8; i++) {
        pokebsys(CBM510_CIA2_PRA, 0x80);
        pokebsys(CBM510_CIA2_PRA, 0);
    }
    pokebsys(CBM510_CIA2_DDRB, ddrb);
    pokebsys(CBM510_CIA2_DDRA, ddra);
}

static void read_multijoy_cbm510_joy1(void)
{
    unsigned char i;
    unsigned char ddrb = peekbsys(CBM510_CIA2_DDRB);

    pokebsys(CBM510_CIA2_DDRB, 0xF0);

    for (i = 0; i < 8; ++i) {
        pokebsys(CBM510_CIA2_PRB, i << 4);
        joy8_status[i] = peekbsys(CBM510_CIA2_PRB) & 0xF;
        joy8_status[i] |= ((peekbsys(CBM510_CIA2_PRA) & 0x40) >> 2);
        joy8_status[i] ^= 0x1F;
    }
    pokebsys(CBM510_CIA2_DDRB, ddrb);
}

static void read_multijoy_cbm510_joy2(void)
{
    unsigned char i;
    unsigned char ddrb = peekbsys(CBM510_CIA2_DDRB);

    pokebsys(CBM510_CIA2_DDRB, 0xF);

    for (i = 0; i < 8; ++i) {
        pokebsys(CBM510_CIA2_PRB, i);
        joy8_status[i] = peekbsys(CBM510_CIA2_PRB) >> 4;
        joy8_status[i] |= ((peekbsys(CBM510_CIA2_PRA) & 0x80) >> 3);
        joy8_status[i] ^= 0x1F;
    }
    pokebsys(CBM510_CIA2_DDRB, ddrb);
}

static void read_snes_cbm510_joy1(void)
{
    unsigned char i;
    unsigned char data;
    unsigned char ddra = peekbsys(CBM510_CIA2_DDRA);
    unsigned char ddrb = peekbsys(CBM510_CIA2_DDRB);

    pokebsys(CBM510_CIA2_DDRB, 0x08);
    pokebsys(CBM510_CIA2_DDRA, 0x40);
    pokebsys(CBM510_CIA2_PRA, 0x40);
    pokebsys(CBM510_CIA2_PRA, 0x00);

    snes_status[0] = 0;
    snes_status[1] = 0;
    snes_status[2] = 0;

    for (i = 0; i < 12; i++) {
        data = ~peekbsys(CBM510_CIA2_PRB);
        snes_status[0] |= ((data & 0x01) << i);
        snes_status[1] |= (((data & 0x02) >> 1) << i);
        snes_status[2] |= (((data & 0x04) >> 2) << i);
        pokebsys(CBM510_CIA2_PRB, 0x08);
        pokebsys(CBM510_CIA2_PRB, 0x00);
    }
    pokebsys(CBM510_CIA2_DDRA, ddra);
    pokebsys(CBM510_CIA2_DDRB, ddrb);
}

static void read_snes_cbm510_joy2(void)
{
    unsigned char i;
    unsigned char data;
    unsigned char ddra = peekbsys(CBM510_CIA2_DDRA);
    unsigned char ddrb = peekbsys(CBM510_CIA2_DDRB);

    pokebsys(CBM510_CIA2_DDRA, 0x80);
    pokebsys(CBM510_CIA2_DDRB, 0x80);
    pokebsys(CBM510_CIA2_PRA, 0x80);
    pokebsys(CBM510_CIA2_PRA, 0x00);

    snes_status[0] = 0;
    snes_status[1] = 0;
    snes_status[2] = 0;

    for (i = 0; i < 12; i++) {
        data = ~peekbsys(CBM510_CIA2_PRB);
        snes_status[0] |= (((data & 0x10) >> 4) << i);
        snes_status[1] |= (((data & 0x20) >> 5) << i);
        snes_status[2] |= (((data & 0x40) >> 6) << i);
        pokebsys(CBM510_CIA2_PRB, 0x80);
        pokebsys(CBM510_CIA2_PRB, 0x00);
    }
    pokebsys(CBM510_CIA2_DDRA, ddra);
    pokebsys(CBM510_CIA2_DDRB, ddrb);
}

static unsigned char read_native_cbm510_joy1(void)
{
    unsigned char retval;

    retval = peekbsys(CBM510_CIA2_PRB) & 0x0F;
    retval |= ((peekbsys(CBM510_CIA2_PRA) & 0x40) >> 2);
    retval &= 0x1F;
    if (peekbsys(POTX_DATA)) {
        retval |= 0x20;
    }
    if (peekbsys(POTY_DATA)) {
        retval |= 0x40;
    }
    retval ^= 0x7F;
    return retval;
}

static unsigned char read_native_cbm510_joy2(void)
{
    unsigned char retval;

    retval = peekbsys(CBM510_CIA2_PRB) >> 4;
    retval |= ((peekbsys(CBM510_CIA2_PRA) & 0x80) >> 3);
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

static void read_superpad(void)
{
    unsigned char ddra = PEEK(C64_CIA2_DDRA);
    unsigned char pra;
    unsigned char i;
    unsigned char data;

    POKE(C64_CIA2_DDRA, (ddra & 0xFB) | 4);
    pra = PEEK(C64_CIA2_PRA);
    POKE(C64_CIA2_PRA, (pra & 0xFB) | 4);
    POKE(C64_CIA2_PRA, pra & 0xFB);
    POKE(USERPORT_DDR, 0);

    for (i = 0; i < 8; i++) {
        snes_status[i] = 0;
    }

    for (i = 0; i < 12; i++) {
        data = ~PEEK(USERPORT_DATA);
        snes_status[0] |= ((data & 0x01) << i);
        snes_status[1] |= (((data & 0x02) >> 1) << i);
        snes_status[2] |= (((data & 0x04) >> 2) << i);
        snes_status[3] |= (((data & 0x08) >> 3) << i);
        snes_status[4] |= (((data & 0x10) >> 4) << i);
        snes_status[5] |= (((data & 0x20) >> 5) << i);
        snes_status[6] |= (((data & 0x40) >> 6) << i);
        snes_status[7] |= (((data & 0x80) >> 7) << i);
    }
    POKE(C64_CIA2_PRA, pra);
    POKE(C64_CIA2_DDRA, ddra);
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

static void read_petscii(void)
{
    unsigned char i;
    unsigned char data;

    USERPORTPOKE(USERPORT_DDR, 0x28);
    USERPORTPOKE(USERPORT_DATA, 0x20);
    USERPORTPOKE(USERPORT_DATA, 0x00);

    snes_status[0] = 0;
    for (i = 0; i < 12; i++) {
        data = ~USERPORTPEEK(USERPORT_DATA);
        snes_status[0] |= (((data & 0x40) >> 6) << i);
        USERPORTPOKE(USERPORT_DATA, 0x08);
        USERPORTPOKE(USERPORT_DATA, 0x00);
    }
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
void main(void)
{
    unsigned char key;

    printf("%c",uppercase);
    test_c64dtv();
    bgcolor(COLOR_BLACK);
    bordercolor(COLOR_BLACK);
    textcolor(COLOR_WHITE);
    clrscr();
    SEI();
    while (1)
    {
        if (current_page == PAGE_C64_JOYSTICKS) {
            draw_joy(read_native_c64_joy1(), 2, 0, 0, 0, "native1", !isc64dtv);
            draw_joy(read_native_c64_joy2(), 10, 0, 8, 0, "native2", !isc64dtv);
            draw_joy(read_hummer_joy(), 18, 0, 16, 0, "hummer", 0);
            if (isc64dtv == 0)
            {
                draw_joy(read_cga_joy1(), 2, 5, 1, 5, "cga-1", 0);
                draw_joy(read_cga_joy2(), 10, 5, 9, 5, "cga-2", 0);
                draw_joy(read_oem_joy(), 18, 5, 18, 5, "oem", 0);
                draw_joy(read_pet_joy1(), 2, 10, 1, 10, "pet-1", 0);
                draw_joy(read_pet_joy2(), 10, 10, 9, 10, "pet-2", 0);
                draw_joy(read_c64_hit_joy1(), 2, 15, 1, 15, "hit-1", 0);
                draw_joy(read_c64_hit_joy2(), 10, 15, 9, 15, "hit-2", 0);
                draw_joy(read_c64_kingsoft_joy1(), 18, 15, 17, 15, "king1", 0);
                draw_joy(read_c64_kingsoft_joy2(), 26, 15, 25, 15, "king2", 0);
                draw_joy(read_c64_starbyte_joy1(), 18, 10, 17, 10, "star1", 0);
                draw_joy(read_c64_starbyte_joy2(), 26, 10, 25, 10, "star2", 0);
            }
            gotoxy(0, 20);
            cprintf(page_message);
        }
        if (current_page == PAGE_C64_JOYPORT_SNESPADS) {
            read_snes_c64_joy1();
            draw_snes(snes_status[0], 0, 0, "joy-1 snes-1");
            draw_snes(snes_status[1], 0, 6, "joy-1 snes-2");
            draw_snes(snes_status[2], 0, 12, "joy-1 snes-3");
            read_snes_c64_joy2();
            draw_snes(snes_status[0], 21, 0, "joy-2 snes-1");
            draw_snes(snes_status[1], 21, 6, "joy-2 snes-2");
            draw_snes(snes_status[2], 21, 12, "joy-2 snes-3");
            chlinexy(0,5,40);
            chlinexy(0,11,40);
            chlinexy(0,17,40);
            gotoxy(0, 24);
            cprintf(page_message);
        }
        if (isc64dtv == 0) {
            if (current_page == PAGE_C64_USERPORT_SNESPADS) {
                read_superpad();
                draw_snes(snes_status[0], 0, 0, "superpad snes-1");
                draw_snes(snes_status[1], 21, 0, "superpad snes-2");
                draw_snes(snes_status[2], 0, 6, "superpad snes-3");
                draw_snes(snes_status[3], 21, 6, "superpad snes-4");
                draw_snes(snes_status[4], 0, 12, "superpad snes-5");
                draw_snes(snes_status[5], 21, 12, "superpad snes-6");
                draw_snes(snes_status[6], 0, 18, "superpad snes-7");
                draw_snes(snes_status[7], 21, 18, "superpad snes-8");
                chlinexy(0,5,40);
                chlinexy(0,11,40);
                chlinexy(0,17,40);
                chlinexy(0,23,40);
                gotoxy(0, 24);
                cprintf(page_message);
            }
            if (current_page == PAGE_C64_PETSCII_SNESPAD) {
                read_petscii();
                draw_snes(snes_status[0], 0, 0, "petscii snes");
                gotoxy(0, 24);
                cprintf(page_message);
            }
        }
        if (current_page == PAGE_C64_PROTOPADS) {
            read_protopad_c64_joy1();
            draw_snes(snes_status[0], 0, 0, "protopad joy-1");
            read_protopad_c64_joy2();
            draw_snes(snes_status[0], 21, 0, "protopad joy-2");
            gotoxy(0, 24);
            cprintf(page_message);
        }
        if (current_page == PAGE_C64_8JOY) {
            read_multijoy_c64_joy1();
            gotoxy(0, 0);
            cprintf("multijoy joystick adapter in joyport 1");
            draw_joy(joy8_status[0], 0, 1, 0, 1, "mj1", 0);
            draw_joy(joy8_status[1], 5, 1, 5, 1, "mj2", 0);
            draw_joy(joy8_status[2], 10, 1, 10, 1, "mj3", 0);
            draw_joy(joy8_status[3], 15, 1, 15, 1, "mj4", 0);
            draw_joy(joy8_status[4], 20, 1, 20, 1, "mj5", 0);
            draw_joy(joy8_status[5], 25, 1, 25, 1, "mj6", 0);
            draw_joy(joy8_status[6], 30, 1, 30, 1, "mj7", 0);
            draw_joy(joy8_status[7], 35, 1, 35, 1, "mj8", 0);
            read_multijoy_c64_joy2();
            gotoxy(0, 6);
            cprintf("multijoy joystick adapter in joyport 2");
            draw_joy(joy8_status[0], 0, 7, 0, 7, "mj1", 0);
            draw_joy(joy8_status[1], 5, 7, 5, 7, "mj2", 0);
            draw_joy(joy8_status[2], 10, 7, 10, 7, "mj3", 0);
            draw_joy(joy8_status[3], 15, 7, 15, 7, "mj4", 0);
            draw_joy(joy8_status[4], 20, 7, 20, 7, "mj5", 0);
            draw_joy(joy8_status[5], 25, 7, 25, 7, "mj6", 0);
            draw_joy(joy8_status[6], 30, 7, 30, 7, "mj7", 0);
            draw_joy(joy8_status[7], 35, 7, 35, 7, "mj8", 0);
            if (isc64dtv == 0) {
                read_spaceballs_c64_joy1();
                gotoxy(0, 12);
                cprintf("spaceballs joystick adapter in joyport 1");
                draw_joy(joy8_status[0], 0, 13, 0, 13, "sb1", 0);
                draw_joy(joy8_status[1], 5, 13, 5, 13, "sb2", 0);
                draw_joy(joy8_status[2], 10, 13, 10, 13, "sb3", 0);
                draw_joy(joy8_status[3], 15, 13, 15, 13, "sb4", 0);
                draw_joy(joy8_status[4], 20, 13, 20, 13, "sb5", 0);
                draw_joy(joy8_status[5], 25, 13, 25, 13, "sb6", 0);
                draw_joy(joy8_status[6], 30, 13, 30, 13, "sb7", 0);
                draw_joy(joy8_status[7], 35, 13, 35, 13, "sb8", 0);
                read_spaceballs_c64_joy2();
                gotoxy(0, 18);
                cprintf("spaceballs joystick adapter in joyport 2");
                draw_joy(joy8_status[0], 0, 19, 0, 19, "sb1", 0);
                draw_joy(joy8_status[1], 5, 19, 5, 19, "sb2", 0);
                draw_joy(joy8_status[2], 10, 19, 10, 19, "sb3", 0);
                draw_joy(joy8_status[3], 15, 19, 15, 19, "sb4", 0);
                draw_joy(joy8_status[4], 20, 19, 20, 19, "sb5", 0);
                draw_joy(joy8_status[5], 25, 19, 25, 19, "sb6", 0);
                draw_joy(joy8_status[6], 30, 19, 30, 19, "sb7", 0);
                draw_joy(joy8_status[7], 35, 19, 35, 19, "sb8", 0);
            }
            gotoxy(0, 24);
            cprintf(page_message);
        }
        if (current_page == PAGE_C64_INCEPTION) {
            read_inception_c64_joy1();
            gotoxy(0, 0);
            cprintf("inception joystick adapter in joyport 1");
            draw_joy(joy8_status[0], 0, 1, 0, 1, "in1", 0);
            draw_joy(joy8_status[1], 5, 1, 5, 1, "in2", 0);
            draw_joy(joy8_status[2], 10, 1, 10, 1, "in3", 0);
            draw_joy(joy8_status[3], 15, 1, 15, 1, "in4", 0);
            draw_joy(joy8_status[4], 20, 1, 20, 1, "in5", 0);
            draw_joy(joy8_status[5], 25, 1, 25, 1, "in6", 0);
            draw_joy(joy8_status[6], 30, 1, 30, 1, "in7", 0);
            draw_joy(joy8_status[7], 35, 1, 35, 1, "in8", 0);
            read_inception_c64_joy2();
            gotoxy(0, 6);
            cprintf("inception joystick adapter in joyport 2");
            draw_joy(joy8_status[0], 0, 7, 0, 7, "in1", 0);
            draw_joy(joy8_status[1], 5, 7, 5, 7, "in2", 0);
            draw_joy(joy8_status[2], 10, 7, 10, 7, "in3", 0);
            draw_joy(joy8_status[3], 15, 7, 15, 7, "in4", 0);
            draw_joy(joy8_status[4], 20, 7, 20, 7, "in5", 0);
            draw_joy(joy8_status[5], 25, 7, 25, 7, "in6", 0);
            draw_joy(joy8_status[6], 30, 7, 30, 7, "in7", 0);
            draw_joy(joy8_status[7], 35, 7, 35, 7, "in8", 0);
            gotoxy(0, 24);
            cprintf(page_message);
        }
        if (key = check_keys()) {
            while (check_keys()) {
            }
            if (key == 1) {
                current_page++;
                if (current_page >= PAGE_C64_MAX) {
                    current_page = PAGE_C64_JOYSTICKS;
                }
                if (isc64dtv) {
                    if (current_page == PAGE_C64_PETSCII_SNESPAD) {
                        current_page += 2;
                    }
                }
            } else {
                if (!current_page) {
                    current_page = PAGE_C64_MAX;
                }
                current_page--;
                if (isc64dtv) {
                    if (current_page == PAGE_C64_USERPORT_SNESPADS) {
                        current_page -= 2;
                    }
                }
            }
            clrscr();
        }
    }
}
#endif

/* cbm5x0 joystick test */
#ifdef __CBM510__
void main(void)
{
    unsigned char key;

    printf("%c",uppercase);
    bgcolor(COLOR_BLACK);
    bordercolor(COLOR_BLACK);
    textcolor(COLOR_WHITE);
    clrscr();
    SEI();
    while (1)
    {
        if (current_page == PAGE_CBM5x0_JOYSTICKS) {
            draw_joy(read_native_cbm510_joy1(), 2, 0, 0, 0, "native1", 1);
            draw_joy(read_native_cbm510_joy2(), 10, 0, 8, 0, "native2", 1);
            gotoxy(0, 5);
            cprintf(page_message);
        }
        if (current_page == PAGE_CBM5x0_SNESPADS) {
            read_snes_cbm510_joy1();
            draw_snes(snes_status[0], 0, 0, "joy-1 snes-1");
            draw_snes(snes_status[1], 0, 6, "joy-1 snes-2");
            draw_snes(snes_status[2], 0, 12, "joy-1 snes-3");
            read_snes_cbm510_joy2();
            draw_snes(snes_status[0], 21, 0, "joy-2 snes-1");
            draw_snes(snes_status[1], 21, 6, "joy-2 snes-2");
            draw_snes(snes_status[2], 21, 12, "joy-2 snes-3");
            chlinexy(0,5,40);
            chlinexy(0,11,40);
            chlinexy(0,17,40);
            gotoxy(0, 18);
            cprintf(page_message);
        }
        if (current_page == PAGE_CBM5x0_8JOY) {
            read_multijoy_cbm510_joy1();
            gotoxy(0, 0);
            cprintf("multijoy joystick adapter in joyport 1");
            draw_joy(joy8_status[0], 0, 1, 0, 1, "mj1", 0);
            draw_joy(joy8_status[1], 5, 1, 5, 1, "mj2", 0);
            draw_joy(joy8_status[2], 10, 1, 10, 1, "mj3", 0);
            draw_joy(joy8_status[3], 15, 1, 15, 1, "mj4", 0);
            draw_joy(joy8_status[4], 20, 1, 20, 1, "mj5", 0);
            draw_joy(joy8_status[5], 25, 1, 25, 1, "mj6", 0);
            draw_joy(joy8_status[6], 30, 1, 30, 1, "mj7", 0);
            draw_joy(joy8_status[7], 35, 1, 35, 1, "mj8", 0);
            read_multijoy_cbm510_joy2();
            gotoxy(0, 6);
            cprintf("multijoy joystick adapter in joyport 2");
            draw_joy(joy8_status[0], 0, 7, 0, 7, "mj1", 0);
            draw_joy(joy8_status[1], 5, 7, 5, 7, "mj2", 0);
            draw_joy(joy8_status[2], 10, 7, 10, 7, "mj3", 0);
            draw_joy(joy8_status[3], 15, 7, 15, 7, "mj4", 0);
            draw_joy(joy8_status[4], 20, 7, 20, 7, "mj5", 0);
            draw_joy(joy8_status[5], 25, 7, 25, 7, "mj6", 0);
            draw_joy(joy8_status[6], 30, 7, 30, 7, "mj7", 0);
            draw_joy(joy8_status[7], 35, 7, 35, 7, "mj8", 0);
        }
        if (current_page == PAGE_CBM5x0_INCEPTION) {
            read_inception_cbm5x0_joy1();
            gotoxy(0, 0);
            cprintf("inception joystick adapter in joyport 1");
            draw_joy(joy8_status[0], 0, 1, 0, 1, "in1", 0);
            draw_joy(joy8_status[1], 5, 1, 5, 1, "in2", 0);
            draw_joy(joy8_status[2], 10, 1, 10, 1, "in3", 0);
            draw_joy(joy8_status[3], 15, 1, 15, 1, "in4", 0);
            draw_joy(joy8_status[4], 20, 1, 20, 1, "in5", 0);
            draw_joy(joy8_status[5], 25, 1, 25, 1, "in6", 0);
            draw_joy(joy8_status[6], 30, 1, 30, 1, "in7", 0);
            draw_joy(joy8_status[7], 35, 1, 35, 1, "in8", 0);
            read_inception_cbm5x0_joy2();
            gotoxy(0, 6);
            cprintf("inception joystick adapter in joyport 2");
            draw_joy(joy8_status[0], 0, 7, 0, 7, "in1", 0);
            draw_joy(joy8_status[1], 5, 7, 5, 7, "in2", 0);
            draw_joy(joy8_status[2], 10, 7, 10, 7, "in3", 0);
            draw_joy(joy8_status[3], 15, 7, 15, 7, "in4", 0);
            draw_joy(joy8_status[4], 20, 7, 20, 7, "in5", 0);
            draw_joy(joy8_status[5], 25, 7, 25, 7, "in6", 0);
            draw_joy(joy8_status[6], 30, 7, 30, 7, "in7", 0);
            draw_joy(joy8_status[7], 35, 7, 35, 7, "in8", 0);
            gotoxy(0, 24);
            cprintf(page_message);
        }
        if (key = check_keys()) {
            while (check_keys()) {
            }
            if (key == 1) {
                current_page++;
                if (current_page >= PAGE_CBM5x0_MAX) {
                    current_page = PAGE_CBM5x0_JOYSTICKS;
                }
            } else {
                if (!current_page) {
                    current_page = PAGE_CBM5x0_MAX;
                }
                current_page--;
            }
            clrscr();
        }
    }
}
#endif

/* cbm6x0/7x0 joystick test */
#ifdef __CBM610__
void main(void)
{
    unsigned char key;

    printf("%c",uppercase);
    clrscr();
    SEI();
    while (1)
    {
        if (current_page == PAGE_CBM6x0_JOYSTICKS) {
            draw_joy(read_cga_joy1(), 2, 0, 1, 0, "cga-1", 0);
            draw_joy(read_cga_joy2(), 10, 0, 9, 0, "cga-2", 0);
            draw_joy(read_hummer_joy(), 18, 0, 16, 0, "hummer", 0);
            draw_joy(read_pet_joy1(), 2, 5, 1, 5, "pet-1", 0);
            draw_joy(read_pet_joy2(), 10, 5, 9, 5, "pet-2", 0);
            draw_joy(read_oem_joy(), 18, 5, 18, 5, "oem", 0);
            gotoxy(0, 10);
            cprintf(page_message);
        }
        if (current_page == PAGE_CBM6x0_PETSCII_SNESPAD) {
            read_petscii();
            draw_snes(snes_status[0], 0, 0, "petscii snes");
            gotoxy(0, 6);
            cprintf(page_message);
        }
        if (current_page == PAGE_CBM6x0_USERPORT_SNESPADS) {
            read_superpad();
            draw_snes(snes_status[0], 0, 0, "superpad snes-1");
            draw_snes(snes_status[1], 21, 0, "superpad snes-2");
            draw_snes(snes_status[2], 0, 6, "superpad snes-3");
            draw_snes(snes_status[3], 21, 6, "superpad snes-4");
            draw_snes(snes_status[4], 0, 12, "superpad snes-5");
            draw_snes(snes_status[5], 21, 12, "superpad snes-6");
            draw_snes(snes_status[6], 0, 18, "superpad snes-7");
            draw_snes(snes_status[7], 21, 18, "superpad snes-8");
            chlinexy(0,5,40);
            chlinexy(0,11,40);
            chlinexy(0,17,40);
            chlinexy(0,23,40);
            gotoxy(0, 24);
            cprintf(page_message);
        }
        if (key = check_keys()) {
            while (check_keys()) {
            }
            if (key == 1) {
                current_page++;
                if (current_page >= PAGE_CBM6x0_MAX) {
                    current_page = PAGE_CBM6x0_JOYSTICKS;
                }
            } else {
                if (!current_page) {
                    current_page = PAGE_CBM6x0_MAX;
                }
                current_page--;
            }
            clrscr();
        }
    }
}
#endif

/* pet joystick test */
#ifdef __PET__
void main(void)
{
    unsigned char key;

    printf("%c",uppercase);
    clrscr();
    SEI();
    while (1)
    {
        if (current_page == PAGE_PET_JOYSTICKS) {
            draw_joy(read_cga_joy1(), 2, 0, 1, 0, "cga-1", 0);
            draw_joy(read_cga_joy2(), 10, 0, 9, 0, "cga-2", 0);
            draw_joy(read_hummer_joy(), 18, 0, 16, 0, "hummer", 0);
            draw_joy(read_pet_joy1(), 2, 5, 1, 5, "pet-1", 0);
            draw_joy(read_pet_joy2(), 10, 5, 9, 5, "pet-2", 0);
            draw_joy(read_oem_joy(), 18, 5, 18, 5, "oem", 0);
            gotoxy(0, 10);
            cprintf(page_message);
        }
        if (current_page == PAGE_PET_SNESPADS) {
            read_petscii();
            draw_snes(snes_status[0], 0, 0, "userport snes");
            gotoxy(0, 6);
            cprintf(page_message);
        }
        if (key = check_keys()) {
            while (check_keys()) {
            }
            if (key == 1) {
                current_page++;
                if (current_page >= PAGE_PET_MAX) {
                    current_page = PAGE_PET_JOYSTICKS;
                }
            } else {
                if (!current_page) {
                    current_page = PAGE_PET_MAX;
                }
                current_page--;
            }
            clrscr();
        }
    }
}
#endif

/* c16/c232/plus4 joystick test */
#if defined(__C16__) || defined(__PLUS4__)
void main(void)
{
    printf("%c",uppercase);
    bgcolor(COLOR_BLACK);
    bordercolor(COLOR_BLACK);
    textcolor(COLOR_WHITE);
    clrscr();
    SEI();
    while (1)
    {
        draw_joy(read_native_plus4_joy1(), 2, 0, 0, 0, "native1", 0);
        draw_joy(read_native_plus4_joy2(), 10, 0, 8, 0, "native2", 0);
        draw_joy(read_plus4_sidcart_joy(), 18, 0, 16, 0, "sidcart", 1);
        draw_joy(read_pet_joy1(), 2, 5, 1, 5, "pet-1", 0);
        draw_joy(read_pet_joy2(), 10, 5, 9, 5, "pet-2", 0);
        draw_joy(read_oem_joy(), 18, 5, 18, 5, "oem", 0);
        draw_joy(read_hummer_joy(), 2, 10, 0, 10, "hummer", 0);
    }
}
#endif

/* vic20 joystick test */
#ifdef __VIC20__
void main(void)
{
    unsigned char key;

    printf("%c",uppercase);
    bgcolor(COLOR_BLACK);
    bordercolor(COLOR_BLACK);
    textcolor(COLOR_WHITE);
    clrscr();
    SEI();
    while (1)
    {
        if (current_page == PAGE_VIC20_JOYSTICKS) {
            draw_joy(read_native_vic20_joy(), 2, 0, 0, 0, "native", 0);
            draw_joy(read_cga_joy1(), 10, 0, 9, 0, "cga-1", 0);
            draw_joy(read_cga_joy2(), 18, 0, 17, 0, "cga-2", 0);
            draw_joy(read_pet_joy1(), 2, 5, 1, 5, "pet-1", 0);
            draw_joy(read_pet_joy2(), 10, 5, 9, 5, "pet-2", 0);
            draw_joy(read_oem_joy(), 18, 5, 18, 5, "oem", 0);
            draw_joy(read_hummer_joy(), 2, 10, 0, 10, "hummer", 0);
            gotoxy(0, 15);
            cprintf(page_message);
        }
        if (current_page == PAGE_VIC20_SNESPADS) {
            read_snes_vic20_joy();
            draw_snes(snes_status[0], 0, 0, "joy snes-1");
            draw_snes(snes_status[1], 0, 6, "joy snes-2");
            draw_snes(snes_status[2], 0, 12, "joy snes-3");
            chlinexy(0,5,22);
            chlinexy(0,11,22);
            chlinexy(0,17,22);
            gotoxy(0, 18);
            cprintf(page_message);
        }
        if (current_page == PAGE_VIC20_PROTOPADS) {
            read_protopad_vic20_joy();
            draw_snes(snes_status[0], 0, 0, "protopad joy");
            gotoxy(0, 24);
            cprintf(page_message);
        }
        if (current_page == PAGE_VIC20_USERPORT_SNESPADS) {
            read_petscii();
            draw_snes(snes_status[0], 0, 0, "userport snes");
            gotoxy(0, 6);
            cprintf(page_message);
        }
        if (current_page == PAGE_VIC20_8JOY) {
            read_spaceballs_vic20_joy();
            gotoxy(0, 0);
            cprintf("spaceballs adapter");
            draw_joy(joy8_status[0], 0, 1, 0, 1, "sb1", 0);
            draw_joy(joy8_status[1], 5, 1, 5, 1, "sb2", 0);
            draw_joy(joy8_status[2], 10, 1, 10, 1, "sb3", 0);
            draw_joy(joy8_status[3], 15, 1, 15, 1, "sb4", 0);
            draw_joy(joy8_status[4], 0, 7, 0, 7, "sb5", 0);
            draw_joy(joy8_status[5], 5, 7, 5, 7, "sb6", 0);
            draw_joy(joy8_status[6], 10, 7, 10, 7, "sb7", 0);
            draw_joy(joy8_status[7], 15, 7, 15, 7, "sb8", 0);
            gotoxy(0, 15);
            cprintf(page_message);
        }
        if (current_page == PAGE_VIC20_INCEPTION) {
            read_inception_vic20_joy();
            gotoxy(0, 0);
            cprintf("inception joy adapter");
            draw_joy(joy8_status[0], 0, 1, 0, 1, "in1", 0);
            draw_joy(joy8_status[1], 5, 1, 5, 1, "in2", 0);
            draw_joy(joy8_status[2], 10, 1, 10, 1, "in3", 0);
            draw_joy(joy8_status[3], 15, 1, 15, 1, "in4", 0);
            draw_joy(joy8_status[4], 0, 7, 0, 7, "in5", 0);
            draw_joy(joy8_status[5], 5, 7, 5, 7, "in6", 0);
            draw_joy(joy8_status[6], 10, 7, 10, 7, "in7", 0);
            draw_joy(joy8_status[7], 15, 7, 15, 7, "in8", 0);
            gotoxy(0, 15);
            cprintf(page_message);
        }
        if (key = check_keys()) {
            while (check_keys()) {
            }
            if (key == 1) {
                current_page++;
                if (current_page >= PAGE_VIC20_MAX) {
                    current_page = PAGE_VIC20_JOYSTICKS;
                }
            } else {
                if (!current_page) {
                    current_page = PAGE_VIC20_MAX;
                }
                current_page--;
            }
            clrscr();
        }
    }
}
#endif
