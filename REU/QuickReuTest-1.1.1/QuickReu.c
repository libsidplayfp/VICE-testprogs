//============================================================================
// Name        : REC-Test.c
// Author      : Wolfgang Moser
// Version     :
// Copyright   : (C) 2008 Wolfgang Moser
// License     : Licensed on a personal agreement basis (NDA)
// Description : Commodore RAM Expansion Unit (REU) Controller
//               (REC, 8726R1) behavior compatibility test
//============================================================================

#include <stdlib.h>
#include "version.h"
#include "LogPrint.h"
#include "ReuExec.h"

        // 0xe2f7..0xfffa (0x1d04) -> 0x01e378..0x01ffff
        // 0xe266..0xe269 (0x0004) -> 0x020000..0x020003
        // 0xe2f7..0xfffc (0x1d06) -> 0x01e378..0x020001

#define _ADDBUFLENGTH_ 0x0004    // four differing bytes (against bytes behind verify buffer):  !=, ==, !=, !=
#define _VRFBUFEND_    0xfffb    // last address+1 of equal verify buffer (plus 4 more for comparisons) 
#define _VRFBUFSTART_  ( 0xe200 | ( ( 0xfffb - _ADDBUFLENGTH_) & 0xff ) )
                                 // high byte must be identical to provoced verify error buffer
                                 // calculated length must result in a low byte value of 0x04
#define _VRFBUFLENGTH_ (_VRFBUFEND_ - _VRFBUFSTART_)      // 0x1d04
#define _TIMERCYCLES_  (0L + _VRFBUFEND_ - _VRFBUFSTART_) // 0x1d04L
#define _VRFFAILSTLOW_ 0xe266    // high byte must be identical to _VRFBUFSTART_
#define _ADDBUFCYCLES_ (0L + _ADDBUFLENGTH_)

#define _VBUFREUEND_   0x01ffffL
#define _VBREUSTART_   (_VBUFREUEND_ - _VRFBUFLENGTH_)


struct expectSet expStdTransfer =   { 0x40, DisFF00 | C64toREU,       _VRFBUFEND_,     _VBUFREUEND_,      0x0001,            DisBoth, Normal,  0x00, _TIMERCYCLES_,           "std transfer (2.3.1, 2.3.3)" };
struct expectSet expHalBug =        { 0x00, DisFF00 | C64toREU,       _VRFFAILSTLOW_,  _VBUFREUEND_,     _ADDBUFLENGTH_,     DisBoth, Normal,  0x00, _TIMERCYCLES_,           "HAL bug (3.2)" };
struct expectSet expDblHalBug =     { 0x00, DisFF00 | EnAutoL | SWAP, _VRFFAILSTLOW_,  _VBREUSTART_,     _ADDBUFLENGTH_,     EnBoth,  Normal,  0xc0, _ADDBUFCYCLES_ * 2,      "double HAL bug (2.3.5)" };
struct expectSet expVrfErrLast =    { 0x00, DisFF00 | VERIFY,         _VRFBUFEND_ + 1, _VBUFREUEND_ + 1, 0x0001,             EnVrfy,  Normal,  0xe0, _TIMERCYCLES_ - 1,       "vrfy err last (2.3.1, 2.3.6, 2.3.8, 2.3.9)" };
struct expectSet expVrfErr2ndLst1 = { 0x00, DisFF00 | VERIFY,         _VRFBUFEND_ + 1, _VBUFREUEND_ + 1, 0x0001,             EnEot,   Normal,  0xe0, _TIMERCYCLES_,           "vrfy err 2nd last 1 (2.3.3, 2.3.6, 2.3.8, 2.3.9, 2.3.10)" };
struct expectSet expSwapTransfer =  { 0x40, EnAutoL | DisFF00 | SWAP, _VRFBUFSTART_,   _VBREUSTART_,     _VRFBUFLENGTH_ + 2, EnVrfy,  Normal , 0x00, (_TIMERCYCLES_ + 2) * 2, "swap transfer (2.3.5)" };
struct expectSet expVrfErr2ndLst2 = { 0x20, DisFF00 | VERIFY,         _VRFBUFEND_ + 3, _VBUFREUEND_ + 3, 0x0001,             EnEot,   Normal,  0x00, _TIMERCYCLES_ + 4,       "vrfy err 2nd last 2 (2.3.6, 2.3.8, 2.3.9)" };
struct expectSet expStatusFlagOr =  { 0x60, DisFF00 | REUtoC64,       _VRFBUFSTART_,   0x080003L,        0x0001,             DisBoth, FixC64,  0x00, _ADDBUFCYCLES_,          "status flag oring (2.3.1, 2.3.8, 2.3.9)" };
struct expectSet expSelfTest =      { 0xc5, DoExec  | SWAP,           0x1234,          0x56789a,         0xbcde,             DisVrfy, FixBoth, 0xe2, 0x5682L,                 "self test, must fail" };

