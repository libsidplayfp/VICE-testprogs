
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAXLISTS    0x10
#define MAXTESTS    2000
#define MAXPATHLEN  0x100

#define BLUE    "\033[1;34m"
#define YELLOW  "\033[1;33m"
#define GREEN   "\033[1;32m"
#define RED     "\033[1;31m"
#define GREY    "\033[1;30m"
#define WHITE   "\033[1;29m"
#define NC      "\033[0m"

#define FORMAT_TEXT 0
#define FORMAT_HTML 1
#define FORMAT_WIKI 2

int verbose = 0;
int format = 0;
int errormode = 0;
int diffmode = 0;
int filterntscold = 0;
int firstcolisref = 0;
char *referrorstring = NULL;
int firstrowispercent = 0;
char *percentagestring = NULL;
char *rankingpercentagestring = NULL;
int warnvicfetch = 0;
char *vicfetchstring = NULL;
int warnvicefail = 0;
char *vicefailstring = NULL;
int ranking = 0;

char *infilename[MAXLISTS];
int numfiles = 0;
char *headline[MAXLISTS];

#define RESULT_ERROR    0
#define RESULT_OK       1
#define RESULT_TIMEOUT  2
#define RESULT_NA       -1

#define TYPE_EXITCODE       0
#define TYPE_SCREENSHOT     1
#define TYPE_INTERACTIVE    2
#define TYPE_ANALYZER       3
#define TYPE_NA             -1

#define MEDIA_NONE  -1
#define MEDIA_D64   0   /* also d71/d81 */
#define MEDIA_G64   1   /* also g71 */
#define MEDIA_CRT   2

#define CIATYPE_UNSET   -1
#define CIATYPE_OLD      0
#define CIATYPE_NEW      1

#define SIDTYPE_UNSET   -1
#define SIDTYPE_OLD      0
#define SIDTYPE_NEW      1

#define VIDEOTYPE_UNSET   -1
#define VIDEOTYPE_PAL      0
#define VIDEOTYPE_NTSC     1
#define VIDEOTYPE_NTSCOLD  2
#define VIDEOTYPE_DREAN    3

typedef struct
{
    char path[MAXPATHLEN];
    char prog[MAXPATHLEN];
    int result;
    int expect;
    int type;
    char media[MAXPATHLEN];
    int mediatype;
    int ciatype;
    int sidtype;
    int videotype;
    char *comment;
    int warnvicfetch;
    int warnvicefail;
} TEST;

char *refname = NULL;
TEST reflist[MAXTESTS];
int refnum = 0;

TEST testlist[MAXLISTS][MAXTESTS];
int testnum[MAXLISTS];
int testfailed[MAXLISTS];

char *sfurl = "https://sourceforge.net/p/vice-emu/code/HEAD/tree/testprogs/testbench";

//------------------------------------------------------------------------------
void dumplist(TEST *list, int num)
{
    int i;
    fprintf(stderr, "dumping %d tests:\n", num);
    for(i = 0; i < num; i++) {
        fprintf(stderr, "%s,%s,%d,%d,%s,%d,%d,%d,%d\n",
            list[i].path,
            list[i].prog,
            list[i].result,
            list[i].type,
            list[i].media,
            list[i].mediatype,
            list[i].ciatype,
            list[i].sidtype,
            list[i].videotype
        );
    }
}

//------------------------------------------------------------------------------

char *copytocomma(char *dest, char *src)
{
    while ((*src != 0) && (*src != ',') && (*src != '\n')) {
        *dest++ = *src++;
    }
    *dest = 0;
    if (*src == ',') src++;
    return src;
}

void splitline(char *line, char *a1, char *a2, char *a3, char *a4, char *a5, char *a6, char *a7, char *a8, char *a9, char *a10)
{
    line = copytocomma(a1, line);
    line = copytocomma(a2, line);
    line = copytocomma(a3, line);
    line = copytocomma(a4, line);
    line = copytocomma(a5, line);
    line = copytocomma(a6, line);
    line = copytocomma(a7, line);
    line = copytocomma(a8, line);
    line = copytocomma(a9, line);
    line = copytocomma(a10, line);
}

//------------------------------------------------------------------------------

#define MAXOPTIONS  6

