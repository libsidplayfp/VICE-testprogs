
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

#include <math.h>

#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

#define MAXCOLORS 0x100
#define MAXPALETTES 6

#define max(x, y) (((x) > (y)) ? (x) : (y))
#define min(x, y) (((x) < (y)) ? (x) : (y))

int verbose = 0;
int numpalettes = MAXPALETTES;

int palette1 = 0, palette2 = 0;

int numcolors[MAXPALETTES] = {
    16, // &cols_pepto_pal[0],
    16, // &cols_pepto_ntsc_sony[0],
    16, // &cols_mike_pal[0],
    16, // &cols_pet_green[0],
    16, // &cols_pet_green_old[0],
    25, // &cols_z64_pal_viciie[0],
};

unsigned char cols_pepto_pal[3*16] = {
    0x00, 0x00, 0x00,
    0xff, 0xff, 0xff,
    0x68, 0x37, 0x2b,
    0x70, 0xa4, 0xb2,

    0x6f, 0x3d, 0x86,
    0x58, 0x8d, 0x43,
    0x35, 0x28, 0x79,
    0xb8, 0xc7, 0x6f,

    0x6f, 0x4f, 0x25,
    0x43, 0x39, 0x00,
    0x9a, 0x67, 0x59,
    0x44, 0x44, 0x44,

    0x6c, 0x6c, 0x6c,
    0x9a, 0xd2, 0x84,
    0x6c, 0x5e, 0xb5,
    0x95, 0x95, 0x95,
};
unsigned char cols_pepto_ntsc_sony[3*16] = {
    0x00, 0x00, 0x00,
    0xFF, 0xFF, 0xFF,
    0x7C, 0x35, 0x2B,
    0x5A, 0xA6, 0xB1,

    0x69, 0x41, 0x85,
    0x5D, 0x86, 0x43,
    0x21, 0x2E, 0x78,
    0xCF, 0xBE, 0x6F,

    0x89, 0x4A, 0x26,
    0x5B, 0x33, 0x00,
    0xAF, 0x64, 0x59,
    0x43, 0x43, 0x43,

    0x6B, 0x6B, 0x6B,
    0xA0, 0xCB, 0x84,
    0x56, 0x65, 0xB3,
    0x95, 0x95, 0x95,
};

unsigned char cols_mike_pal[16 * 3] = {
    0x00, 0x00, 0x00, 
    0xFF, 0xFF, 0xFF, 
    0xB6, 0x1F, 0x21, 
    0x4D, 0xF0, 0xFF, 
    
    0xB4, 0x3F, 0xFF, 
    0x44, 0xE2, 0x37, 
    0x1A, 0x34, 0xFF, 
    0xDC, 0xD7, 0x1B, 

    0xCA, 0x54, 0x00, 
    0xE9, 0xB0, 0x72, 
    0xE7, 0x92, 0x93, 
    0x9A, 0xF7, 0xFD, 

    0xE0, 0x9F, 0xFF, 
    0x8F, 0xE4, 0x93, 
    0x82, 0x90, 0xFF, 
    0xE5, 0xDE, 0x85
};

unsigned char cols_pet_green[16 * 3] = {
    0x00, 0x00, 0x00, 
    0x41, 0xFF, 0x00, 
    0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 
    
    0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 

    0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 

    0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 
};

unsigned char cols_pet_green_old[16 * 3] = {
    0x00, 0x00, 0x00, 
    0x00, 0xFF, 0x00, 
    0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 
    
    0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 

    0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 

    0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 
};

unsigned char cols_z64_pal_viciie[3*25] = {
    0x00, 0x00, 0x00,
    0xff, 0xff, 0xff,
    0x68, 0x37, 0x2b,
    0x70, 0xa4, 0xb2,

    0x6f, 0x3d, 0x86,
    0x58, 0x8d, 0x43,
    0x35, 0x28, 0x79,
    0xb8, 0xc7, 0x6f,

    0x6f, 0x4f, 0x25,
    0x43, 0x39, 0x00,
    0x9a, 0x67, 0x59,
    0x44, 0x44, 0x44,

    0x6c, 0x6c, 0x6c,
    0x9a, 0xd2, 0x84,
    0x6c, 0x5e, 0xb5,
    0x95, 0x95, 0x95,
    // 9 extra colors that may show up when doing 2mhz/testbit fuckery
    33, 91, 43,
    188, 125, 178,
    58, 88, 134,
    145,112,67,
    185, 199, 111,
    57, 107, 37,
    40, 71, 0,
    79, 141, 89,
    215, 179, 132
};

