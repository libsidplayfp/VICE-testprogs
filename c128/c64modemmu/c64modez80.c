#include <stdlib.h>

void main()
{
    unsigned char retval;
    unsigned char founditall = 1;
    unsigned char foundbasic = 1;
    unsigned char foundbios = 1;
    unsigned int i;

    /* change border color to indicate we got the z80 switched on */
    outp(0xd020, 1);

    /* check if z80 bios is present */
    retval = bpeek(0x48d);
    if (retval != 0x43) {
        founditall = 0;
    }

    retval = bpeek(0x48e);
    if (retval != 0x50) {
        founditall = 0;
    }

    retval = bpeek(0x48f);
    if (retval != 0x4d) {
        founditall = 0;
    }

    if (founditall == 1) {
        /* change border color to indicate the z80 bios is present */
        outp(0xd020, 3);

        /* try to get into c64 mode */
        outp(0xd505, 0xf6);

        /* check if c64 mode bit is on */
        retval = (inp(0xd505) >> 6) & 1;

        if (retval == 1) {

            /* change border color to indicate we got to c64 mode */
            outp(0xd020, 4);

            /* check if c64 basic is present */
            retval = bpeek(0xa004);
            if (retval != 0x43) {
                foundbasic = 0;
            }

            retval = bpeek(0xa005);
            if (retval != 0x42) {
                foundbasic = 0;
            }

            retval = bpeek(0xa006);
            if (retval != 0x4d) {
                foundbasic = 0;
            }

            /* check if z80 bios is present */
            retval = bpeek(0x48d);
            if (retval != 0x43) {
                foundbios = 0;
            }

            retval = bpeek(0x48e);
            if (retval != 0x50) {
                foundbios = 0;
            }

            retval = bpeek(0x48f);
            if (retval != 0x4d) {
                foundbios = 0;
            }

            /* set color for basic present and bios present */
            if (foundbasic == 1 && foundbios == 1) {
                outp(0xd020, 10);
            /* set color for basic present and bios not present */
            } else if (foundbasic == 1 && foundbios == 0) {
                outp(0xd020, 6);
            /* set color for basic not present and bios present */
            } else if (foundbasic == 0 && foundbios == 1) {
                outp(0xd020, 7);
            /* set color for basic not present and bios not present */
            } else {
                outp(0xd020, 4);
            }
        }
    }

    while (1) { }
}