int readlist(TEST *list, char *name, int isresultfile)
{
    FILE *in;
    char line[0x100];
    char result[0x100];
    char type[0x100];
    char timeout[0x100];
    char opt[MAXOPTIONS][0x100];
    int num = 0;
    int len, i;

    in = fopen(name, "r");
    if (in == NULL) {
        fprintf(stderr, "error: could not open '%s'\n", name);
        return 0;
    }

    while(!feof(in)) {
        result[0] = 0;
        type[0] = 0;
        for (i = 0; i < MAXOPTIONS; i++) {
            opt[i][0] = 0;
        }
        timeout[0] = 0;
        if (fgets(line, 0x100, in) == NULL) {
            break; // stop if no line could be read
        }
        if (line[0] == '#') {
            continue; // skip comment lines
        }
        if (isresultfile) {
            splitline(line, list->path, list->prog, result, type, opt[0], opt[1], opt[2], opt[3], opt[4], opt[5]);
        } else {
            splitline(line, list->path, list->prog, type, timeout, opt[0], opt[1], opt[2], opt[3], opt[4], opt[5]);
        }
        // check error status
        if (!strcmp(result, "error")) {
            list->result = RESULT_ERROR;
        } else if (!strcmp(result, "ok")) {
            list->result = RESULT_OK;
        } else if (!strcmp(result, "timeout")) {
            list->result = RESULT_TIMEOUT;
        } else {
            list->result = RESULT_NA;
        }
        list->expect = RESULT_OK;

        // check test type
        if (!strcmp(type, "exitcode")) {
            list->type = TYPE_EXITCODE;
        } else if (!strcmp(type, "screenshot")) {
            list->type = TYPE_SCREENSHOT;
        } else if (!strcmp(type, "interactive")) {
            list->type = TYPE_INTERACTIVE;
        } else if (!strcmp(type, "analyzer")) {
            list->type = TYPE_ANALYZER;
        } else {
            list->type = TYPE_NA;
        }
        // check extra option for mounted media,cia/sid/vic type
        list->mediatype = MEDIA_NONE;
        list->ciatype = CIATYPE_UNSET;
        list->sidtype = SIDTYPE_UNSET;
        list->videotype = VIDEOTYPE_UNSET;
        list->comment = NULL;
        list->warnvicfetch = 0;
        list->warnvicefail = 0;
        if (isresultfile) {
            // 1) d64
            len = strlen(opt[0]);
            if (len > 0) {
                strcpy(list->media, opt[0]);
                list->mediatype = MEDIA_D64;
            }
            // 2) g64
            len = strlen(opt[1]);
            if (len > 0) {
                strcpy(list->media, opt[1]);
                list->mediatype = MEDIA_G64;
            }
            // 3) crt
            len = strlen(opt[2]);
            if (len > 0) {
                strcpy(list->media, opt[2]);
                list->mediatype = MEDIA_CRT;
            }
            // 4) cia
            if (!strcmp(opt[3], "0")) {
                list->ciatype = CIATYPE_OLD;
            } else if (!strcmp(opt[3], "1")) {
                list->ciatype = CIATYPE_NEW;
            }
            // 5) sid
            if (!strcmp(opt[4], "0")) {
                list->sidtype = SIDTYPE_OLD;
            } else if (!strcmp(opt[4], "1")) {
                list->sidtype = SIDTYPE_NEW;
            }
            // 6) video
            if (!strcmp(opt[5], "PAL")) {
                list->videotype = VIDEOTYPE_PAL;
            } else if (!strcmp(opt[5], "NTSC")) {
                list->videotype = VIDEOTYPE_NTSC;
            } else if (!strcmp(opt[5], "NTSCOLD")) {
                list->videotype = VIDEOTYPE_NTSCOLD;
            } else if (!strcmp(opt[5], "DREAN")) {
                list->videotype = VIDEOTYPE_DREAN;
            }
        } else {
            for (i = 0; i < MAXOPTIONS; i++) {
                if (!strcmp(opt[i], "cia-old")) {
                    list->ciatype = CIATYPE_OLD;
                } else if (!strcmp(opt[i], "cia-new")) {
                    list->ciatype = CIATYPE_NEW;
                }

                if (!strcmp(opt[i], "sid-old")) {
                    list->sidtype = SIDTYPE_OLD;
                } else if (!strcmp(opt[i], "sid-new")) {
                    list->sidtype = SIDTYPE_NEW;
                }

                if (!strcmp(opt[i], "vicii-pal")) {
                    list->videotype = VIDEOTYPE_PAL;
                } else if (!strcmp(opt[i], "vicii-ntsc")) {
                    list->videotype = VIDEOTYPE_NTSC;
                } else if (!strcmp(opt[i], "vicii-ntscold")) {
                    list->videotype = VIDEOTYPE_NTSCOLD;
                } else if (!strcmp(opt[i], "vicii-drean")) {
                    list->videotype = VIDEOTYPE_DREAN;
                }

                if (!strncmp(opt[i], "mountd64:", 9) || !strncmp(opt[i], "mountd71:", 9)) {
                    strcpy(list->media, &opt[i][9]);
                    list->mediatype = MEDIA_D64;
                } else if (!strncmp(opt[i], "mountg64:", 9) || !strncmp(opt[i], "mountg71:", 9)) {
                    strcpy(list->media, &opt[i][9]);
                    list->mediatype = MEDIA_G64;
                } else if (!strncmp(opt[i], "mountcrt:", 9)) {
                    strcpy(list->media, &opt[i][9]);
                    list->mediatype = MEDIA_CRT;
                }
                
                if (!strncmp(opt[i], "comment:", 8)) {
                    list->comment = strdup(&opt[i][8]);
                }
                if (!strncmp(opt[i], "warn:vicfetch", 13)) {
                    list->warnvicfetch = 1;
                }
                if (!strncmp(opt[i], "warn:vicefail", 13)) {
                    list->warnvicefail = 1;
                }
                if (!strncmp(opt[i], "expect:error", 12)) {
                    list->expect = RESULT_ERROR;
                }
                if (!strncmp(opt[i], "expect:timeout", 14)) {
                    list->expect = RESULT_TIMEOUT;
                }
                
            }
        }

        len = strlen(list->path);
        if ((len > 0) && (list->path[len - 1] == '/')) {
            list->path[len - 1] = 0;
        }
        num++;
        list++;
    }

    fclose(in);

    return num;
}

