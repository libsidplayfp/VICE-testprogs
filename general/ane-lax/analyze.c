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
    int match = 1;

    acc = 0;
    xr = 0;
    for (i = 0; i < SCAN_LEN; i++) {
	uint8_t acc_r;

	acc_r = (acc | c) & (xr & op);
	if (acc_r != tab[i])
	    match = 0;

	acc += ACC_STRIDE;
	xr += XR_STRIDE;
    }

    return match;
}


int match_lax(uint8_t *tab, uint8_t op, uint8_t c)
{
    int i;
    uint8_t acc, xr;
    int match = 1;

    acc = 0;
    xr = 0;
    for (i = 0; i < SCAN_LEN; i++) {
	uint8_t acc_r;

	acc_r = (acc | c) & op;
	if (acc_r != tab[i])
	    match = 0;

	acc += ACC_STRIDE;
	xr += XR_STRIDE;
    }

    return match;
}


uint8_t ops[] = {
    0xff, 0x00, 0x5a, 0xa5
};

int main(int argc, char *argv[])
{
    read_dump(argv[1]);

    uint8_t c;
    int i;
    int match, found;
    found = 0;
    for (c = 0xff; c >= 0x00; c++) {
	for (i = 0; i < 4; i++) {
	    match = match_ane(ane_buf + SCAN_LEN * i, ops[i], c);
	    if (!match)
		break;
	}
	if (match) {
	    found = 1;
	    break;
	}
    }
    if (found) {
	printf("ANE ($8B) matches: Acc = (Acc | $%02X) & X & #<imm>\n", c);
    } else {
	printf("ANE ($8B) does not match: Acc = (Acc | CONST) & X & #<imm>\n");
    }


    found = 0;
    for (c = 0xff; c >= 0x00; c++) {
	for (i = 0; i < 4; i++) {
	    match = match_lax(lax_buf + SCAN_LEN * i, ops[i], c);
	    if (!match)
		break;
	}
	if (match) {
	    found = 1;
	    break;
	}
    }
    if (found) {
	printf("LAX ($AB) matches: Acc = (Acc | $%02X) & #<imm>\n", c);
    } else {
	printf("LAX ($AB) does not match: Acc = (Acc | CONST) & #<imm>\n");
    }

    exit(0);
}
/* eof */
