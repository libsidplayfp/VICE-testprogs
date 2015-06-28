//============================================================================
// Name        : LogPrint.h
// Author      : Wolfgang Moser
// Version     :
// Copyright   : (C) 2008 Wolfgang Moser
// License     : Licensed on a personal agreement basis (NDA)
// Description :
//============================================================================

#ifndef LOGPRINT_H_
#define LOGPRINT_H_

#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>

extern FILE *logfile; 

extern int lprintf(const char* format, ...);

#endif /*LOGPRINT_H_*/