/* finds "item" in "list", returns pointer to list */
TEST *findresultitem(TEST *list, TEST *item)
{
    int i;
    // loop over all tests
    for (i = 0; i < refnum; i++) {
        if(!strcmp(list->path, item->path) && 
           !strcmp(list->prog, item->prog) &&
           !strcmp(list->media, item->media) &&
           (list->type == item->type) &&
           ((item->ciatype == CIATYPE_UNSET) || (list->ciatype == item->ciatype)) &&
           ((item->sidtype == SIDTYPE_UNSET) || (list->sidtype == item->sidtype)) &&
           ((item->videotype == VIDEOTYPE_UNSET) || (list->videotype == item->videotype)) &&
           (list->mediatype == item->mediatype)
          ) {
            return list;
        }
        list++;
    }
    return NULL; // not found
}

/* finds "item" in "list", returns result stored in "list" */
int findresult(TEST *list, TEST *item)
{
    int i;
    // loop over all tests
    for (i = 0; i < refnum; i++) {
        if(!strcmp(list->path, item->path) && 
           !strcmp(list->prog, item->prog) &&
           !strcmp(list->media, item->media) &&
           (list->type == item->type) &&
           ((item->ciatype == CIATYPE_UNSET) || (list->ciatype == item->ciatype)) &&
           ((item->sidtype == SIDTYPE_UNSET) || (list->sidtype == item->sidtype)) &&
           ((item->videotype == VIDEOTYPE_UNSET) || (list->videotype == item->videotype)) &&
           (list->mediatype == item->mediatype)
          ) {
            return list->result;
        }
        list++;
    }
    return -1; // not found
}


//------------------------------------------------------------------------------
void printdocumentstart(void)
{
    if (format == FORMAT_HTML) {
        printf(
            "<html>"
            "<head>"
//            "<title>VICE testbench results ("$target")</title>"
            "<style type=\"text/css\">"
            "body                  { background-color: #ffffff; color: #000000; font: normal 10px Verdana, Arial, sans-serif;}"
            "#maintable            { border-collapse: collapse; border: 1px solid black; }"
            "#maintable td         { border: 1px solid black; }"
            "#maintable td.inter   { background-color: #cccccc; color: #888888; }"
            "#maintable td.na      { background-color: #cccccc; color: #888888; }"
            "#maintable td.ok      { background-color: #ccffcc; color: #00ff00; }"
            "#maintable td.error   { background-color: #ffcccc; color: #ff0000; }"
            "#maintable td.timeout { background-color: #ccccff; color: #0000ff; }"
            "#rankstable            { border-collapse: collapse; border: 1px solid black; }"
            "#rankstable td         { border: 1px solid black; }"
            "</style>"
            "</head>"
            "<body>"
            "\n"
        );
    } else if (format == FORMAT_WIKI) {
    }
}

void printdocumentend(void)
{
    if (format == FORMAT_HTML) {
        printf("</html>"
               "\n"
        );
    } else if (format == FORMAT_WIKI) {
    }
}

