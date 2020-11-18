//============================================================================
// Name        : ReuExec.h
// Author      : Wolfgang Moser
// Version     :
// Copyright   : (C) 2008 Wolfgang Moser
// License     : Licensed on a personal agreement basis (NDA)
// Description :
//============================================================================

#ifndef __ReuExec_H
#define __ReuExec_H

#include <c64.h>
#include "LogPrint.h"

enum transferType {
    C64toREU = 0x00,
    REUtoC64 = 0x01,
    SWAP     = 0x02,
    VERIFY   = 0x03,

    DisFF00  = 0x10,
    EnAutoL  = 0x20,
    DoExec   = 0x80,
};

enum irqMode {
    DisNone  = 0x1f,
    DisVrfy  = 0x3f,
    DisEot   = 0x5f,
    DisBoth  = 0x7f,
    EnNone   = 0x9f,
    EnVrfy   = 0xbf,
    EnEot    = 0xdf,
    EnBoth   = 0xff,
};

enum fixedType {
    Normal   = 0x3f,
    FixREU   = 0x7f,
    FixC64   = 0xbf,
    FixBoth  = 0xff
};

struct expectSet {
    unsigned char status;
    unsigned char command;
    unsigned short C64adr;
    unsigned long REUadr;   // only the lower 24 bits count
    unsigned short length;
    enum irqMode iMode;
    enum fixedType adrMode;
    unsigned char irqStatus;
    signed long cycles;
    char *description;
};

extern unsigned char statusMask;
extern unsigned char bankMask;

extern unsigned char lstatus;
extern unsigned short oldirq;

extern unsigned char timererrors;
extern unsigned char regserrors;

extern void __fastcall__ enableReuIrq( void );
extern void __fastcall__ disableReuIrq( void );
extern signed char __fastcall__ reuexec( unsigned char command );

extern signed char doReuOperation( unsigned char command,
    unsigned short C64adr, unsigned long REUadr, unsigned short length,
    enum irqMode iMode, enum fixedType adrMode );
extern signed char monitorRegisterDump( unsigned char errorOnly, const struct expectSet *expResult );
extern signed char assertRegisterDump( const struct expectSet *expResult );
extern signed char assertRegisterDumpErrorOnly( const struct expectSet *expResult );

#endif
