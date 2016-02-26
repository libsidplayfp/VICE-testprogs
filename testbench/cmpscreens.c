
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

#define MAXCOLORS 0x100

int verbose = 0;

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

    xsize = xsize1;     // FIXME
    ysize = ysize1;     // FIXME
    if (verbose) printf("cmp size: %dx%d\n", xsize, ysize);

    for (y = ystart; y < (ystart + ysize); y++) {
        for (x = xstart; x < (xstart + xsize); x++) {
            p1 = &data1[bpp1 * ((xsize1 * (y + yoff1)) + (x + xoff1))];
            p2 = &data2[bpp2 * ((xsize2 * (y + yoff2)) + (x + xoff2))];
            if ((p1[0] != p2[0]) || (p1[1] != p2[1]) || (p1[2] != p2[2])) {
                if (verbose) printf("not equal\n");
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

