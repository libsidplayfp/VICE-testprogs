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


static void read_section_fmt0(FILE *fp, Dump *p)
{
    int area, mode, bank;
    AreaScan *initial = &p->initial;

    /* get the initial state of the 5 mapped areas (AreaScan) */
    for (area = 0; area < 5; area++) {
	initial->v[area] = fgetc(fp);
    }

    /* get the mapping four modes (ModeScan) */
    for (mode = 0; mode < 4; mode++) {
	ModeScan *ms = &p->mode[mode];
	BankScan *bs = &ms->ram;
	for (area = 0; area < 5; area++) {
	    for (bank = 0; bank < 8; bank++) {
		bs->v[area][bank] = fgetc(fp);
	    }
	}
	bs = &ms->rom;
	for (area = 0; area < 5; area++) {
	    for (bank = 0; bank < 8; bank++) {
		bs->v[area][bank] = fgetc(fp);
	    }
	}
    }
}

static void read_dump_fmt0(FILE *fp)
{
    /* $DE01 configuration */
    de01_conf = fgetc(fp);

    /* load dumps */
    fseek(fp, 0x22, SEEK_SET);
    read_section_fmt0(fp, &rst);
    read_section_fmt0(fp, &cnfd);
    read_section_fmt0(fp, &frz);
    read_section_fmt0(fp, &ackd);
}

static void read_dump(const char *name)
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


    if (format_rev == 0) {
	read_dump_fmt0(fp);
	fclose(fp);
	return;
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



static void v_to_str_fmt0(char *str, uint8_t v)
{
    char buf[16];
    char *p;

    if (v == 0xff) {
	sprintf(str, " - ");
	return;
    }
    if (v == 0xfe) {
	sprintf(str, " ? ");
	return;
    }

    p = buf;

    *p++ = ' ';
    if (v & 0x80) {
	/* ROM bank */
	*p++ = 'A' + (v & 0x0f);
    } else {
	/* RAM bank */
	*p++ = '0' + (v & 0x0f);
    }
    if (v & 0x40) {
	/* read/write */
    } else {
	/* read only */
	*p++ = '*';
    }
    *p = 0;

    sprintf(str, "%-3s", buf);
}

static void v_to_str(char *str, uint8_t v)
{
    char buf[16];
    char *p;

    if (v == 0xfe) {
	sprintf(str, " ? ");
	return;
    }
    if (v == 0xff) {
	sprintf(str, " - ");
	return;
    }
    /* prefill pattern means we have encountered unwritten memory
       (0xaa was used up to rr-freeze r06) */
    if (v == 0xaa) {
	sprintf(str, "err");
	return;
    }

    p = buf;
    switch (v & 0x30) {
    case 0x00:
	/* not write through */
	/* not $01 switchable */
	*p++ = '^';
	break;
    case 0x10:
	/* not write through */
	/* $01 switchable */
	*p++ = ' ';
	break;
    case 0x20:
	/* write through */
	/* not $01 switchable */
	*p++ = '}';
	break;
    case 0x30:
	/* not write through */
	/* not $01 switchable */
	*p++ = '!';
	break;
    }
    if (v & 0x80) {
	/* ROM bank */
	*p++ = 'A' + (v & 0x0f);
    } else {
	/* RAM bank */
	*p++ = '0' + (v & 0x0f);
    }
    if (v & 0x40) {
	/* read/write */
    } else {
	/* read only */
	*p++ = '*';
    }
    *p = 0;

    sprintf(str, "%-3s", buf);
}

static void v_to_str_raw(char *str, uint8_t v)
{
    switch (v) {
    case 0xfe:
	sprintf(str, "?? ");
	break;
    case 0xff:
	sprintf(str, "-- ");
	break;
    default:
	sprintf(str, "%02x ", v);
	break;
    }
}


char vmap[256][4];
char vmap_left[256][4];

static void setup_vmap(int raw_hex)
{
    int v;
    for (v = 0; v < 0x100; v++) {
	if (!raw_hex) {
	    if (format_rev == 0) {
		v_to_str_fmt0(vmap[v], v);
	    } else {
		v_to_str(vmap[v], v);
	    }
	} else {
	    v_to_str_raw(vmap[v], v);
	}
	/* create left aligned version of the vmap */
	if (vmap[v][0] == ' ') {
	    sprintf(vmap_left[v], "%-3s", &vmap[v][1]);
	} else {
	    memcpy(vmap_left[v], vmap[v], 4);
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
	printf("  %02X:%s", areas[i], vmap_left[d->initial.v[i]]);
    }
    printf("\n");


    printf("\n scan of all banks/modes:\n");
    for (k = 0; k < 4; k++) {
	printf("      x01xx0%c%c -> $DE00 (RAM)",
	       (k & 2) ? '1':'0',
	       (k & 1) ? '1':'0'
	);
	printf("            x00xx0%c%c -> $DE00 (ROM)",
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


    read_dump(infile);
    printf("analyzing file: %s\n", infile);
    printf("  program: %s, format: %d\n", ident, format_rev);

    setup_vmap(raw_hex);

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
	if (format_rev == 1) {
	    printf(
"   ^     -> not $01 switchable\n"
"   !     -> write through to C64 RAM\n"
"   }     -> write through to C64 RAM and not $01 switchable\n"
	    );
	}
	printf(
"   -     -> no cart detected\n"
"   ?     -> mapping mismatch (e.g $de not mapped to $9e and similar)\n"
"\n"
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
	printf(
"   --    -> no cart detected\n"
"   ??    -> mapping mismatch (e.g $de not mapped to $9e and similar)\n"
"\n"
	);
    }

    exit(0);
}
/* eof */