void printtablestart(void)
{
    if (format == FORMAT_HTML) {
        printf(
            "<table style=\"width: 100%%\" id=\"maintable\">"
            "\n"
        );
    } else if (format == FORMAT_WIKI) {
        printf("{| class=\"wikitable sortable\" border=\"1\" cellpadding=\"2\" cellspacing=\"0\"\n");
    }
}

void printtableend(void)
{
    if (format == FORMAT_HTML) {
        printf("</table>"
               "\n"
        );
    } else if (format == FORMAT_WIKI) {
        printf("|}\n");
    }
}


void printranking(void)
{
    char tmp[0x100];
    int i, num, pass, percent;
    int sorted[0x100], sortnum = 0;
    int flipped, idx0, ii;

    for (i = (firstcolisref ? 1 : 0); i < numfiles; i++) {
        sorted[sortnum] = i;
        sortnum++;
    }
    
    // stupid bubblesort
    do {
        int idx0, num0, pass0, percent0;
        int idx1, num1, pass1, percent1;
        flipped = 0;
        for (i = 0; i < (sortnum-1); i++) {
            idx0 = sorted[i];
            num0 = testnum[idx0]; 
            pass0 = testnum[idx0] - testfailed[idx0];
            percent0 = (pass0 * 100) / num0;
            idx1 = sorted[i+1];
            num1 = testnum[idx1]; 
            pass1 = testnum[idx1] - testfailed[idx1];
            percent1 = (pass1 * 100) / num1;
            if ((percent1 > percent0) || 
                ((percent1 == percent0) && (pass1 > pass0))) {
                sorted[i] = idx1;
                sorted[i+1] = idx0;
                flipped=1;
            }
        }
    } while (flipped);

    switch (format) {
        case FORMAT_TEXT: 
            break;
        case FORMAT_HTML:
            printf("<table id=\"rankstable\"><tr>"
                   "<th></th>"
                   "<th>tested</th>"
                   "<th>passed</th>"
                   "<th>percent</th>"
                   "<th></th>"
                   "</tr>");
            break;
        case FORMAT_WIKI: 
            printf("{| class=\"wikitable sortable\" border=\"1\" cellpadding=\"2\" cellspacing=\"0\"\n"
                   "! |\n"
                   "! | tested\n"
                   "! | passed\n"
                   "! | percent\n"
                   "! |\n"
                   "|-\n"
            );
            break;
    }
    
    for (i = 0; i < sortnum; i++) {
        idx0 = sorted[i];
        num = testnum[idx0]; 
        pass = testnum[idx0] - testfailed[idx0];
        percent = (pass * 100) / num;
        switch (format) {
            case FORMAT_TEXT: 
                strcpy(tmp, headline[idx0]); tmp[19] = 0;
                printf(WHITE "%-20s " NC, tmp); 
                printf("[");
                for (ii = 0; ii < (percent / 4); ii++) {
                    printf("#");
                }
                for (; ii < (100 / 4); ii++) {
                    printf(" ");
                }
                printf("] %3d%%\n", percent);
                break;
            case FORMAT_HTML:
                printf("<tr>");
                printf("<td>%s</td>", headline[idx0]);
                printf("<td>%4d</td>", num);
                printf("<td>%4d</td>", pass);
                printf("<td>%3d%%</td><td>", percent);
                printf("<pre>");
                for (ii = 0; ii < (percent / 2); ii++) {
                    printf("#");
                }
                for (; ii < (100 / 2); ii++) {
                    printf("-");
                }
                printf("</pre>");
                printf("</td>");
                printf("</tr>");
                
                break;
            case FORMAT_WIKI: 
                printf("||%s\n", headline[idx0]); 
                printf("||%d\n", num); 
                printf("||%d\n", pass); 
                printf("||%d%%\n", percent); 
                printf("||"); 
                printf(rankingpercentagestring, percent, pass, num);
                printf("\n"); 
                printf("|-\n"); 
                break;
        }
    }
    
    switch (format) {
        case FORMAT_TEXT: 
            break;
        case FORMAT_HTML:
            printf("</table><p></p>");
            break;
        case FORMAT_WIKI:
            printf("|}\n");
            break;
    }
    printf("\n");
}

