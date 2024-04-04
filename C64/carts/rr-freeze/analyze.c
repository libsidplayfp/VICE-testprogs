/**************************************************************************
 *
 * FILE  analyze.c
 *
 * Copyright (c) 2016, 2024 Daniel Kahlin <daniel@kahlin.net>
 * Written by Daniel Kahlin <daniel@kahlin.net>
 *
 * DESCRIPTION
 *   analysis of rr-freeze.crt dumps.
 *
 ******/
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>

#define PROGRAM "analyze"
#define VERSION "0.2"


/* global variables */
int verbose_g;
int debug_g;


void panic(const char *str, ...)
{
    va_list args;

    fprintf(stderr, "%s: ", PROGRAM);
    va_start(args, str);
    vfprintf(stderr, str, args);
    va_end(args);
    fputc('\n', stderr);
    exit(1);
}


uint8_t areas[] = { 0x9e, 0xbe, 0xde, 0xdf, 0xfe };

typedef struct {
    uint8_t v[5];
} AreaScan;

typedef struct {
    uint8_t v[5][8];
} BankScan;

typedef struct {
    BankScan ram;
    BankScan rom;
} ModeScan;


typedef struct {
    AreaScan initial;
    ModeScan mode[4];
} Dump;


#define IDENT_STR "RR-FREEZE"
uint8_t ident[15];
uint8_t format_rev;

uint8_t de01_conf;

Dump rst;
Dump cnfd;
Dump frz;
Dump ackd;


void read_dump(const char *name)
{
    FILE *fp = fopen(name, "rb");
    if (!fp) {
	panic("couldn't open file");
    }

    /* skip header */
    fseek(fp, 0x2, SEEK_CUR);

    /* check file format */
    fread(&ident, 1, sizeof(ident), fp);
    format_rev = fgetc(fp);

    if (memcmp(IDENT_STR, ident, strlen(IDENT_STR)) != 0) {
	panic("unsupported file format!");
    }
    if (format_rev != 0 && format_rev != 1) {
	panic("unsupported format revision (%d)!", format_rev);
    }

    /* $DE01 configuration */
    de01_conf = fgetc(fp);

    /* load dumps */
    fseek(fp, 0x22, SEEK_SET);
    fread(&rst, 1, sizeof(Dump), fp);
    fread(&cnfd, 1, sizeof(Dump), fp);
    fread(&frz, 1, sizeof(Dump), fp);
    fread(&ackd, 1, sizeof(Dump), fp);

    fclose(fp);
}



static void v_to_str(char *str, uint8_t v)
{
    if (v == 0xff) {
	str[0] = '-';
	str[1] = ' ';
	str[2] = 0;
	return;
    }
    if (v == 0xfe) {
	str[0] = '?';
	str[1] = ' ';
	str[2] = 0;
	return;
    }

    if (v & 0x80) {
	/* ROM bank */
	str[0] = 'A' + (v & 0x0f);
    } else {
	/* RAM bank */
	str[0] = '0' + (v & 0x0f);
    }
    if (v & 0x40) {
	/* read/write */
	str[1] = ' ';
    } else {
	/* read only */
	str[1] = '*';
    }
    str[2] = 0;

}

static void v_to_str_raw(char *str, uint8_t v)
{
    switch (v) {
    case 0xfe:
	sprintf(str, "? ");
	break;
    case 0xff:
	sprintf(str, "- ");
	break;
    default:
	sprintf(str, "%02x", v);
	break;
    }
}


char vmap[256][4];

static void setup_vmap(int raw_hex)
{
    int v;
    for (v = 0; v < 0x100; v++) {
	if (!raw_hex) {
	    v_to_str(vmap[v], v);
	} else {
	    v_to_str_raw(vmap[v], v);
	}
    }
}


