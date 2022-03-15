
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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


static const unsigned int trklen[1+42] = {
    0,
    (21 * 256), (21 * 256), (21 * 256), (21 * 256), (21 * 256), 
    (21 * 256), (21 * 256), (21 * 256), (21 * 256), (21 * 256), 
    (21 * 256), (21 * 256), (21 * 256), (21 * 256), (21 * 256), 
    (21 * 256), (21 * 256), 

    (19 * 256), (19 * 256), (19 * 256), (19 * 256), (19 * 256), 
    (19 * 256), (19 * 256), 

    (18 * 256), (18 * 256), (18 * 256), (18 * 256), (18 * 256), 
    (18 * 256), 

    (17 * 256), (17 * 256), (17 * 256), (17 * 256), (17 * 256), 

    (17 * 256), (17 * 256), (17 * 256), (17 * 256), (17 * 256),
    (17 * 256), (17 * 256)
};

// FIXME: 42 tracks!
static const unsigned int trkoffs[1+40] =
{
    0,
0x00000,
0x01500,
0x02A00,
0x03F00,
0x05400,
0x06900,
0x07E00,
0x09300,
0x0A800,
0x0BD00,
0x0D200,
0x0E700,
0x0FC00,
0x11100,
0x12600,
0x13B00,
0x15000,

0x16500,
0x17800,
0x18B00,
0x19E00,
0x1B100,
0x1C400,
0x1D700,
0x1EA00,
0x1FC00,
0x20E00,
0x22000,
0x23200,
0x24400,
0x25600,
0x26700,
0x27800,
0x28900,
0x29A00,

0x2AB00,
0x2BC00,
0x2CD00,
0x2DE00,
0x2EF00
};

/******************************************************************************/

#define D64MAXSECTORS   (42 * 21)
#define D64MAXSIZE (0x100 * D64MAXSECTORS)

unsigned char d64buffer[D64MAXSIZE];
unsigned char d64errors[D64MAXSECTORS];
unsigned char d71buffer[D64MAXSIZE];
unsigned char d71errors[D64MAXSECTORS];

#define GCRMAXTRACKLEN 0x2000

#define GCRMAXHALFTRACKS   (84+2)
/*
 * GCR buffer contain all physical half tracks, including 0.0 / 0.5 which might
 * not be accessable.
 */
unsigned char gcrbuffer[2][GCRMAXHALFTRACKS][GCRMAXTRACKLEN];
unsigned char gcrspdbuffer[2][GCRMAXHALFTRACKS][4];
unsigned int gcrlenbuffer[2][GCRMAXHALFTRACKS];

/******************************************************************************/

/*
Binary GCR value
0 0000   01010  0a
1 0001   01011  0b
2 0010   10010  12
3 0011   10011  13
4 0100   01110  0e
5 0101   01111  0f
6 0110   10110  16
7 0111   10111  17
8 1000   01001  09
9 1001   11001  19
a 1010   11010  1a
b 1011   11011  1b
c 1100   01101  0d
d 1101   11101  1d
e 1110   11110  1e
f 1111   10101  15
*/

#define g0   (0x0a << x) & 0xff
#define g1   (0x0b << x) & 0xff
#define g2   (0x12 << x) & 0xff
#define g3   (0x13 << x) & 0xff
#define g4   (0x0e << x) & 0xff
#define g5   (0x0f << x) & 0xff
#define g6   (0x16 << x) & 0xff
#define g7   (0x17 << x) & 0xff
#define g8   (0x09 << x) & 0xff
#define g9   (0x19 << x) & 0xff
#define ga   (0x1a << x) & 0xff
#define gb   (0x1b << x) & 0xff
#define gc   (0x0d << x) & 0xff
#define gd   (0x1d << x) & 0xff
#define ge   (0x1e << x) & 0xff
#define gf   (0x15 << x) & 0xff

#define x 0
const unsigned char gcrtab[0x10] = {
    g0,g1,g2,g3,g4,g5,g6,g7,g8,g9,ga,gb,gc,gd,ge,gf
};
#undef x


/*
    Track Range   Size      MNIB
                  (bytes)   Size
    -----------  -------    ----   
        1-17        7692    7692    7696
        18-24       7139    7142    7144
        25-30       6666    6666    6672
        31-         6247    6250    6256
*/

