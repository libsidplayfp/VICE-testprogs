/*
    stripped down version of the "Demo program for mouse usage" that comes
    with cc65. should work on x64, x128, cbm500
*/

#define LINKDRIVER

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mouse.h>
#include <conio.h>
#include <ctype.h>

#if defined(__C64__) || defined(__C128__)

/* Address of data for sprite 0 */
#if defined(__C64__)
#  define SPRITE0_DATA    0x0340
#  define SPRITE0_PTR  	  0x07F8
#elif defined(__C128__)
#  define SPRITE0_DATA    0x0E00
#  define SPRITE0_PTR     0x07F8
#endif

/* The mouse sprite (an arrow) */
static const unsigned char MouseSprite[64] = {
    0x00, 0x00, 0x00,
    0x00, 0x00, 0x00,
    0x00, 0x00, 0x00,
    0x0F, 0xE0, 0x00,
    0x0F, 0xC0, 0x00,
    0x0F, 0x80, 0x00,
    0x0F, 0xC0, 0x00,
    0x0D, 0xE0, 0x00,
    0x08, 0xF0, 0x00,
    0x00, 0x78, 0x00,
    0x00, 0x3C, 0x00,
    0x00, 0x1E, 0x00,
    0x00, 0x0F, 0x00,
    0x00, 0x07, 0x80,
    0x00, 0x03, 0x80,
    0x00, 0x00, 0x00,
    0x00, 0x00, 0x00,
    0x00, 0x00, 0x00,
    0x00, 0x00, 0x00,
    0x00, 0x00, 0x00,
    0x00, 0x00, 0x00,
    0x00
};

#endif  /* __C64__ or __C128__ */

#ifdef LINKDRIVER
extern char mouse_driver;
#endif

#define max(a,b)  (((a) > (b)) ? (a) : (b))
#define min(a,b)  (((a) < (b)) ? (a) : (b))

#ifndef LINKDRIVER
static void CheckError (const char* S, unsigned char Error)
{
    if (Error != MOUSE_ERR_OK) {
        printf ("%s: %s(%d)\n", S, mouse_geterrormsg (Error), Error);
        exit (EXIT_FAILURE);
    }
}
#endif

int main (void)
{
    struct mouse_info info;
    struct mouse_box full_box;
    unsigned char Done;

    /* Clear the screen, set white on black */
    (void) bordercolor (COLOR_BLACK);
    (void) bgcolor (COLOR_BLACK);
    (void) textcolor (COLOR_GRAY3);
    cursor (0);
    clrscr ();

#if defined(__C64__) || defined(__C128__) || defined(__CBM510__)
    /* Copy the sprite data */
    memcpy ((void*) SPRITE0_DATA, MouseSprite, sizeof (MouseSprite));

    /* Set the VIC sprite pointer */
    *(unsigned char*)SPRITE0_PTR = SPRITE0_DATA / 64;

    /* Set the color of sprite 0 */
#ifdef __CBM510__
    pokebsys ((unsigned) &VIC.spr0_color, COLOR_WHITE);
#else
    VIC.spr0_color = COLOR_WHITE;
#endif

#endif

#ifdef LINKDRIVER
    mouse_install (&mouse_def_callbacks, &mouse_driver);
#else
    /* Load and install the mouse driver */
    CheckError ("mouse_load_driver",
                mouse_load_driver (&mouse_def_callbacks, mouse_stddrv));
#endif
    /* Get the initial mouse bounding box */
    mouse_getbox (&full_box);

    /* Print a help line */
    revers (1);
    cputsxy (0, 0, "mouse test                              ");
    revers (0);

    /* Test loop */
    Done = 0;

    while (!Done) {

	/* Get the current mouse coordinates and button states and print them */
	mouse_info (&info);
      	gotoxy (0, 2);
       	cprintf ("X  = %3d", info.pos.x);
      	gotoxy (0, 3);
      	cprintf ("Y  = %3d", info.pos.y);
      	gotoxy (0, 4);
      	cprintf ("LB = %c", (info.buttons & MOUSE_BTN_LEFT)? '1' : '0');
      	gotoxy (0, 5);
      	cprintf ("RB = %c", (info.buttons & MOUSE_BTN_RIGHT)? '1' : '0');

        mouse_show ();
    }

#ifdef LINKDRIVER
    mouse_uninstall ();
#else
    /* Uninstall and unload the mouse driver */
    CheckError ("mouse_unload", mouse_unload ());
#endif

    /* Say goodbye */
    clrscr ();
    cputs ("Goodbye!\r\n");

    return EXIT_SUCCESS;
}