unsigned char *colors[MAXPALETTES] = {
    &cols_pepto_pal[0],
    &cols_pepto_ntsc_sony[0],
    &cols_mike_pal[0],
    &cols_pet_green[0],
    &cols_pet_green_old[0],
    &cols_z64_pal_viciie[0],
};

char *palettenames[MAXPALETTES] = {
    "Pepto (PAL)",
    "Pepto (NTSC/SONY)",
    "Mike (VIC20, PAL)",
    "PET green",
    "PET green (old)",
    "Z64K (PAL VICIIe)",
};

int findcolorinpalette(unsigned char *p, int palette)
{
    int i;
    unsigned char *c;
    c = colors[palette];
    //printf("check palette %d:%s\n", palette, palettenames[palette]);
    for (i = 0; i < numcolors[palette]; i++) {
        //printf("check %02x %02x %02x vs  %02x %02x %02x\n", c[0], c[1], c[2], p[0], p[1], p[2]);
        if ((p[0] == c[0]) && (p[1] == c[1]) && (p[2] == c[2])) {
            return i;
        }
        c+=3;
    }
    return -1;
}


int picusespalette(unsigned char *data, int bpp, int w, int h, int palette) {
    int x, y;
    for (y = 0; y < (h); y++) {
        for (x = 0; x < (w); x++) {
            if (findcolorinpalette(&data[bpp * ((w * (y)) + (x))], palette) == -1) {
                return 0;
            }
        }
    }
    return 1;
}

int picchangepalette(unsigned char *data, int bpp, int w, int h, int paletteold, int palettenew) {
    int x, y, col;
    unsigned char *p, *c;
    for (y = 0; y < (h); y++) {
        for (x = 0; x < (w); x++) {
            p = &data[bpp * ((w * (y)) + (x))];
            col = findcolorinpalette(p, paletteold);
            c = colors[palettenew];
            p[0] = c[0 + (col * 3)];
            p[1] = c[1 + (col * 3)];
            p[2] = c[2 + (col * 3)];
        }
    }
    return 1;
}

void usage(void)
{
    printf("cmpscreens - compare two emulator screenshots\n\n"
           "usage: cmpscreens [options] <file1> <xoff> <yoff> <file2> <xoff> <yoff>\n\n"
           "options:\n"
           "-v         verbose mode\n"
          );

}

unsigned char *loadimage(char *imgname, int *x, int *y, int *bpp)
{
    unsigned char *data = NULL;
    FILE *file;
    if (verbose) printf("loading: %s\n",imgname);

    file = fopen(imgname, "rb");
    if (!file) {
        fprintf(stderr, "error: could not load image '%s'\n", imgname);
        exit(-1);
    }

    data = stbi_load_from_file(file, x, y, bpp, 0);
    fclose(file);

    if (verbose) printf("loaded image: x: %d y: %d bpp: %d\n",*x ,*y ,*bpp);

    if ((*bpp != 3) && (*bpp != 4)) {
        fprintf(stderr, "error: only 3 and 4 bpp pictures allowed\n");
        exit(-1);
    }
    return data;
}

