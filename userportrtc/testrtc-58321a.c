#include <conio.h>
#include <stdio.h>
#include <6502.h>
#include <peekpoke.h>

#ifdef __CBM610__
#include <cbm610.h>
#endif

/* c64/c128 userport addresses */
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

static unsigned char read_rtc_byte(unsigned char addr)
{
    unsigned char retval;
    unsigned char tmp = addr;

    USERPORTPOKE(USERPORT_DDR, 0xff);
    USERPORTPOKE(USERPORT_DATA, tmp);
    tmp ^= 0x10;
    USERPORTPOKE(USERPORT_DATA, tmp);
    tmp ^= 0x10;
    USERPORTPOKE(USERPORT_DATA, tmp);
    USERPORTPOKE(USERPORT_DATA, 0x20);
    USERPORTPOKE(USERPORT_DDR, 0xf0);
    retval = USERPORTPEEK(USERPORT_DATA);
    retval &= 0xf;

    return retval;
}

static char *days[7] = { "mon", "tue", "wed", "thu", "fri", "sat", "sun" }; 

static char *months[12] = { "jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec" };

int main(void)
{
    unsigned char val;
    char *ampm = NULL;

#if !defined(__CBM610__) && !defined(__PET__)
    bgcolor(COLOR_BLACK);
    bordercolor(COLOR_BLACK);
    textcolor(COLOR_WHITE);
#endif
    clrscr();
    SEI();
    while (1)
    {
        /* day of week */
        val = read_rtc_byte(6);
        cputcxy(0, 0, days[val][0]);
        cputcxy(1, 0, days[val][1]);
        cputcxy(2, 0, days[val][2]);

        /* 10th days of month */
        val = read_rtc_byte(8);
        cputcxy(4, 0, '0' + (val & 3));

        /* days of month */
        val = read_rtc_byte(7);
        cputcxy(5, 0, '0' + val);

        /* day/month seperator */
        cputcxy(6, 0, '/');

        /* months of year */
        val = read_rtc_byte(10) * 10;
        val += read_rtc_byte(9);
        cputcxy(7, 0, months[val - 1][0]);
        cputcxy(8, 0, months[val - 1][1]);
        cputcxy(9, 0, months[val - 1][2]);

        /* month/year seperator */
        cputcxy(10, 0, '/');

        /* 10th years */
        val = read_rtc_byte(12);
        cputcxy(11, 0, '0' + val);

        /* years */
        val = read_rtc_byte(11);
        cputcxy(12, 0, '0' + val);

        /* 10th hours */
        val = read_rtc_byte(5);
        cputcxy(14, 0, '0' + (val & 3));
        if (val & 4) {
            if (val & 2) {
                ampm = "PM";
            } else {
                ampm = "AM";
            }
        } else {
            ampm = "  ";
        }

        /* hours */
        val = read_rtc_byte(4);
        cputcxy(15, 0, '0' + val);

        /* hour/minute seperator */
        cputcxy(16, 0, ':');

        /* 10th minutes */
        val = read_rtc_byte(3);
        cputcxy(17, 0, '0' + val);

        /* minutes */
        val = read_rtc_byte(2);
        cputcxy(18, 0, '0' + val);

        /* minute/second seperator */
        cputcxy(19, 0, ':');

        /* 10th seconds */
        val = read_rtc_byte(1);
        cputcxy(20, 0, '0' + val);

        /* seconds */
        val = read_rtc_byte(0);
        cputcxy(21, 0, '0' + val);

        /* AM/PM */
        cputcxy(23, 0, ampm[0]);
        cputcxy(24, 0, ampm[1]);
    }
}