static const unsigned char recStuckBits[ 0x20 ] =
    { 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0xf8, 0x00, 0x00, 0x1f, 0x3f,
      0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
      0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };

/*
 * return values greater than zero mean that a REU is detected
 *   +1 means that 1700 REU was detected with 64KiBx1 chips used
 *   +2 means that non-1700 REU was detected
 * 
 * return values of zero or less mean that a REU was not detected
 */
static signed char checkBasicDecoding( void ) {
    unsigned char statusFlags;
    unsigned char i, j;

    statusFlags = *((unsigned char  *)0xDF00);

    i=0;
    do {
        // check status register
        if( ( *((unsigned char  *)0xDF00) & statusMask ) != 0x00 ) {
            lprintf( "REU status unstable, REU not present\n" );
            return -1;
        }
        // check address mirroring, read-only
        for( j=0x00; j<0x0b; ++j ) {
            if( *((unsigned char  *)(0xDF00+j)) != *((unsigned char  *)(0xDF00+i+j)) ) {
                lprintf( "Address mirroring incorrect for mirror 0x%02x (2.1)\n", i );
                if( i == 0 ) {
                    lprintf( "Base address (mirror 0) register instability detected\n" );
                    return -2;
                }
                break;
            }
        }
        for( ; j<0x20; ++j ) {
            if( *((unsigned char  *)(0xDF00+i+j)) != 0xFF ) {
                lprintf( "Address mapping incorrect for mirror 0x%02x (2.1)\n", i );
                break;
            }
        }
        i+=0x20;
    } while (i>0x1f);

    return ( ( statusFlags & 0x10 ) == 0x10 ) ? 2 : 1;
}

/*
 * the return value delivers the banking register bitmask of unused bits 
 */
static unsigned char checkRegisterStuckBits( void ) {
    unsigned char i, stuckbits, errors;

    ( void ) *((unsigned char  *)0xDF00);   // clear status flag

    bankMask = ~recStuckBits[ 0x06 ];

    errors = 0;
    // check masking and stuck bits of 0xdf00...0xdf0a
    for( i=0x00; i<0x20; ++i ) {
        switch( i ) {
            default:
                *((unsigned char  *)(0xDF00+i)) = 0xFF;
                stuckbits = ~( *((unsigned char  *)(0xDF00+i)) ); // get bits that remained 0

                *((unsigned char  *)(0xDF00+i)) = 0x00;
                stuckbits |= *((unsigned char  *)(0xDF00+i)); // get bits that remained 1
                break;
            case 0x01:
            case 0x11:
                *((unsigned char  *)(0xDF00+i)) = 0x7F;   // disable ff00 decoding, don't transfer
                stuckbits  = 0x7F ^ ( *((unsigned char  *)(0xDF00+i)) );

                *((unsigned char  *)(0xDF00+i)) = 0x80;   // enable ff00 decoding, prepare transfer
                stuckbits |= 0x80 ^ ( *((unsigned char  *)(0xDF00+i)) );
                break;
        }
        if( stuckbits != recStuckBits[i] ) {
            lprintf( "REC stuck bit emulation incorrect for register 0xDF%02x (2.2, 2.3.3, 2.4.2)\n", i );
            if( i == 0x06 ) {
                bankMask = ~stuckbits;
                lprintf( "  Setting new banking register mask to 0x%02x\n", bankMask );
            }
            errors++;
        }
    }

    *((unsigned char  *)(0xDF01)) = DisFF00 | C64toREU;
    return errors;
}