int main(int argc, char *argv[])
{
#if 0
    unsigned int colors[MAXCOLORS];
#endif
    int i;
    int x, y;
    unsigned char *data1, *data2;
    char *imgname1, *imgname2;

    unsigned char *p1, *p2;

    int xoff1, yoff1;
    int xoff2, yoff2;

    int xsize1, ysize1, bpp1;
    int xsize2, ysize2, bpp2;

    int xstart, xsize;
    int ystart, ysize;

    if (argc < 4) {
        usage();
        exit(-1);
    }

    for (i = 1; i < argc; i++) {
        if (argv[i][0] == '-') {
            if (argv[i][1] == 'v') {
                verbose = 1;
            } else if (!strcmp(argv[i], "--verbose")) {
                verbose = 1;
            } 
        } else {
            break;
        }
    }
    imgname1 = argv[i]; i++;
    xoff1 = strtoul(argv[i], NULL, 0); i++;
    yoff1 = strtoul(argv[i], NULL, 0); i++;
    imgname2 = argv[i]; i++;
    xoff2 = strtoul(argv[i], NULL, 0); i++;
    yoff2 = strtoul(argv[i], NULL, 0); i++;
    if (verbose) printf("%dx%d %dx%d\n",xoff1,yoff1,xoff2,yoff2);

    data1 = loadimage(imgname1, &xsize1, &ysize1, &bpp1);
    data2 = loadimage(imgname2, &xsize2, &ysize2, &bpp2);
#if 0
    // make table of all colors
    p = data;
    for (yp = 0; yp < y; yp++) {
        for (xp = 0; xp < x; xp++) {
            col = p[0]; col <<= 8;
            col |= p[1]; col <<= 8;
            col |= p[2];
            for (i = 0; i < ccnt; i++) {
                if (colors[i] == col) {
                    break;
                }
            }
            if (i == ccnt) {
                colors[ccnt] = col;
                ccnt++;
            }
            p += bpp;
        }
    }
    printf("colors found: %d\n", ccnt);
    printf("using bg color: $%06x\n", bgcolor);
#endif

//    xoff1 = 32; yoff1 = 35; /* VICE */    // FIXME
//    xoff2 = 53; yoff2 = 62; /* Chameleon */    // FIXME

    if (xoff1 <= xoff2) {
        xstart = 0;
        xoff2 = xoff2 - xoff1;
        xoff1 = 0;
    } else if (xoff1 > xoff2) {
        xstart = 0;
        xoff1 = xoff1 - xoff2;
        xoff2 = 0;
    }

    if (yoff1 <= yoff2) {
        ystart = 0;
        yoff2 = yoff2 - yoff1;
        yoff1 = 0;
    } else if (yoff1 > yoff2) {
        ystart = 0;
        yoff1 = yoff1 - yoff2;
        yoff2 = 0;
    }

    xsize = min(xoff1, xoff2) + min(xsize1 - xoff1, xsize2 - xoff2);
    ysize = min(yoff1, yoff2) + min(ysize1 - yoff1, ysize2 - yoff2);

    if (verbose) printf("cmp size: %dx%d\n", xsize, ysize);

    // find out what palette the first picture uses
    palette1 = -1;
    for (i = 0; i < numpalettes; i++) {
        if (picusespalette(data1, bpp1, xsize1, ysize1, i)) {
            palette1 = i;
            if (verbose) { printf("found palette 1:%d %s\n", palette1, palettenames[palette1]); }
            break;
        }
    }
    if (palette1 == -1) printf("error: palette 1 not found\n");
//    if (verbose) printf("using palette 1:%d\n", palette1);
    
    // find out what palette the second picture uses
    palette2 = -1;
    for (i = 0; i < numpalettes; i++) {
        if (picusespalette(data2, bpp2, xsize2, ysize2, i)) {
            palette2 = i;
            if (verbose) { printf("found palette 2:%d %s\n", palette2, palettenames[palette2]); }
            break;
        }
    }
    if (palette2 == -1) printf("error: palette 2 not found\n");
    
    if ((palette1 == -1) || (palette2 == -1)) {
        return 0xff;
    }

//    if (verbose) printf("using palette 2:%d\n", palette2);
    // if the images use different palettes, alter the second picture to use the same palette as the first
    if (palette1 != palette2) {
        picchangepalette(data2, bpp2, xsize2, ysize2, palette2, palette1);
    }
    
    // finally compare the images
    for (y = ystart; y < (ystart + ysize); y++) {
        for (x = xstart; x < (xstart + xsize); x++) {
            p1 = &data1[bpp1 * ((xsize1 * (y + yoff1)) + (x + xoff1))];
            p2 = &data2[bpp2 * ((xsize2 * (y + yoff2)) + (x + xoff2))];
            if ((p1[0] != p2[0]) || (p1[1] != p2[1]) || (p1[2] != p2[2])) {
                if (verbose) {
                    printf("not equal\n");
                    printf("%d,%d %02x,%02x,%02x != %02x,%02x,%02x\n", x, y, p1[0],p1[1],p1[2],p2[0],p2[1],p2[2]);
                }
                stbi_image_free(data1);
                stbi_image_free(data2);
                return 0xff;
            }
        }
    }
    if (verbose) printf("equal\n");
    stbi_image_free(data1);
    stbi_image_free(data2);
    return 0;
}

