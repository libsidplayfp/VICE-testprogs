/*
 * FILE  analyze.c
 *
 * Copyright (c) 2016 Daniel Kahlin <daniel@kahlin.net>
 * Written by Daniel Kahlin <daniel@kahlin.net>
 *
 * DESCRIPTION
 *   analysis of rr-freeze.crt dumps.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>


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


uint8_t ident[16];

uint8_t de01_conf;

Dump rst;
Dump cnfd;
Dump frz;
Dump ackd;


void read_dump(const char *name)
{
    FILE *fp = fopen(name, "rb");
    if (!fp) {
	fprintf(stderr, "couldn't open file\n");
	exit(-1);
    }

    /* skip header */
    fseek(fp, 0x2, SEEK_CUR);
    fread(&ident, 1, sizeof(ident), fp);

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
	str[0] = 'A' + (v & 0x3f);
    } else {
	/* RAM bank */
	str[0] = '0' + (v & 0x3f);
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

char vmap[256][4];

static void setup_vmap(void)
{
    int v;
    for (v = 0; v < 0x100; v++) {
	v_to_str(vmap[v], v);
    }
}


static void print_dump(Dump *d, char *str)
{
    int i, j, k;

    /* initial */
    printf("\n%s", str);
    for (i = 0; i < 5; i++) {
	printf("  %02X:%s", areas[i], vmap[d->initial.v[i]]);
    }
    printf("\n");


    for (k = 0; k < 4; k++) {
	printf("     x01xx0%c%c -> $DE00 (RAM)",
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
	    printf(" %02X: ", areas[i]);
	    /* RAM */
	    for (j = 0; j < 8; j++) {
		printf("%s ", vmap[d->mode[k].ram.v[i][j]]);
	    }
	    printf("   ");
	    /* ROM */
	    for (j = 0; j < 8; j++) {
		printf("%s ", vmap[d->mode[k].rom.v[i][j]]);
	    }
	    printf("\n");
	}
    }

}



int main(int argc, char *argv[])
{

    setup_vmap();
    read_dump(argv[1]);
    printf("analyzing file: %s\n", argv[1]);
    printf("  program: %s, format: %d\n", ident, ident[15]);

    printf("\n<RESET>\n");
    print_dump(&rst, "RST ");
    printf("\n$%02X -> $DE01  (REU-Comp=%c, NoFreeze=%c, AllowBank=%c)\n",
	   de01_conf,
	   (de01_conf & 0x40) ? '1':'0',
	   (de01_conf & 0x04) ? '1':'0',
	   (de01_conf & 0x02) ? '1':'0'
    );
    print_dump(&cnfd, "CNFD");
    printf("\n$88 -> $DE00  (\"random\" mapping, bank 5 in ROM)\n$8C -> $DE00 (kill)\n");
    printf("\n<FREEZE>\n");
    print_dump(&frz, "FRZ ");
    printf("\n$60 -> $DE00  (ACK)\n$20 -> $DE00\n");
    print_dump(&ackd, "ACKD");

    printf(
"\n\n"
"LEGEND:\n"
"   0-7   -> RAM banks 0-7, an '*' means read only.\n"
"   A-H   -> ROM banks 0-7, should have an '*', otherwise its writable (!)\n"
"   -     -> no cart detected\n"
"   ?     -> mapping mismatch (e.g $de not mapped to $9e and similar)\n"
    );

    exit(0);
}
/* eof */
