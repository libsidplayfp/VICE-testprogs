//============================================================================
// Name        : LogPrint.c
// Author      : Wolfgang Moser
// Version     :
// Copyright   : (C) 2008 Wolfgang Moser
// License     : 
// Description :
//============================================================================

#include "LogPrint.h"

FILE *logfile = NULL;

int printenabled = 1;

int lprintf(const char* format, ...) {
    va_list ap;
    va_start(ap, format);

    if (printenabled) {
        vprintf(format, ap);
    }
    if (logfile != NULL) {
        vfprintf(logfile, format, ap);
    }

    va_end(ap);
}

void printenable(int n)
{
    printenabled = n;
}