void printheader(void)
{
    char tmp[0x100];
    int i, num, pass;

    if (format == FORMAT_HTML) {
        printf("<tr>"
               "<th>Path</th>"
               "<th>Chip</th>"
               "<th>Type</th>"
        );
    } else if (format == FORMAT_WIKI) {
        printf(
               "! |Path\n"
               "! |Chip\n"
               "! |Type\n"
        );
    }

    for (i = (firstcolisref ? 1 : 0); i < numfiles; i++) {
        num = testnum[i]; pass = testnum[i] - testfailed[i];
        switch (format) {
            case FORMAT_TEXT: 
                strcpy(tmp, headline[i]); tmp[8] = 0;
                printf(WHITE "%-8s" NC, tmp); 
                break;
            case FORMAT_HTML:
                if (firstrowispercent) {
                    printf("<th width=110>%s<br>", headline[i]);
                    printf(percentagestring, (pass * 100) / num, pass, num);
                    printf("</th>");
                } else {
                    printf("<th width=110>%s</th>", headline[i]);
                }
                break;
            case FORMAT_WIKI: 
                if (firstrowispercent) {
                    printf("! width=\"80pt\" |%s ", headline[i]); 
                    printf(percentagestring, (pass * 100) / num, pass, num);
                    printf("\n"); 
                } else {
                    printf("! width=\"80pt\" |%s\n", headline[i]); 
                }
                break;
        }
    }
    
    if (format == FORMAT_TEXT) {
        printf("\n");
    } else if (format == FORMAT_HTML) {
        printf("</tr>\n");
    }

}

void printrowtestpath(int row, int res)
{
    switch (format) {
        case FORMAT_TEXT:
            printf("%s/ %s", reflist[row].path, reflist[row].prog); 
            switch (reflist[row].mediatype) {
                case MEDIA_D64:
                case MEDIA_G64:
                case MEDIA_CRT:
                    printf(" (%s)", reflist[row].media); 
                    break;
            }
        break;
        case FORMAT_HTML:
            printf("<td>");
            printf("<a href=\"%s/%s/\">%s</a>", 
                   sfurl, reflist[row].path, reflist[row].path);
            if (strlen(reflist[row].prog) > 0) {
                printf(" <a href=\"%s/%s/%s?format=raw\">%s</a>", 
                    sfurl, reflist[row].path, reflist[row].prog, reflist[row].prog); 
            }
            switch (reflist[row].mediatype) {
                case MEDIA_D64:
                case MEDIA_G64:
                case MEDIA_CRT:
                    printf(" (<a href=\"%s/%s/%s?format=raw\">%s</a>)", 
                           sfurl, reflist[row].path, reflist[row].media, reflist[row].media); 
                    break;
            }
            if (reflist[row].expect == RESULT_ERROR) {
                printf(" <small>(must always fail)</small>");
            }
            if (reflist[row].expect == RESULT_TIMEOUT) {
                printf(" <small>(must always timeout)</small>");
            }            
            if (reflist[row].comment) {
                printf(" <small>(%s)</small>", reflist[row].comment); 
            }
            if ((warnvicfetch) && (reflist[row].warnvicfetch)) {
                printf(" <small>(%s)</small>", vicfetchstring); 
            }
            if ((firstcolisref) && (res == RESULT_ERROR) &&
                (reflist[row].expect != RESULT_ERROR)) {
                printf(" %s", referrorstring);
            } else if ((warnvicefail) && (reflist[row].warnvicefail)) {
                printf(" %s", vicefailstring); 
            }
            printf("</td>");
        break;
        case FORMAT_WIKI:
            switch (reflist[row].type) {
                case TYPE_INTERACTIVE: printf("|style=\"background:lightgrey;\"|"); break;
                case TYPE_ANALYZER: printf("|style=\"background:lightgrey;\"|"); break;
                default: printf("||"); break;
            }
            printf("[%s/%s/ %s]", 
                   sfurl, reflist[row].path, reflist[row].path); 
            if (strlen(reflist[row].prog) > 0) {
                printf(" [%s/%s/%s?format=raw %s]", 
                    sfurl, reflist[row].path, reflist[row].prog, reflist[row].prog); 
            }
            switch (reflist[row].mediatype) {
                case MEDIA_D64:
                case MEDIA_G64:
                case MEDIA_CRT:
                    printf(" ([%s/%s/%s?format=raw %s])", 
                           sfurl, reflist[row].path, reflist[row].media, reflist[row].media); 
                    break;
            }
            if (reflist[row].expect == RESULT_ERROR) {
                printf(" <small>(must always fail)</small>");
            }
            if (reflist[row].expect == RESULT_TIMEOUT) {
                printf(" <small>(must always timeout)</small>");
            }            
            if (reflist[row].comment) {
                printf(" <small>(%s)</small>", reflist[row].comment); 
            }
            if ((warnvicfetch) && (reflist[row].warnvicfetch)) {
                printf(" %s", vicfetchstring); 
            }
            if ((firstcolisref) && (res == RESULT_ERROR) &&
                (reflist[row].expect != RESULT_ERROR)) {
                printf(" %s", referrorstring);
            } else if ((warnvicefail) && (reflist[row].warnvicefail)) {
                printf(" %s", vicefailstring); 
            }
            printf("\n");
        break;
    }
}