unsigned char timererrors = 0;
unsigned char regserrors = 0;


#ifdef DOALL
#define SHOWINFO
#define DOTEST1
#define DOTEST2
#define DOTEST3
#define DOTEST4
#define DOTEST5
#define DOTEST6
#define DOTEST7
#define DOTEST8
#define DOSELFTEST
#endif

int main(void) {
    unsigned char type17xx;
    unsigned char failedTestclasses = 0;

    putchar(0x93);

#ifndef DISABLELOGFILE
    logfile = fopen( "quickreutest.log", "w" );
    if( logfile==NULL ) {
        fprintf(stderr, "Logfile open/write error" );
    }
#endif
#ifdef SHOWINFO
    lprintf( _TITLE_STRING_ _COPYRIGHT_, _VERSION_STRING_ );
#endif
    type17xx = checkBasicDecoding();
    if( type17xx <= 0 ) {
        lprintf( "REU controller (REC) register set not detected\n" );
        return 1;
    }
#ifdef SHOWINFO
    lprintf( "Testing REU with %s.\n",
        ( type17xx == 2 ) ? "256Kix1 memory chips (1764/1750)" : "64Kix1 memory chips (1700)" );
#endif
    failedTestclasses += checkRegisterStuckBits();
    {
        // write Kernal contents into REU
        // 0xe2f7..0xfffa (0x1d04) -> 0x01e378..0x01ffff
#ifdef DOTEST1
        failedTestclasses +=
#endif
            doReuOperation( DoExec | DisFF00 | C64toREU,    // no autoload
                _VRFBUFSTART_, _VBREUSTART_, _VRFBUFLENGTH_, DisBoth, Normal );
#ifdef DOTEST1
        failedTestclasses += assertRegisterDump( &expStdTransfer );
#else
        assertRegisterDumpErrorOnly( &expStdTransfer );
#endif

    }
    {
        // checkHalfAutoloadBug();
        *((unsigned char *)0xDF08) = 0x00; // write to length high byte only
        *((unsigned char *)0xDF06) = 0x01; // write to bank register
        *((unsigned char *)0xDF02) = _VRFFAILSTLOW_ & 0xFF; // write to low C64 address
#ifdef DOTEST2
        failedTestclasses += assertRegisterDump( &expHalBug );
#else
        assertRegisterDumpErrorOnly( &expHalBug );
#endif
    }
    {
        // checkHALbugExtended();
        *((unsigned char *)0xDF09) = EnBoth; // Enable both interrupts
        // write four more bytes into REU behind the last buffer
        // 0xe266..0xe269 (0x0004) -> 0x020000..0x020003
        if( reuexec( DoExec | EnAutoL | SWAP ) != 0 ) {
#ifdef DOTEST3
            failedTestclasses++;
#endif
            lprintf( "Warning: Real REU timer measurement routine timeout, no measurement done.\n" );
        }
#ifdef DOTEST3
        failedTestclasses += assertRegisterDump( &expDblHalBug );
#else
        assertRegisterDumpErrorOnly( &expDblHalBug );
#endif
    }
    {
        // check 1700 special wrap around from 0xf9ffff to 0xf80000
        // check verify error on last byte
#ifdef DOTEST4
        failedTestclasses +=
#endif
            doReuOperation( DoExec | DisFF00 | VERIFY,    // no autoload
                _VRFBUFSTART_ + 2, _VBREUSTART_ + 2, _VRFBUFLENGTH_ - 1, EnVrfy, Normal );
        if( type17xx == 1 ) {
            // prepare 1700 expected value
            expVrfErrLast.REUadr = (_VBUFREUEND_ + 1) & 0x01ffffL;
        }
#ifdef DOTEST4
        failedTestclasses += assertRegisterDump( &expVrfErrLast );
#else
        assertRegisterDumpErrorOnly( &expVrfErrLast );
#endif
    }
    {
        // check verify error on second to last byte with last byte identical
#ifdef DOTEST5
        failedTestclasses +=
#endif
            doReuOperation( DoExec | VERIFY,    // no autoload
                _VRFBUFSTART_ + 2, _VBREUSTART_ + 2, _VRFBUFLENGTH_, DisBoth, Normal );
        if( type17xx == 1 ) {
            // prepare 1700 expected value
            expVrfErr2ndLst1.REUadr = (_VBUFREUEND_ + 1) & 0x01ffffL;
        }
        // check that no interrupt was asserted yet and enable EOT interrupt manually
        if( lstatus != 0 ) {
            lprintf( "Assertion failed, REU IRQ was executed after second to last byte verify error test\n" );
        }
        // check manual interrupt generation upon interrupt enable
        enableReuIrq();
        *((unsigned char *)0xDF09) = EnEot; // enable EOT IRQ only
        disableReuIrq();

#ifdef DOTEST5
        failedTestclasses += assertRegisterDump( &expVrfErr2ndLst1 );
#else
        assertRegisterDumpErrorOnly( &expVrfErr2ndLst1 );
#endif
    }
    {        
        // write Kernal contents into REU, so following 2 bytes both differ
        // 0xe2f7..0xfffc (0x1d06) -> 0x01e378..0x020001
#ifdef DOTEST6
        failedTestclasses +=
#endif
            doReuOperation( DoExec | EnAutoL | DisFF00 | SWAP,
                _VRFBUFSTART_, _VBREUSTART_, _VRFBUFLENGTH_ + 2, EnVrfy, Normal );
#ifdef DOTEST6
        failedTestclasses += assertRegisterDump( &expSwapTransfer );
#else
        assertRegisterDumpErrorOnly( &expSwapTransfer );
#endif

    }
    {
        // check verify error on second to last byte with last byte differing also
        // values are autoloaded, so change length only
        *((unsigned char *)0xDF07) = (_VRFBUFLENGTH_ + 4) & 0xFF; // write to length low byte only
        *((unsigned char *)0xDF09) = EnEot; // enable EOT IRQ only
        if( reuexec( DoExec | VERIFY ) != 0 ) {
#ifdef DOTEST7
            failedTestclasses++;
#endif
            lprintf( "Warning: Real REU timer measurement routine timeout, no measurement done.\n" );
        }
        if( type17xx == 1 ) {
            // prepare 1700 expected value
            expVrfErr2ndLst2.REUadr = (_VBUFREUEND_ + 3) & 0x01ffffL;
        }
#ifdef DOTEST7
        failedTestclasses += assertRegisterDump( &expVrfErr2ndLst2 );
#else
        assertRegisterDumpErrorOnly( &expVrfErr2ndLst2 );
#endif
    }
    {
        // check no automatic flag clearing
        // one vrfy error trigger, one EOT trigger
#ifdef DOTEST8
        failedTestclasses += 
#endif
            doReuOperation( DoExec | DisFF00 | VERIFY,
                _VRFBUFSTART_, _VBUFREUEND_ + 1, _ADDBUFLENGTH_, DisBoth, FixREU );
        // check some more REU wrap around things
#ifdef DOTEST8
        failedTestclasses +=
#endif
            doReuOperation( DoExec | DisFF00 | REUtoC64,
                _VRFBUFSTART_, 0x07ffffL, _ADDBUFLENGTH_, DisBoth, FixC64 );
#ifdef DOTEST8
        failedTestclasses += assertRegisterDump( &expStatusFlagOr );
#else
        assertRegisterDumpErrorOnly( &expStatusFlagOr );
#endif
    }
#ifdef DOSELFTEST
    {
        lprintf( "\nDoing self test, check test operation:\n" );
        failedTestclasses += ( 1 - assertRegisterDump( &expSelfTest ) );
    }
#else
    timererrors += 1;
    regserrors += 1;
#endif
             //1234567890123456789012345678901234567890
    lprintf("\nTest classes with failures: %u\n", failedTestclasses);
#ifdef DOALL
    if (failedTestclasses) {
        lprintf("(Timing: %u, Registers: %u)\n", timererrors - 1, regserrors - 1);
    }
#endif

    if (logfile != NULL) {
        fclose(logfile);
    }

    if (failedTestclasses) {
        *((unsigned char *)0xd020) = 10;
        *((unsigned char *)0xd7ff) = 0xff; /* failure */
    } else {
        *((unsigned char *)0xd020) = 5;
        *((unsigned char *)0xd7ff) = 0x00; /* ok */
    }

    while(1) {}
}
