
//#define DEBUG

#include <conio.h>
#include <string.h>
#include <6502.h>

#include "op.h"

unsigned char cpu_type = 0;
unsigned char ram_banks = 1;
unsigned char vic_pal = 0;

unsigned char screenoff = 0;
unsigned char scpumode = 0; // default, none, full
unsigned char *ptr;

void teststart(void)
{
  ptr = (unsigned char*)0xe000;
}

void testend(void)
{
  *ptr = 0x60; // rts
}

void waitframe(void) {
  while (((*(unsigned char*)0xd011) & 0x80) == 0)
  {
    asm ("nop");
  }
  while (((*(unsigned char*)0xd011) & 0x80) != 0)
  {
    asm ("nop");
  }
}

void fixscreen(void)
{
  asm("ldy #$1b");
  asm("sty $d011");
  memset((unsigned char*)0xd800, 14, 0x3e8);
  bordercolor(14);
  bgcolor(6);
  textcolor(14);
}

extern void set_vic_pal(void);
extern void set_ram_banks(void);
extern void set_8bit_emulation(void);
extern void set_8bit_native(void);
extern void __fastcall__ call_16bit_native(void *function);
                            //0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4
unsigned char mintab0[25] = { 2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4 };
unsigned char maxtab0[25] = { 2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4 };

unsigned char mintab1[25] = { 12,12,12,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,14 };
unsigned char maxtab1[25] = { 12,12,12,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,14,14 };