void printrowtesttype(int row)
{
    switch (format) {
        case FORMAT_TEXT:
            switch (reflist[row].type) {
                case TYPE_EXITCODE: printf("        "); break;
                case TYPE_SCREENSHOT: printf("screens "); break;
                case TYPE_INTERACTIVE: printf("interac "); break;
                case TYPE_ANALYZER: printf("analyze "); break;
            }
        break;
        case FORMAT_HTML:
            printf("<td>");
            switch (reflist[row].videotype) {
                case VIDEOTYPE_PAL: printf("PAL "); break;
                case VIDEOTYPE_NTSC: printf("NTSC "); break;
                case VIDEOTYPE_NTSCOLD: printf("NTSCOLD "); break;
                case VIDEOTYPE_DREAN: printf("DREAN "); break;
            }
            switch (reflist[row].ciatype) {
                case CIATYPE_OLD: printf("6526 "); break;
                case CIATYPE_NEW: printf("8521 "); break;
            }
            switch (reflist[row].sidtype) {
                case SIDTYPE_OLD: printf("6581 "); break;
                case SIDTYPE_NEW: printf("8580 "); break;
            }
            printf("</td>");
            switch (reflist[row].type) {
                case TYPE_EXITCODE: printf("<td></td>"); break;
                case TYPE_SCREENSHOT: printf("<td>screenshot</td>"); break;
                case TYPE_INTERACTIVE: printf("<td>interactive</td>"); break;
                case TYPE_ANALYZER: printf("<td>analyzer</td>"); break;
            }
        break;
        case FORMAT_WIKI:
            switch (reflist[row].type) {
                case TYPE_EXITCODE: printf("||"); break;
                case TYPE_SCREENSHOT: printf("||"); break;
                case TYPE_INTERACTIVE: printf("|style=\"background:lightgrey;\"|"); break;
                case TYPE_ANALYZER: printf("|style=\"background:lightgrey;\"|"); break;
            }
            switch (reflist[row].videotype) {
                case VIDEOTYPE_PAL: printf("PAL "); break;
                case VIDEOTYPE_NTSC: printf("NTSC "); break;
                case VIDEOTYPE_NTSCOLD: printf("NTSCOLD "); break;
                case VIDEOTYPE_DREAN: printf("DREAN "); break;
            }
            switch (reflist[row].ciatype) {
                case CIATYPE_OLD: printf("6526 "); break;
                case CIATYPE_NEW: printf("8521 "); break;
            }
            switch (reflist[row].sidtype) {
                case SIDTYPE_OLD: printf("6581 "); break;
                case SIDTYPE_NEW: printf("8580 "); break;
            }
            printf("\n");
            switch (reflist[row].type) {
                case TYPE_EXITCODE: printf("||\n"); break;
                case TYPE_SCREENSHOT: printf("||screenshot\n"); break;
                case TYPE_INTERACTIVE: printf("|style=\"background:lightgrey;\"|interactive\n"); break;
                case TYPE_ANALYZER: printf("|style=\"background:lightgrey;\"|analyzer\n"); break;
            }
        break;
    }
}