/*
 8192 = sectors * (sync+header+gap+sync+sector+gap2)
 (8192 / sectors) - (sync+header+gap+sync+sector) = gap2
 6+10+9 (6+325) = 356

 header: (6 + 10) = 16 + gap1 -> usually 24 gcr bytes
 sector: (6 + 5 + 315 + 5) = 331 + gap2

*/

/* number of GCR 0x55 bytes after sector data */
static const unsigned char gap2[5] =
{
    /* original values used by 1541 rom */
    12, 21, 16, 13, 13
};

static const unsigned int gcrtrklen[5] =
{
    7692, 7142, 6666, 6250, 6250
};

static unsigned char *gcrout;

static void encode4(unsigned char *in)
{
unsigned char nib;

//    in[1] = 1;

    nib = *in >> 4;
    gcrout[0] = gcrtab[nib] << 3;  /* 5bits */

    nib = *in & 0x0f;
    gcrout[0] |= gcrtab[nib] >> 2; /* 3bits - */
    gcrout[1] = gcrtab[nib] << 6;  /* 2bits */

    ++in;
    nib = *in >> 4;
    gcrout[1] |= gcrtab[nib] << 1; /* 5bits */

    nib = *in & 0x0f;
    gcrout[1] |= gcrtab[nib] >> 4; /* 1bit  - */
    gcrout[2] = gcrtab[nib] << 4;  /* 4bits */
    ++in;
    nib = *in >> 4;
    gcrout[2] |= gcrtab[nib] >> 1; /* 4bits - */
    gcrout[3] = gcrtab[nib] << 7;  /* 1bit */

    nib = *in & 0x0f;
    gcrout[3] |= gcrtab[nib] << 2; /* 5bits */
    ++in;
    nib = *in >> 4;
    gcrout[3] |= gcrtab[nib] >> 3; /* 2bits - */
    gcrout[4] = gcrtab[nib] << 5;  /* 3bits */

    nib = *in & 0x0f;
    gcrout[4] |= gcrtab[nib] << 0; /* 5bits */

    gcrout += 5;
}

static void encodesector(unsigned char *in, int gap2val)
{
static unsigned char count;
static unsigned char chksum;
static unsigned char tail[4];

    memset (gcrout, 0xff, 5); gcrout += 5; /* sync */

    chksum = 0;
    tail[0] = 0x07; // data address mark
    tail[1] = in[0]; // data address mark
    tail[2] = in[1]; // data address mark
    tail[3] = in[2]; // data address mark

    chksum = chksum ^ in[0] ^ in[1] ^ in[2];

    encode4(tail);
    in+=3;

    for (count = 0; count < 0x3f; ++count) {
        encode4(in);
        chksum = chksum ^ in[0] ^ in[1] ^ in[2] ^ in[3];
        in+=4;
    }

    chksum = chksum ^ in[0];

    tail[0] = in[0];
    tail[1] = chksum;
    tail[2] = 0;
    tail[3] = 0;
    encode4(tail);

    memset (gcrout, 0x55, gap2val); gcrout += gap2val; /* gap2 */
}

static unsigned char hdr[8] = {
    8, 0, 0, 0, 0, 0, 15, 15
};

static void encodeheader(int trk, int sec, int diskid0, int diskid1, int head)
{
    if (head == 1) {
        // second side of 1571
        trk += 35;
    }
    
    memset (gcrout, 0xff, 5); gcrout += 5; /* sync */
    hdr[5] = diskid1;
    hdr[4] = diskid0;
    hdr[3] = trk;
    hdr[2] = sec;
    hdr[1] = hdr[2] ^ hdr[3] ^ hdr[4] ^ hdr[5] ^ hdr[6] ^ hdr[7];
    encode4(&hdr[0]);
    encode4(&hdr[4]);

    /* number of GCR 0x55 bytes after sector header, 1541 uses 9 here */
    memset (gcrout, 0x55, 9); gcrout += 9;
}

