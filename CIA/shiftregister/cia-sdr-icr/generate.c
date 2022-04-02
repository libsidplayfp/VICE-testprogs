/*
 * This program generates the same reference values as cia-sdr-icr-v3.asm,
 * but in a hopefully more readable way.
 *
 * Usage: ./generate <timer value>
 *
 * where <timer value> is what's called baud in the .asm program.
 */

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#define SAMPLES		1000

uint8_t reference1[SAMPLES];
uint8_t reference2[SAMPLES];

uint8_t *storeref;

uint8_t baud;			// RO
uint8_t count1;			// 1
uint8_t expected1;		// 1
uint8_t delaysetsdr1;		// 1
uint8_t newvalue;		// 1

uint8_t bits;			// 1, 2

uint8_t count2;			// 2
uint8_t expected2;		// 2
uint8_t clearmask;		// 2
uint8_t clearsdrdelay;		// 2
uint8_t delaysetsdr;
uint8_t sdrpipe;

uint8_t SDRFINAL  = 0x04;	// 04 for normal, 08 for 4485
uint8_t BOUNCESDR = 0x08;	// 08 for normal, 00 for 4485

#define OFFSET1 29
#define OFFSET2 40
//#define OFFSET1 0
//#define OFFSET2 0

#define SDRDELAYFLAG 0x02

#define INT_TA	0x01
#define INT_SDR	0x08

void reset1();
uint8_t check1();
void reset2();
uint8_t check2();

void reset1()
{
    count1 = baud;
    if (baud <= 3) {
	delaysetsdr1 = baud | 0x04;
    } else {
	delaysetsdr1 = baud;
    }

    expected1 = 0x00;
    newvalue = INT_TA;
    bits = 0x0f;

    for (int i = 0; i < OFFSET1; i++) {
	check1();
    }

    storeref = &reference1[0];
}

/*
 * Simulate 1 clock for Timer A.
 *
 * This models: if you 
 * - clear the ICR
 * - start the timer
 * - and the shifter,
 * - clear the ICR
 * - wait some time (each next call 1 cycle longer),
 * - look at the ICR again
 * this is what you'll see in the interrupt flags.
 */
uint8_t check1()
{
    /* If latch is 0, always set the TA int bit */
    if (baud == 0) {
	return 0x01;
    }

    /* Decrement the counter 1 clock */
    count1--;

    /* Underflow? */
    if (count1 >= 0x80) {
	count1 = baud;	/* reload from latch */
	expected1 = newvalue;
	bits--;		/* one shift step */

	if (bits == 0) {/* shifting is done? */
	    newvalue = INT_TA | INT_SDR;	/* next time, SDR bit is also on */
	    /* Instead of counting down from the latch, now count down until
	     * SDR bit gets set. Which is the same time, or | 0x04.
	     */
	    count1 = delaysetsdr1;
	}
    }

    return expected1;
}

void reset2()
{
    count2 = baud;
    if (baud < 6) {
	clearmask = ~0;
    } else {
	clearmask = ~INT_TA;
    }

    expected2 = 0x00;
    clearsdrdelay = 0x00;
    delaysetsdr = 0x00;

    bits = 0x0F;
    sdrpipe = 0x14;

    int times = OFFSET2;
    if (baud == 0x02) {
	times -= 3;		// HACK for Timer A = 2
    }
    for (int i = 0; i < times; i++) {
	check2();
    }

    storeref = &reference2[0];
}

/*
 * Simulate 1 clock for Timer A.
 *
 * This models: if you 
 * - clear the ICR
 * - start the timer
 * - and the shifter,
 * - clear the ICR
 * - wait some time (each next call 1 cycle longer),
 * - clear the ICR,
 * - stop the timer,
 * -  ...and spend some time on other stuff
 * - clear the ICR
 * - start the timer
 * - and the shifter,
 * - look at the ICR
 *
 * this is what you'll see in the interrupt flags.
 * There are remaining effects from the previous shifting activity.
 */
uint8_t check2()
{
    if (baud == 0) {
	return INT_TA | INT_SDR;
    }

    if (--count2 >= 0x80) {
	/* Timer underflow */
	count2 = baud;
	expected2 |= INT_TA;

	if (bits != 0) {
	    bits--;	// half a bit shift of the shift register
	    if (bits == 0) {
		sdrpipe = SDRFINAL;	 // 0x04; delay 5; depends on chip type; always even
	    }
//plus_sdrfinal:
	    if ((bits & 1) == 0) {
		clearsdrdelay |= BOUNCESDR;	// 0x08; delay 4; chip type dependent

		delaysetsdr |= sdrpipe;	// 0x14 until changed to 0x04 when bits == 0
					// delays 3, 5, then 5
		goto plus_clearsdrdelay;
		// So this turn on after 3, off after 4, on after 5 again;
		// for the last shifted bit only on after 5.
		// Note that stopping the timer takes 2 cycles too.
	    }
	}
//clearsdr:
	clearsdrdelay |= SDRDELAYFLAG;	// 0x02; delay 6
    } else {
//clearta:
	expected2 &= clearmask;	// mask depends on TA latch only; keeps TA or nothing.
    }

plus_clearsdrdelay:
    if (clearsdrdelay & 0x80) {
	expected2 &= ~INT_SDR;
    }
    clearsdrdelay <<= 1;

plus_delaysetsdr:
    if (delaysetsdr & 0x80) {
	expected2 |= INT_SDR;
    }
    delaysetsdr <<= 1;
    /* Leave out the bit with ignore, only relevant to ignore the differences
     * with the 4485 chips
     *
     * carry = ignore & 0x80;
     * ignore <<= 1;
     * if (carry) {
     *     return a = *source;
     * }
     */

    return expected2;
}

void dumphex(uint8_t *table, int size)
{
    for (int i = 0; i < size; i++) {
	if (i % 16 == 0) {
	    printf("%04x: ", i);
	}
	printf("%02x", table[i]);
	if (i % 16 == 7) {
	    printf("|");
	} else if (i % 8 == 3) {
	    printf(".");
	} else if (i % 16 == 15) {
	    printf("\n");
	} else {
	    printf(" ");
	}
    }
    printf("\n");
}

void dumpchars(uint8_t *table, int size)
{
    for (int i = 0; i < size; i++) {
	if (i % 40 == 0) {
	    printf("%04x: ", i);
	}
	printf("%c", "@AbcdefgHIjklmnopqrstuvwxyz"[table[i]]);
	if (i % 40 == 39) {
	    printf("\n");
	}
    }
    printf("\n");
}

int main(int argc, char *argv[])
{
    baud = 39;

    if (argc > 1) {
	baud = strtol(argv[1], NULL, 0);
    }

    reset1();
    for (int i = 0; i < SAMPLES; i++) {
	*storeref++ = check1();
    }

    reset2();
    for (int i = 0; i < SAMPLES; i++) {
	*storeref++ = check2();
    }

    dumphex(reference1, SAMPLES);
    dumphex(reference2, SAMPLES);

    dumpchars(reference1, SAMPLES);
    dumpchars(reference2, SAMPLES);

    return 0;
}