void printrowtestresult(int row, int res)
{
    switch (format) {
        case FORMAT_TEXT:
            switch (res) {
                case RESULT_ERROR:  printf(RED "fail    " NC); break;
                case RESULT_OK:  printf(GREEN "ok      " NC); break;
                case RESULT_TIMEOUT:  printf(BLUE "timeout " NC); break;
                case RESULT_NA: 
                    if (reflist[row].type == TYPE_INTERACTIVE) {
                        printf(GREY "manual  " NC);
                    } else {
                        printf(GREY "n/a     " NC); 
                    }
                    break;
            }
        break;
        case FORMAT_HTML:
            switch (res) {
                case RESULT_ERROR:  
                    if (reflist[row].expect == RESULT_ERROR) {
                        printf("<td class=\"ok\">fail (ok)"); 
                    } else {
                        printf("<td class=\"error\">fail"); 
                    }
                    break;
                case RESULT_OK:  
                    if (reflist[row].expect != RESULT_OK) {
                        printf("<td class=\"error\">ok (fail)"); 
                    } else {
                        printf("<td class=\"ok\">ok"); 
                    }
                    break;
                case RESULT_TIMEOUT:  
                    if (reflist[row].expect == RESULT_TIMEOUT) {
                        printf("<td class=\"ok\">timeout (ok)"); 
                    } else {
                        printf("<td class=\"timeout\">timeout"); 
                    }
                    break;
                case RESULT_NA: 
                    if (reflist[row].type == TYPE_INTERACTIVE) {
                        printf("<td class=\"inter\">interactive");
                    } else {
                        printf("<td class=\"na\">n/a"); 
                    }
                    break;
            }
            printf("</td>");
        break;
        case FORMAT_WIKI:
            switch (res) {
                case RESULT_ERROR:  
                    if (reflist[row].expect == RESULT_ERROR) {
                        printf("|style=\"background:lime;\"|fail (ok)\n");
                    } else {
                        printf("|style=\"background:red;\"|fail\n");
                    }
                    break;
                case RESULT_OK:  
                    if (reflist[row].expect != RESULT_OK) {
                        printf("|style=\"background:red;\"|ok (fail)\n");
                    } else {
                        printf("|style=\"background:lime;\"|ok\n");
                    }
                    break;
                case RESULT_TIMEOUT:  
                    if (reflist[row].expect == RESULT_TIMEOUT) {
                        printf("|style=\"background:lime;\"|timeout (ok)\n");
                    } else {
                        printf("|style=\"background:lightblue;\"|timeout\n");
                    }
                    break;
                case RESULT_NA: 
                    if (reflist[row].type == TYPE_INTERACTIVE) {
                        printf("|style=\"background:lightgrey;\"|manual\n");
                    } else {
                        printf("|style=\"background:lightgrey;\"|n/a\n"); 
                    }
                    break;
            }
        break;
    }
}

void printrowtestcomment(int row)
{
    switch (format) {
        case FORMAT_TEXT:
            if (reflist[row].comment) {
                printf(BLUE " %s" NC, reflist[row].comment);
            }
        break;
        case FORMAT_WIKI:
        break;
    }
}
void printrow(int row, int *res)
{
    int ii;

    if (format == FORMAT_HTML) {
        printf("<tr>");
        printrowtestpath(row, res[0]);
        printrowtesttype(row);
    } else if (format == FORMAT_WIKI) {
        printf("|-\n");
        printrowtestpath(row, res[0]);
        printrowtesttype(row);
    }

    for (ii = (firstcolisref ? 1 : 0); ii < numfiles; ii++) {
        printrowtestresult(row, res[ii]);
    }

    if (format == FORMAT_TEXT) {
        printrowtesttype(row);
        printrowtestpath(row, res[0]);
        printrowtestcomment(row);
        printf("\n");
    } else if (format == FORMAT_HTML) {
        printf("</tr>\n");
    }
    
}

void printtable(void)
{
    int i, ii, iserror, isdiff;
    int res[MAXLISTS];

    
    printtablestart();
    // first the headers
    printheader();

    // loop over all tests
    for (i = 0; i < refnum; i++) {
        iserror = 0;
        isdiff = 0;
        
        // loop over all result files
        for (ii = 0; ii < numfiles; ii++) {
            res[ii] = findresult(testlist[ii], &reflist[i]);
            if (res[ii] == RESULT_ERROR) iserror = 1;
            if (res[ii] != res[0]) isdiff = 1;
        }
        // skip this line if we only want to see errors
        if (errormode && !iserror) continue;
        // skip this line if we only want to see diffs
        if (diffmode && !isdiff) continue;
        // skip this line if we dont want to see results for ntscold
        if (filterntscold && (reflist[i].videotype == VIDEOTYPE_NTSCOLD)) continue;

        printrow(i, res);
    }
    
    printtableend();
}

//------------------------------------------------------------------------------

void usage(char *name)
{
    printf(
    "%s - show results from test programs.\n"
    "usage: %s <options>\n"
    "  --help                       show this help\n"
    "  --list <file>                add a test list\n"
    "  --results <file> <header>    add a results file\n"
    "  --html                       output html\n"
    "  --wiki                       output mediawiki format\n"
    "  --ranking <format>           output ranking first, using format for percentages\n"
    "  --filter-ntscold             omit ntsc-old tests\n"
    "  --firstcolisref <string>     first resultlist is a reference\n"
    "  --warnvicefail <string>      warn if test is marked as failing in VICE\n"
    "  --warnvicfetch <string>      warn if test is marked as being critical for VIC fetches\n"
    "  --percentages <format>       print percentages in first row\n"
    "  --diff                       omit rows in which all columns are the same\n"
    "  --errors                     output only rows that contain errors\n"
    "  --verbose                    be more verbose\n", name, name
    );
}