/* encode one track to GCR */
void encodetrack(unsigned char *in, int trk, int diskid0, int diskid1, int head)
{
int thissec;
int zone, nsec;
int gap1val;
int gap2val;
unsigned char *encroffs;
unsigned int rest;

    zone = trkzone[trk];
    nsec = sectors[zone];
    /*gap1val = gap1[zone];* /* always 9 */
    gap2val = gap2[zone];

    encroffs = in;
    gcrout = &gcrbuffer[head][trk * 2][0];

    for (thissec = 0; thissec < nsec; ++thissec) {

        /* sector header

            0 : 8 (header address mark)
            1 : header checksum
            2 : sector
            3 : track
            4 : disk id
            5 : disk id
            6 : 15
            7 : 15
        */
        encodeheader(trk, thissec, diskid0, diskid1, head);
        /* sector data
            0       7 (data address mark)
            1-256   data
            257     checksum
            258-259 dummy
        */
        encodesector(encroffs, gap2val);
        encroffs += 0x100;
    }

    /*gcrlenbuffer[trk * 2] = (gcrout - &gcrbuffer[trk * 2][0]);*/
    gcrlenbuffer[head][trk * 2] = gcrtrklen[zone];

    /* fill up rest of the track */
    rest = (unsigned int)((&gcrbuffer[head][trk * 2][0] + GCRMAXTRACKLEN) - gcrout);
    if (rest) {
        memset(gcrout, 0x55, rest);
    }
}

void encoded64image(int tracks, int diskid0, int diskid1, int sides)
{
    int t, s, i, ts;
    unsigned char *buf = &d64buffer[0];

    for (t = 1; t <= tracks; t++) {
//        if (t == 18) 
        {
        gcrspdbuffer[0][t * 2][0] = (trkzone[t] == 4) ? 0 : trkzone[t] ^ 3;
        gcrspdbuffer[0][t * 2][1] = 0;
        gcrspdbuffer[0][t * 2][2] = 0;
        gcrspdbuffer[0][t * 2][3] = 0;
        encodetrack(buf, t, diskid0, diskid1, 0);
        }
        buf += 0x100 * sectors[trkzone[t]];
    }

    if (sides == 2) {
        buf = &d71buffer[0];
        for (t = 1; t <= tracks; t++) {
    //        if (t == 18) 
            {
            gcrspdbuffer[1][t * 2][0] = (trkzone[t] == 4) ? 0 : trkzone[t] ^ 3;
            gcrspdbuffer[1][t * 2][1] = 0;
            gcrspdbuffer[1][t * 2][2] = 0;
            gcrspdbuffer[1][t * 2][3] = 0;
            encodetrack(buf, t, diskid0, diskid1, 1);
            }
            buf += 0x100 * sectors[trkzone[t]];
        }
    }
}

/******************************************************************************/

/* 0x0c bytes g64 header */
/*
$0000-0007: File signature "GCR-1541"
      0008: G64 version (presently only $00 defined)
      0009: Number of tracks in image (usually $54, decimal 84)
 000A-000B: Maximum track size in bytes in LO/HI format
 
 000C-      84 * 32 bit offset to track data
 0152-      84 * 32 bit speed zone data
*/
/*  */
/*  */
/* 84 * track gcr data */

