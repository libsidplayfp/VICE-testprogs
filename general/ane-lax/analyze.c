/*
 * FILE  analyze.c
 *
 * Copyright (c) 2011 Daniel Kahlin <daniel@kahlin.net>
 * Written by Daniel Kahlin <daniel@kahlin.net>
 *
 * DESCRIPTION
 *   analysis of ane-lax.prg dumps.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#define ACC_STRIDE 3
#define XR_STRIDE 5
#define SCAN_LEN 0x1200


uint8_t ane_buf[SCAN_LEN * 4];
uint8_t lax_buf[SCAN_LEN * 4];

void read_dump(const char *name)
{
    FILE *fp = fopen(name, "rb");
    if (!fp) {
	fprintf(stderr, "couldn't open file\n");
	exit(-1);
    }

    /* skip header */
    fseek(fp, 0x42, SEEK_CUR);

    fread(ane_buf, 1, SCAN_LEN * 4, fp);
    fread(lax_buf, 1, SCAN_LEN * 4, fp);

    fclose(fp);
}

int match_ane(uint8_t *tab, uint8_t op, uint8_t c)
{
    int i;
    uint8_t acc, xr;
    int match = 0;

    acc = 0;
    xr = 0;
    for (i = 0; i < SCAN_LEN; i++) {
	uint8_t acc_r;

	acc_r = (acc | c) & (xr & op);
	if (acc_r == tab[i])
	    match++;

	acc += ACC_STRIDE;
	xr += XR_STRIDE;
    }

    return match;
}


int match_lax(uint8_t *tab, uint8_t op, uint8_t c)
{
    int i;
    uint8_t acc, xr;
    int match = 0;

    acc = 0;
    xr = 0;
    for (i = 0; i < SCAN_LEN; i++) {
	uint8_t acc_r;

	acc_r = (acc | c) & op;
	if (acc_r == tab[i])
	    match++;

	acc += ACC_STRIDE;
	xr += XR_STRIDE;
    }

    return match;
}


uint8_t ops[] = {
    0xff, 0x00, 0x5a, 0xa5
};

struct Bin {
    uint8_t b;
    int count;
};

static int cmpfunc(const void *ap, const void *bp)
{
    struct Bin *a = (struct Bin *)ap;
    struct Bin *b = (struct Bin *)bp;

    if (a->count < b->count) 
	return 1;
    if (b->count > a->count) 
	return -1;
    return 0;
}

int main(int argc, char *argv[])
{
    read_dump(argv[1]);

    int c;
    int i;
    struct Bin match[256];

    for (i = 0; i < 256; i++) {
	match[i].b = i;
	match[i].count = 0;
    }

    for (c = 0x00; c <= 0xff; c++) {
	for (i = 0; i < 4; i++) {
	    match[c].count += match_ane(ane_buf + SCAN_LEN * i, ops[i], c);
	}
    }

    qsort(match, 256, sizeof(struct Bin), cmpfunc);

    if (match[0].count == SCAN_LEN * 4) {
	printf("ANE ($8B) matches: Acc = (Acc | $%02X) & X & #<imm>\n", match[0].b);
    } else {
	printf("ANE ($8B) does not match: Acc = (Acc | CONST) & X & #<imm>\n");
	printf("(closest CONST = $%02X, %d errors)\n", match[0].b, SCAN_LEN*4-match[0].count);
    }


    for (i = 0; i < 256; i++) {
	match[i].b = i;
	match[i].count = 0;
    }

    for (c = 0x00; c <= 0xff; c++) {
	for (i = 0; i < 4; i++) {
	    match[c].count += match_lax(lax_buf + SCAN_LEN * i, ops[i], c);
	}
    }

    qsort(match, 256, sizeof(struct Bin), cmpfunc);

    if (match[0].count == SCAN_LEN * 4) {
	printf("LAX ($AB) matches: Acc = (Acc | $%02X) & #<imm>\n", match[0].b);
    } else {
	printf("LAX ($AB) does not match: Acc = (Acc | CONST) & #<imm>\n");
	printf("(closest CONST= $%02X, %d errors)\n", match[0].b, SCAN_LEN*4-match[0].count);
    }

    exit(0);
}
/* eof */