void checkarg(int i, int argc, char *arg0, char *arg)
{
    if ((i+1) == argc) {
        fprintf(stderr, "error: argument missing after '%s'\n\n", arg);
        usage(arg0);
        exit(EXIT_FAILURE);
    }
}

int main(int argc, char *argv[])
{
    int i, ii;
    for (i = 1; i < argc; i++) {
        if(!strcmp(argv[i], "--verbose")) {
            verbose = 1;
        } else if(!strcmp(argv[i], "--errors")) {
            errormode = 1;
        } else if(!strcmp(argv[i], "--diff")) {
            diffmode = 1;
        } else if(!strcmp(argv[i], "--filter-ntscold")) {
            filterntscold = 1;
        } else if(!strcmp(argv[i], "--html")) {
            format = FORMAT_HTML;
        } else if(!strcmp(argv[i], "--wiki")) {
            format = FORMAT_WIKI;
        } else if(!strcmp(argv[i], "--ranking")) {
            ranking = 1;
            checkarg(i, argc, argv[0], argv[i]);
            i++;
            rankingpercentagestring = argv[i];
        } else if(!strcmp(argv[i], "--help")) {
            usage(argv[0]);
            exit(EXIT_SUCCESS);
        } else if(!strcmp(argv[i], "--firstcolisref")) {
            checkarg(i, argc, argv[0], argv[i]);
            i++;
            firstcolisref = 1;
            referrorstring = argv[i];
        } else if(!strcmp(argv[i], "--percentages")) {
            checkarg(i, argc, argv[0], argv[i]);
            i++;
            firstrowispercent = 1;
            percentagestring = argv[i];
        } else if(!strcmp(argv[i], "--warnvicfetch")) {
            checkarg(i, argc, argv[0], argv[i]);
            i++;
            warnvicfetch = 1;
            vicfetchstring = argv[i];
        } else if(!strcmp(argv[i], "--warnvicefail")) {
            checkarg(i, argc, argv[0], argv[i]);
            i++;
            warnvicefail = 1;
            vicefailstring = argv[i];
        } else if(!strcmp(argv[i], "--list")) {
            checkarg(i, argc, argv[0], argv[i]);
            i++;
            refname = argv[i];
        } else if(!strcmp(argv[i], "--results")) {
            checkarg(i, argc, argv[0], argv[i]);
            i++;
            infilename[numfiles] = argv[i];
            checkarg(i, argc, argv[0], argv[i]);
            i++;
            headline[numfiles] = argv[i];
            numfiles++;
        } else  {
            fprintf(stderr, "error: unknown option '%s'\n", argv[i]);
            usage(argv[0]);
            exit(EXIT_FAILURE);
        }
    }

    // do some sanity checks and report errors
    if (refname == NULL) {
        fprintf(stderr, "error: no test list specified\n");
        exit(-1);
    }

    if (numfiles == 0) {
        fprintf(stderr, "error: no results specified\n");
        exit(-1);
    }

    // read the testlist
    refnum = readlist(reflist, refname, 0);
    if (verbose) printf("%d tests in %s\n", refnum, refname);

    // read the results
    for (i = 0; i < numfiles; i++) {
        testnum[i] = readlist(testlist[i], infilename[i], 1);
        testfailed[i] = 0;
        
        // loop over all tests
        for (ii = 0; ii < refnum; ii++) {
            TEST *itm = findresultitem(testlist[i], &reflist[ii]);
            if (itm) {
                if ((itm->result == RESULT_ERROR) && (reflist[ii].expect != RESULT_ERROR)) {
                    testfailed[i]++;
                } else if ((itm->result == RESULT_TIMEOUT) && (reflist[ii].expect != RESULT_TIMEOUT)) {
                    testfailed[i]++;
                } else if ((itm->result == RESULT_OK) && (reflist[ii].expect != RESULT_OK)) {
                    testfailed[i]++;
                }
            }
        }
        if (verbose) printf("%d tests (%d failed) in %s\n", testnum[i], testfailed[i], infilename[i]);
    }
    
//    dumplist(reflist, refnum);

    printdocumentstart();
    
    if (ranking) {
        printranking();
    }
    
    // output the table
    printtable();

    printdocumentend();
    
    return EXIT_SUCCESS;
}

