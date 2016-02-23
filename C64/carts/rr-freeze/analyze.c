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


typedef struct {
    uint8_t v_9e;
    uint8_t v_be;
    uint8_t v_de;
    uint8_t v_df;
    uint8_t v_fe;
} AreaScan;

typedef struct {
    uint8_t v_9e[8];
    uint8_t v_be[8];
    uint8_t v_de[8];
    uint8_t v_df[8];
    uint8_t v_fe[8];
} BankScan;

typedef struct {
    BankScan ram;
    BankScan rom;
} ModeScan;


typedef struct {
    AreaScan initial;
    ModeScan mode[4];
} Dump;


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
    fseek(fp, 0x22, SEEK_CUR);

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
    int i;
    /* initial */
    printf("%s  9E:%s  BE:%s  DE:%s  DF:%s  FE:%s\n",
	   str,
	   vmap[d->initial.v_9e],
	   vmap[d->initial.v_be],
	   vmap[d->initial.v_de],
	   vmap[d->initial.v_df],
	   vmap[d->initial.v_fe]
   );


    printf(" 9E: ");
    /* RAM */
    for (i = 0; i < 8; i++) {
	printf("%s ", vmap[d->mode[0].ram.v_9e[i]]);
    }
    printf("   ");
    /* ROM */
    for (i = 0; i < 8; i++) {
	printf("%s ", vmap[d->mode[0].rom.v_9e[i]]);
    }
    printf("\n");

    printf(" BE: ");
    /* RAM */
    for (i = 0; i < 8; i++) {
	printf("%s ", vmap[d->mode[0].ram.v_be[i]]);
    }
    printf("   ");
    /* ROM */
    for (i = 0; i < 8; i++) {
	printf("%s ", vmap[d->mode[0].rom.v_be[i]]);
    }
    printf("\n");

    printf(" DE: ");
    /* RAM */
    for (i = 0; i < 8; i++) {
	printf("%s ", vmap[d->mode[0].ram.v_de[i]]);
    }
    printf("   ");
    /* ROM */
    for (i = 0; i < 8; i++) {
	printf("%s ", vmap[d->mode[0].rom.v_de[i]]);
    }
    printf("\n");

    printf(" DF: ");
    /* RAM */
    for (i = 0; i < 8; i++) {
	printf("%s ", vmap[d->mode[0].ram.v_df[i]]);
    }
    printf("   ");
    /* ROM */
    for (i = 0; i < 8; i++) {
	printf("%s ", vmap[d->mode[0].rom.v_df[i]]);
    }
    printf("\n");

    printf(" FE: ");
    /* RAM */
    for (i = 0; i < 8; i++) {
	printf("%s ", vmap[d->mode[0].ram.v_fe[i]]);
    }
    printf("   ");
    /* ROM */
    for (i = 0; i < 8; i++) {
	printf("%s ", vmap[d->mode[0].rom.v_fe[i]]);
    }
    printf("\n");

}



int main(int argc, char *argv[])
{

    setup_vmap();
    read_dump(argv[1]);

    print_dump(&rst, "RST ");
    print_dump(&cnfd, "CNFD");
    print_dump(&frz, "FRZ ");
    print_dump(&ackd, "ACKD");


    exit(0);
}
/* eof */