void saveg64(char *name, int halftracks, int sides)
{
    FILE *out;
    int t, s, i, ts, off, len, head;
    unsigned char g64hdr[0x0c] = {
        0x47, 0x43, 0x52, 0x2D, 0x31, 0x35, 0x34, 0x31,
        0x00, /* version */
        0x54, /* tracks */
        0xF8, 0x1E  /* max. track size */
    };
    unsigned char g71hdr[0x0c] = {
        0x47, 0x43, 0x52, 0x2D, 0x31, 0x35, 0x37, 0x31,
        0x00,
        0x54 * 2,
        0xF8, 0x1E
    };
    int gcrmaxlen = 0x1ef8;

    out = fopen(name, "wb");
    if (sides == 1) {
        /* 0x0c bytes g64 header */
        fwrite(g64hdr, 1, 0x0c, out);
        /* seek to end of file, clears it */
        fseek(out, 0x0c + (84 * 8) + (halftracks * GCRMAXTRACKLEN), SEEK_SET);

        /* 84 * 32 bit offset to track data */
        fseek(out, 0x0c, SEEK_SET);
        off = 0x2ac;
        for (t = 0; t < halftracks; t++) {
            if (gcrlenbuffer[0][t + 2]) {
                fputc((off >>  0) & 0xff, out);
                fputc((off >>  8) & 0xff, out);
                fputc((off >> 16) & 0xff, out);
                fputc((off >> 24) & 0xff, out);
                off += gcrlenbuffer[0][t + 2] + 2;
            } else {
                fputc(0, out);
                fputc(0, out);
                fputc(0, out);
                fputc(0, out);
            }
        }
        /* 84 * 32 bit speed zone data */
        fseek(out, 0x0c + (84 * 4), SEEK_SET);
        for (t = 0; t < halftracks; t++) {
            fwrite(gcrspdbuffer[0][t + 2], 1, 4, out);
        }
        /* 84 * track gcr data */
        fseek(out, 0x2ac, SEEK_SET);
        for (t = 0; t < halftracks; t++) {
            off = gcrlenbuffer[0][t + 2];
            if (off > 0) {
                fputc((off >>  0) & 0xff, out);
                fputc((off >>  8) & 0xff, out);
                fwrite(gcrbuffer[0][t + 2], 1, off, out);
            }
        }
    } else {
        fwrite(g71hdr, 1, 0x0c, out);
        /* seek to end of file, clears it */
        fseek(out, 0x0c + (2 * 84 * 8) + (2 * halftracks * GCRMAXTRACKLEN), SEEK_SET);

        /* 84 * 32 bit offset to track data */
        fseek(out, 0x0c, SEEK_SET);
        off = 0x2ac + (2 * 84 * 4);
        halftracks = 84;
        for (head = 0; head < 2; head++) {
            for (t = 0; t < halftracks; t++) {
                if (gcrlenbuffer[head][t + 2]) {
                    printf("offset head %d track %d offset %x\n", head, t, off);
                    fputc((off >>  0) & 0xff, out);
                    fputc((off >>  8) & 0xff, out);
                    fputc((off >> 16) & 0xff, out);
                    fputc((off >> 24) & 0xff, out);
//                    off += gcrlenbuffer[head][t + 2] + 2;
                    off += gcrmaxlen;
                } else {
                    fputc(0, out);
                    fputc(0, out);
                    fputc(0, out);
                    fputc(0, out);
                }
            }
        }
        /* 84 * 32 bit speed zone data */
        fseek(out, 0x0c + (2 * 84 * 4), SEEK_SET);
        for (head = 0; head < 2; head++) {
            for (t = 0; t < halftracks; t++) {
                fwrite(gcrspdbuffer[head][t + 2], 1, 4, out);
            }
        }
        /* 84 * track gcr data */
        off = 0x2ac + (2 * 84 * 4);
        for (head = 0; head < 2; head++) {
            for (t = 0; t < halftracks; t++) {
                len = gcrlenbuffer[head][t + 2];
                if (len > 0) {
                    printf("trackdata head %d track %d offset %x\n", head, t, off);
                    fseek(out, off, SEEK_SET);
                    fputc((len >>  0) & 0xff, out);
                    fputc((len >>  8) & 0xff, out);
                    fwrite(gcrbuffer[head][t + 2], 1, len, out);
                    off += gcrmaxlen;
                }
            }
        }
    }

    fclose(out);
}

void loadd64(char *name, int tracks, int sides)
{
    FILE *out;
    int t, s, i, ts;
    unsigned char *buf = &d64buffer[0];
    out = fopen(name, "rb");
    if (out == NULL) {
        fprintf(stderr, "error: could not open '%s'\n", name);
        exit(-1);
    }

    for (t = 1; t <= tracks; t++) {
        ts = sectors[trkzone[t]];
        for (s = 0; s < ts; s++) {
            fread(buf, 1, 256, out);
            buf += 0x100;
        }
    }

    if (sides == 2) {
        buf = &d71buffer[0];
        for (t = 1; t <= tracks; t++) {
            ts = sectors[trkzone[t]];
            for (s = 0; s < ts; s++) {
                fread(buf, 1, 256, out);
                buf += 0x100;
            }
        }
    }

    fclose(out);
}
void saved64(char *name, int tracks, int errors, int sides)
{
    FILE *out;
    int t, s, i, ts;
    unsigned char *buf = &d64buffer[0];

    out = fopen(name, "wb");

    /* output track data */
    for (t = 1; t <= tracks; t++) {
        ts = sectors[trkzone[t]];
        for (s = 0; s < ts; s++) {
            fwrite(buf, 1, 256, out);
            buf += 0x100;
        }
    }

    /* output track data for side 2*/
    if (sides == 2) {
        buf = &d71buffer[0];
        for (t = 1; t <= tracks; t++) {
            ts = sectors[trkzone[t]];
            for (s = 0; s < ts; s++) {
                fwrite(buf, 1, 256, out);
                buf += 0x100;
            }
        }
    }

    if (errors) {
        /* output error info */
        buf = &d64errors[0];
        for (t = 1; t <= tracks; t++) {
            ts = sectors[trkzone[t]];
            for (s = 0; s < ts; s++) {
                fwrite(buf, 1, 1, out);
                buf++;
            }
        }
        /* output error info for side 2*/
        if (sides == 2) {
            buf = &d71errors[0];
            for (t = 1; t <= tracks; t++) {
                ts = sectors[trkzone[t]];
                for (s = 0; s < ts; s++) {
                    fwrite(buf, 1, 1, out);
                    buf++;
                }
            }
        }
    }

    fclose(out);
}

