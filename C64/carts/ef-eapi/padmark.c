
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define EFSIZE      0x100000
#define TAGOFFSET   0x1ff0
#define BANKSIZE    0x2000

static unsigned char cartmem[EFSIZE];

int main(int argc, char *argv[])
{
FILE *f;
int n;
int b = 0x20;
    memset(cartmem, 0xff, EFSIZE);
    f = fopen(argv[1], "rb");
    fread(cartmem, EFSIZE, 1, f);
    fclose (f);

    for (n = 0; n < EFSIZE; n+= (BANKSIZE * 2)) {
        cartmem[n + TAGOFFSET] = b;
        cartmem[n + BANKSIZE + TAGOFFSET] = b;
        b++;
    }

    f = fopen(argv[2], "wb");
    fwrite(cartmem, EFSIZE, 1, f);
    fclose (f);
}
