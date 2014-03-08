
#include <stdio.h>
#include <stdlib.h>

/*

Zone    Track   Sectors     gap2

0        1-17   21          32
1       18-24   19          73
2       25-30   18          97
3       31-35   17          124
4       36-42   17          124

*/

static const unsigned char trkzone[1 + 42] = {
    0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    1, 1, 1, 1, 1, 1, 1,
    2, 2, 2, 2, 2, 2,
    3, 3, 3, 3, 3,
    4, 4, 4, 4, 4, 4, 4
};

static const unsigned char sectors[5] = {
    21, 19, 18, 17, 17
};
 
int main(int argc, char *argv[])
{
    char *outname;
    char buf[0x100];
    FILE *out;
    int t, s, i, tracks, ts;

    outname = argv[1];

    tracks = atoi(argv[2]);

    out = fopen(outname, "wb");

    for (t = 1; t <= tracks; t++) {
        ts = sectors[trkzone[t]];
        for (s = 0; s < ts; s++) {
            for (i = 0; i < 256; i++) {
                buf[i] = t ^ i;
                i++;
                buf[i] = s ^ i;
            }
            fwrite(buf, 1, 256, out);
        }
    }
    fclose(out);
    return 0;
}