void tests(int badline)
{
  unsigned char min[25], max[25], val;
  unsigned char *mintab, *maxtab;
  unsigned char error;
  int n, i, r = 0, c = 0, count = 0;
  clrscr();
  for (n = 0; n < 25; n++)
  {
    min[n] = 0xff;
    max[n] = 0x00;
  }
  if (badline == 0) {
    mintab = &mintab0[0];
    maxtab = &maxtab0[0];
  } else {
    mintab = &mintab1[0];
    maxtab = &maxtab1[0];
  }
  error = 0;
  while (1)
  {
    for (n = 0; n < 25; n++)
    {
      textcolor(COLOR_WHITE);
      gotoxy(0, n); cprintf("test %2d: ", n);

      if (badline)
      {
        c = (c + 8) & 0x7f;
        r = (52 - 2) + c;
      }
      else
      {
        c = (c + 4) & 0xf8;
        r = (4) + c;
      }

      teststart();

      // stop timers
      *ptr++ = OP_STZ_abs; *ptr++ = (0xdc0e) & 0xff; *ptr++ = (0xdc0e >> 8) & 0xff;
      *ptr++ = OP_STZ_abs; *ptr++ = (0xdc0f) & 0xff; *ptr++ = (0xdc0f >> 8) & 0xff;
      *ptr++ = OP_STZ_abs; *ptr++ = (0xdd0e) & 0xff; *ptr++ = (0xdd0e >> 8) & 0xff;
      *ptr++ = OP_STZ_abs; *ptr++ = (0xdd0f) & 0xff; *ptr++ = (0xdd0f >> 8) & 0xff;

      // setup timer A on CIA #2 to count 63 cycles
      *ptr++ = OP_LDA_imm; *ptr++ = (63-1);
      *ptr++ = OP_STA_abs; *ptr++ = (0xdd04) & 0xff; *ptr++ = (0xdd04 >> 8) & 0xff;
      *ptr++ = OP_LDA_imm; *ptr++ = (0);
      *ptr++ = OP_STA_abs; *ptr++ = (0xdd05) & 0xff; *ptr++ = (0xdd05 >> 8) & 0xff;

      // set timer A to run in continuous mode
      *ptr++ = OP_LDY_imm; *ptr++ = (0x91); // %10010001

      // wait for top of screen
      *ptr++ = OP_LDA_abs; *ptr++ = (0xd012) & 0xff; *ptr++ = (0xd012 >> 8) & 0xff;
      *ptr++ = OP_CMP_abs; *ptr++ = (0xd012) & 0xff; *ptr++ = (0xd012 >> 8) & 0xff;
      *ptr++ = OP_BEQ_imm; *ptr++ = (-5);
      *ptr++ = OP_BMI_imm; *ptr++ = (-10);

      // sync to raster line
      *ptr++ = OP_LDA_imm; *ptr++ = (r+0);
      *ptr++ = OP_CMP_abs; *ptr++ = (0xd012) & 0xff; *ptr++ = (0xd012 >> 8) & 0xff;
      *ptr++ = OP_BNE_imm; *ptr++ = (-5);

      *ptr++ = OP_LDA_imm; *ptr++ = (r+1);
      *ptr++ = OP_CMP_abs; *ptr++ = (0xd012) & 0xff; *ptr++ = (0xd012 >> 8) & 0xff;
      *ptr++ = OP_BNE_imm; *ptr++ = (-5);

      // wait a little
      i = n;
      if ((i >= 3) && ((i & 1) == 1))
      {
        *ptr++ = OP_XBA;
        i -= 3;
      }
      while (i > 0)
      {
        *ptr++ = OP_NOP;
        i -= 2;
      }

      // start timer A
      *ptr++ = OP_STY_abs; *ptr++ = (0xdd0e) & 0xff; *ptr++ = (0xdd0e >> 8) & 0xff;

      if (badline)
      {
        // we need to waste about ((15 + 20) * 20) = 700 cycles
        *ptr++ = OP_LDX_imm; *ptr++ = (77);
        *ptr++ = OP_LDA_abs; *ptr++ = (0xc000) & 0xff; *ptr++ = (0xc000 >> 8) & 0xff; // 4
        *ptr++ = OP_DEX;                                                              // 2
        *ptr++ = OP_BNE_imm; *ptr++ = (-6);                                           // 3
      }
      else
      {
        // sync to raster line
        *ptr++ = OP_LDA_imm; *ptr++ = (r+2);
        *ptr++ = OP_CMP_abs; *ptr++ = (0xd012) & 0xff; *ptr++ = (0xd012 >> 8) & 0xff;
        *ptr++ = OP_BNE_imm; *ptr++ = (-5);
      }

      // get timer A count
      *ptr++ = OP_LDA_abs; *ptr++ = (0xdd04) & 0xff; *ptr++ = (0xdd04 >> 8) & 0xff;
      *ptr++ = OP_STA_abs; *ptr++ = (0xc000) & 0xff; *ptr++ = (0xc000 >> 8) & 0xff;

      *ptr++ = OP_LDA_imm; *ptr++ = (0x11);
      *ptr++ = OP_STA_abs; *ptr++ = (0xdc0e) & 0xff; *ptr++ = (0xdc0e >> 8) & 0xff;

      testend();

      *(unsigned char *)0xc000 = 0xff;

      asm("sei");
      asm("ldy #$35");
      asm("sty $01");
      asm("sty $d07e");
      asm("sty $d076"); // V1 (BASIC optimization)
      asm("ldy #%%10000100");
      asm("sty $d0b3"); // V2 (Full optimization)
      asm("sty $d07f");
      asm("jsr $e000");
      asm("sty $d07e");
      asm("sty $d077"); // V1 default (no optimization)
      asm("ldy #%%11000001");
      asm("sty $d0b3"); // V2 default (optimize zp and stack)
      asm("sty $d07f");
      asm("ldy #$36");
      asm("sty $01");
      asm("cli");

      val = *(unsigned char *)0xc000;
      if (val < min[n])
      {
        min[n] = val;
      }
      if (val > max[n])
      {
        max[n] = val;
      }
      textcolor((mintab[n] == min[n]) ? COLOR_GREEN : COLOR_RED);
      cprintf("%2d ", min[n]);
      textcolor((maxtab[n] == max[n]) ? COLOR_GREEN : COLOR_RED);
      cprintf("%2d ", max[n]);
      if ((mintab[n] != min[n]) || (maxtab[n] != max[n])) {
          error = 1;
      }
    }

    count++;
    textcolor(COLOR_WHITE);
    gotoxy((40 - 17),0); cprintf("[RETURN] for menu");
    gotoxy((40 - 17),1); cprintf("test count: %5d", count);
    
    if (count == 10) {
        if (error) {
            bordercolor(COLOR_RED);
            *(unsigned char*)0xd7ff = 0xff;
        } else {
            bordercolor(COLOR_GREEN);
            *(unsigned char*)0xd7ff = 0;
        }
    }

    for (n = 0; n < 4; n++)
    {
      waitframe();
      if (kbhit())
      {
        unsigned char ch = cgetc();
        if (ch == 0x0d)
        {
          return;
        }
      }
    }
  }
}

void menu(void)
{
  unsigned char ch;
  clrscr();
  
  revers(1);
  gotoxy(0,24); cprintf("CPU %s, RAM %5d KB (%3d BANKS) %s",
      cpu_type == CPU_65816 ? "65816" : cpu_type == CPU_65C02 ? "65C02" : "6502 ",
      ram_banks * 64, ram_banks, vic_pal ? "PAL " : "NTSC");
  revers(0);
  while (1)
  {
    gotoxy(1,1); cprintf("[F1] run rasterline test");
    gotoxy(1,3); cprintf("[F3] run badline test");
    ch = cgetc();
#ifdef DEBUG
    gotoxy (0,0); cprintf("%02x", ch);
#endif
    switch (ch)
    {
      case 0x85:
        tests(0);
        return;
      case 0x86:
        tests(1);
        return;
    }
  }
}

void check_ram_banks(void)
{
  if (cpu_type == CPU_65816) {
    set_ram_banks();
  } else {
    ram_banks = 1;
  }
}

void main(void)
{
  fixscreen();
  clrscr();
  cpu_type = getcpu();
  set_vic_pal();
  check_ram_banks();
#ifdef DOTEST
  tests(DOTEST);
#else
  while (1)
  {
    menu();
  }
#endif
}