/******************************************************************************/

void gentestimg(int tracks, int errors, int sides)
{
    int t, s, i, ts;
    unsigned char *buf;

    memset(d64buffer, 0, D64MAXSIZE);
    memset(d71buffer, 0, D64MAXSIZE);

    /* sector data (side 1) */
    buf = &d64buffer[0];
    for (t = 1; t <= tracks; t++) {
        ts = sectors[trkzone[t]];
        for (s = 0; s < ts; s++) {
            buf[0] = t;
            buf[1] = s;
            for (i = 2; i < 256; i++) {
                buf[i] = t ^ i;
                i++;
                buf[i] = s ^ i;
            }
            buf += 0x100;
        }
    }

    /* sector data (side 2) */
    if (sides == 2) {
        buf = &d71buffer[0];
        for (t = 1; t <= tracks; t++) {
            ts = sectors[trkzone[t]];
            for (s = 0; s < ts; s++) {
                buf[0] = (t + tracks) | 0x80;
                buf[1] = s | 0x80;
                for (i = 2; i < 256; i++) {
                    buf[i] = ((t + tracks) | 0x80) ^ i;
                    i++;
                    buf[i] = (s | 0x80) ^ i;
                }
                buf += 0x100;
            }
        }
    }

    memset(d64errors, 1, D64MAXSECTORS);
    memset(d71errors, 1, D64MAXSECTORS);
    if (errors) {
        buf = &d64errors[0];
        for (t = 1; t < 0x10; t++) {
            ts = sectors[trkzone[t]];
            for (s = 0; s < ts; s++) {
                *buf = t;
                buf++;
            }
        }
        if (sides == 2) {
            buf = &d71errors[0];
            for (t = 1; t < 0x10; t++) {
                ts = sectors[trkzone[t]];
                for (s = 0; s < ts; s++) {
                    *buf = t;
                    buf++;
                }
            }
        }
    }
}

/******************************************************************************/

void usage(void)
{
    printf( "tagd64      -\n"
            "tagd71      -\n"
            "tagd64err   -\n"
            "tagd71err   -\n"
            "d64tog64    -\n"
            "d71tog71    -\n"
    );
    exit(-1);
}

int main(int argc, char *argv[])
{
    char *outname;
    char *inname;
    int tracks;

    if (argc < 4) {
        usage();
    }

    if (!strcmp(argv[1], "tagd64")) {
        outname = argv[2];
        tracks = atoi(argv[3]);
        gentestimg(tracks, 0, 1);
        saved64(outname, tracks, 0,1);
    } else if (!strcmp(argv[1], "tagd71")) {
        outname = argv[2];
        tracks = atoi(argv[3]);
        gentestimg(tracks, 0, 2);
        saved64(outname, tracks, 0, 2);
    } else if (!strcmp(argv[1], "tagd64err")) {
        outname = argv[2];
        tracks = atoi(argv[3]);
        gentestimg(tracks, 1, 1);
        saved64(outname, tracks, 1, 1);
    } else if (!strcmp(argv[1], "tagd71err")) {
        outname = argv[2];
        tracks = atoi(argv[3]);
        gentestimg(tracks, 1, 2);
        saved64(outname, tracks, 1, 2);
    } else if (!strcmp(argv[1], "d64tog64")) {
        inname = argv[2];
        outname = argv[3];
        tracks = atoi(argv[4]);
        loadd64(inname, tracks, 1);
        encoded64image(tracks, 0x13, 0x37, 1);
        saveg64(outname, tracks * 2, 1);
    } else if (!strcmp(argv[1], "d71tog71")) {
        inname = argv[2];
        outname = argv[3];
        tracks = atoi(argv[4]);
        loadd64(inname, tracks, 2);
        encoded64image(tracks, 0x13, 0x37, 2);
        saveg64(outname, tracks * 2, 2);
    } else {
        usage();
    }

    return 0;
}
