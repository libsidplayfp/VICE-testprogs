//============================================================================
// Name        : ReuExec.c
// Author      : Wolfgang Moser
// Version     :
// Copyright   : (C) 2008 Wolfgang Moser
// License     : 
// Description : 
//============================================================================

#include "ReuExec.h"

#ifdef DOALL
#define CHECKTIMING
#define CHECKREGS
#endif

const unsigned char timeCompensationOffset = 25;
unsigned char statusMask = 0xef;    // mask out the DRAM configuration bit
unsigned char bankMask = 0xf8;

static const char *dumpString =
    "   %s 0x%02x/%02x:%02x,0x%02x,0x%04x,0x%06lx/%02xffff:0x%06lx,0x%04x,0x%02x,0x%02x,0x%02x/%02x:%02x,%ld\n";

static signed long readRecentTimer( void ) {
    signed long timer;

    timer = CIA2.tb_hi;
    timer <<= 8;
    timer |= CIA2.tb_lo;
    timer <<= 8;
    timer |= CIA2.ta_hi;
    timer <<= 8;
    timer |= CIA2.ta_lo;
    timer ^= 0xFFFFFFFF;

    timer -= timeCompensationOffset;    // implementation dependent timing offset

    return timer;
}

signed char doReuOperation( unsigned char command,
    unsigned short C64adr, unsigned long REUadr, unsigned short length,
    enum irqMode iMode, enum fixedType adrMode ) {
    signed char result;

    *((unsigned short *)0xDF02) = C64adr;
    *((unsigned long *)0xDF04) = REUadr; // overlap with length (MSB)
    *((unsigned short *)0xDF07) = length;
    *((unsigned char *)0xDF09) = iMode;
    *((unsigned char *)0xDF0A) = adrMode;

    (void)( *((unsigned char *)0xDF00) );   // clear status

    if( ( result = reuexec( command ) ) != 0 ) {
        lprintf( "Warning: Real REU timer measurement routine timeout, no measurement done.\n" );
    }

    return result;
}

/**
 * @return 0, if the (masked) register dumps are equal
 *         1, if the register dumps are not equal
 */
signed char monitorRegisterDump( unsigned char errorOnly, const struct expectSet *expResult ) {
    unsigned char statusSnapshot;
    unsigned char error;
    signed long recentTimerValue;
    unsigned char terror, rerror;

    statusSnapshot = *((unsigned char  *)0xDF00);
    recentTimerValue = readRecentTimer();

    error  = ( ( statusSnapshot              ^  expResult->status )  & statusMask ) != 0;
    error |=     *((unsigned char  *)0xDF01) != expResult->command;
    error |=     *((unsigned short *)0xDF02) != expResult->C64adr;

    error |=     *((unsigned short *)0xDF04) != ( expResult->REUadr & 0xffff );
    error |= ( ( *((unsigned char  *)0xDF06) ^ (expResult->REUadr >> 16) ) & bankMask ) != 0;

    error |=     *((unsigned short *)0xDF07) != expResult->length;

    error |=     *((unsigned char  *)0xDF09) != expResult->iMode;
    error |=     *((unsigned char  *)0xDF0A) != expResult->adrMode;

    // do not check for adresses 0xdf0a...0xdf1f == 0xff

    error = 0;
#ifdef CHECKREGS
    rerror = ( ( lstatus ^ expResult->irqStatus ) & statusMask ) != 0;
    regserrors += rerror;
    error |= rerror; 
#endif
#ifdef CHECKTIMING
    terror = (recentTimerValue != expResult->cycles);
    timererrors += terror;
    error |= terror;
#endif
    if( error != 0 ) {
        lprintf( "REU register assertion failed for test=%s\n", expResult->description );
        lprintf( dumpString, "expected:", 
            expResult->status, statusMask, (expResult->status & statusMask),
            expResult->command,
            expResult->C64adr,
            expResult->REUadr, bankMask, (expResult->REUadr & ((bankMask << 16) + 0xffff)),
            expResult->length,
            expResult->iMode,
            expResult->adrMode,
            expResult->irqStatus, statusMask, (expResult->irqStatus & statusMask),
            expResult->cycles
            );
        lprintf( dumpString, "but got: ", 
            statusSnapshot, statusMask, (statusSnapshot & statusMask),
            *((unsigned char  *)0xDF01),
            *((unsigned short *)0xDF02),
            *((unsigned long *)0xDF04) & 0xffffffL, bankMask, (*((unsigned long *)0xDF04) & 0xffffffL & ((bankMask << 16) + 0xffff)),
            *((unsigned short *)0xDF07),
            *((unsigned char  *)0xDF09),
            *((unsigned char  *)0xDF0A),
            lstatus, statusMask, (lstatus & statusMask),
            recentTimerValue
            );
        lprintf( "Test Status: Timing: %s Register: %s\n",
                (terror == 0) ? "ok" : "error", (rerror == 0) ? "ok" : "error");
        return 1;
    }
    else if( errorOnly == 0 ) {
        lprintf( "REU register monitoring for test=%s\n", expResult->description );
        lprintf( dumpString, "dump:", 
            statusSnapshot, statusMask, (statusSnapshot & statusMask),
            *((unsigned char  *)0xDF01),
            *((unsigned short *)0xDF02),
            *((unsigned long *)0xDF04) & 0xffffffL, bankMask, (*((unsigned long *)0xDF04) & 0xffffffL & ((bankMask << 16) + 0xffff)),
            *((unsigned short *)0xDF07),
            *((unsigned char  *)0xDF09),
            *((unsigned char  *)0xDF0A),
            lstatus, statusMask, (lstatus & statusMask),
            recentTimerValue
            );
        lprintf( "Test Status: Timing: %s Register: %s\n",
                (terror == 0) ? "ok" : "error", (rerror == 0) ? "ok" : "error");
    }
    return 0;
}

/**
 * @return 0, if the (masked) register dumps are equal
 *         1, if the register dumps are not equal
 */
signed char assertRegisterDump( const struct expectSet *expResult ) {
    return monitorRegisterDump( 0, expResult );
}

/**
 * @return 0, if the (masked) register dumps are equal
 *         1, if the register dumps are not equal
 */
signed char assertRegisterDumpErrorOnly( const struct expectSet *expResult ) {
    return monitorRegisterDump( 1, expResult );
}