static void print_dump(Dump *d, char *str)
{
    int i, j, k;

    /* initial */
    printf("\n--- %s ---\n", str);
    printf(" detected initial state:\n");
    for (i = 0; i < 5; i++) {
	printf("  %02X:%s", areas[i], vmap[d->initial.v[i]]);
    }
    printf("\n");


    printf("\n scan of all banks/modes:\n");
    for (k = 0; k < 4; k++) {
	printf("      x01xx0%c%c -> $DE00 (RAM)",
	       (k & 2) ? '1':'0',
	       (k & 1) ? '1':'0'
	);
	printf("    x00xx0%c%c -> $DE00 (ROM)",
	       (k & 2) ? '1':'0',
	       (k & 1) ? '1':'0'
        );
	printf("\n");

	/* bank scan */
	for (i = 0; i < 5; i++) {
	    printf("  %02X: ", areas[i]);
	    /* RAM */
	    for (j = 0; j < 8; j++) {
		uint8_t v =  d->mode[k].ram.v[i][j];
		printf("%s ", vmap[v]);
	    }
	    printf("   ");
	    /* ROM */
	    for (j = 0; j < 8; j++) {
		uint8_t v =  d->mode[k].rom.v[i][j];
		printf("%s ", vmap[v]);
	    }
	    printf("\n");
	}
    }
    printf("-------------\n");

}



int main(int argc, char *argv[])
{
    int c;
    char *infile;
    int raw_hex;

    /* defaults */
    verbose_g = 0;
    debug_g = 0;
    raw_hex = 0;

    /*
     * scan for valid options
     */
    while (EOF != (c = getopt(argc, argv, "rvdVh"))) {
        switch (c) {

	/* a missing parameter */
	case ':':
	/* an illegal option */
	case '?':
	    exit(1);

	/* set verbose mode */
	case 'v':
	    verbose_g = 1;
	    break;

	/* set debug mode */
	case 'd':
	    debug_g = 1;
	    break;

	/* print version */
	case 'V':
	    fprintf(stdout, PROGRAM " " VERSION "\n");
	    exit(0);

	/* print help */
	case 'h':
	    fprintf(stderr,
PROGRAM " " VERSION ": rr-freeze.crt dump analyzer\n"
"Copyright (c) 2016, 2024 Daniel Kahlin <daniel@kahlin.net>\n"
"Written by Daniel Kahlin <daniel@kahlin.net>\n"
"\n"
"usage: " PROGRAM " [-r][-v][-d][-h][-V] <file>\n"
"\n"
"Valid options:\n"
"    -r              raw hex output\n"
"    -v              be verbose\n"
"    -d              display debug information\n"
"    -h              displays this help text\n"
"    -V              output program version\n"
	    );
	    exit(0);

	/* raw hex mode */
	case 'r':
	    raw_hex = 1;
	    break;

	/* default behavior */
	default:
	    break;
	}
    }

    /* optind now points at the first non option argument */
    argc -= optind;
    argv += optind;

    /* expect one more argument */
    if (argc < 1)
    	panic("too few arguments");
    if (argc > 1)
    	panic("too many arguments");
    infile = argv[0];



    setup_vmap(raw_hex);
    read_dump(infile);
    printf("analyzing file: %s\n", infile);
    printf("  program: %s, format: %d\n", ident, format_rev);

    printf("\n<RESET>\n");
    print_dump(&rst, "RST");
    printf("\n$%02X -> $DE01  (REU-Comp=%c, NoFreeze=%c, AllowBank=%c)\n",
	   de01_conf,
	   (de01_conf & 0x40) ? '1':'0',
	   (de01_conf & 0x04) ? '1':'0',
	   (de01_conf & 0x02) ? '1':'0'
    );
    print_dump(&cnfd, "CNFD");
    printf("\n$88 -> $DE00  (\"random\" mapping, bank 5 in ROM)\n$8C -> $DE00 (kill)\n");
    printf("\n<FREEZE>\n");
    print_dump(&frz, "FRZ");
    printf("\n$60 -> $DE00  (ACK)\n$20 -> $DE00\n");
    print_dump(&ackd, "ACKD");

    printf(
"\n\n"
"LEGEND:\n"
    );
    if (!raw_hex) {
	printf(
"   0-7   -> RAM banks 0-7, an '*' means read only.\n"
"   A-H   -> ROM banks 0-7, should have an '*', otherwise it is writable (!)\n"
	);
    } else {
	if (format_rev == 1) {
	    printf(
"   RWTS0BBB (R=ROM, W=RW, T=WriteC64, S=Switch01, B=bank)\n"
	    );
	} else {
	    printf(
"   RW000BBB (R=ROM, W=RW, B=bank)\n"
	    );
	}
    }
    printf(
"   -     -> no cart detected\n"
"   ?     -> mapping mismatch (e.g $de not mapped to $9e and similar)\n"
"\n"
    );

    exit(0);
}
/* eof */
