
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
#define TYPE_NA             -1

#define MEDIA_NONE  -1
#define MEDIA_D64   0
#define MEDIA_G64   1
#define MEDIA_CRT   2

typedef struct
{
    char path[MAXPATHLEN];
    char prog[MAXPATHLEN];
    int result;
    int type;
    char media[MAXPATHLEN];
    int mediatype;
    int ciatype;
    int sidtype;
    int videotype;
} TEST;

char *refname = NULL;
TEST reflist[MAXTESTS];
int refnum = 0;

TEST testlist[MAXLISTS][MAXTESTS];
int testnum[MAXLISTS];

char *sfurl = "https://sourceforge.net/p/vice-emu/code/HEAD/tree/testprogs/testbench";

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

void splitline(char *line, char *a1, char *a2, char *a3, char *a4, char *a5, char *a6, char *a7, char *a8, char *a9)
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
}

//------------------------------------------------------------------------------

int readlist(TEST *list, char *name, int isresultfile)
{
    FILE *in;
    char line[0x100];
    char result[0x100];
    char type[0x100];
    char timeout[0x100];
    char opt1[0x100];
    char opt2[0x100];
    char opt3[0x100];
    char opt4[0x100];
    char opt5[0x100];
    int num = 0;
    int len;

    in = fopen(name, "r");
    if (in == NULL) {
        fprintf(stderr, "error: could not open '%s'\n", name);
        return 0;
    }

    while(!feof(in)) {
        result[0] = 0;
        type[0] = 0;
        opt1[0] = 0;
        opt2[0] = 0;
        opt3[0] = 0;
        opt4[0] = 0;
        opt5[0] = 0;
        timeout[0] = 0;
        if (fgets(line, 0x100, in) == NULL) {
            break; // stop if no line could be read
        }
        if (line[0] == '#') {
            continue; // skip comment lines
        }
        if (isresultfile) {
            splitline(line, list->path, list->prog, result, type, opt1, opt2, opt3, opt4, opt5);
        } else {
            splitline(line, list->path, list->prog, type, timeout, opt1, opt2, opt3, opt4, opt5);
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
        // check test type
        if (!strcmp(type, "exitcode")) {
            list->type = TYPE_EXITCODE;
        } else if (!strcmp(type, "screenshot")) {
            list->type = TYPE_SCREENSHOT;
        } else if (!strcmp(type, "interactive")) {
            list->type = TYPE_INTERACTIVE;
        } else {
            list->type = TYPE_NA;
        }
        // check extra option for mounted media,cia/sid/vic type
        list->mediatype = MEDIA_NONE;
        list->ciatype = -1;
        list->sidtype = -1;
        list->videotype = -1;
        if (isresultfile) {
            // 1) d64
            len = strlen(opt1);
            if (len > 0) {
                strcpy(list->media, opt1);
                list->mediatype = MEDIA_D64;
            }
            // 2) g64
            len = strlen(opt2);
            if (len > 0) {
                strcpy(list->media, opt2);
                list->mediatype = MEDIA_G64;
            }
            // 3) crt
            len = strlen(opt3);
            if (len > 0) {
                strcpy(list->media, opt3);
                list->mediatype = MEDIA_CRT;
            }
            // 4) cia
            if (!strcmp(opt4, "0")) {
                list->ciatype = 0;
            } else if (!strcmp(opt4, "1")) {
                list->ciatype = 1;
            }
            // 5) sid
            if (!strcmp(opt5, "0")) {
                list->sidtype = 0;
            } else if (!strcmp(opt5, "1")) {
                list->sidtype = 1;
            }
        } else {
            // FIXME: there can be more than one option
            if (!strcmp(opt1, "cia-old")) {
                list->ciatype = 0;
            } else if (!strcmp(opt1, "cia-new")) {
                list->ciatype = 1;
            }

            if (!strcmp(opt1, "sid-old")) {
                list->sidtype = 0;
            } else if (!strcmp(opt1, "sid-new")) {
                list->sidtype = 1;
            }

            if (!strncmp(opt1, "mountd64:", 9)) {
                strcpy(list->media, &opt1[9]);
                list->mediatype = MEDIA_D64;
            } else if (!strncmp(opt1, "mountg64:", 9)) {
                strcpy(list->media, &opt1[9]);
                list->mediatype = MEDIA_G64;
            } else if (!strncmp(opt1, "mountcrt:", 9)) {
                strcpy(list->media, &opt1[9]);
                list->mediatype = MEDIA_CRT;
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

int findresult(TEST *list, TEST *reflist)
{
    int i;
    // loop over all tests
    for (i = 0; i < refnum; i++) {
        if(!strcmp(list->path, reflist->path) && 
           !strcmp(list->prog, reflist->prog) &&
           (list->type == reflist->type) &&
           (list->ciatype == reflist->ciatype) &&
           (list->sidtype == reflist->sidtype) &&
           (list->videotype == reflist->videotype) &&
           (list->mediatype == reflist->mediatype)
          ) {
            return list->result;
        }
        list++;
    }
    return -1; // not found
}

//------------------------------------------------------------------------------
void printstart(void)
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
            "</style>"
            "</head>"
            "<body>"
            "<hr><table style=\"width: 100%%\" id=\"maintable\">"
            "\n"
        );
    } else if (format == FORMAT_WIKI) {
        printf("{| class=\"wikitable sortable\" border=\"1\" cellpadding=\"2\" cellspacing=\"0\"\n");
    }
}

void printend(void)
{
    if (format == FORMAT_HTML) {
        printf("</table>"
               "</html>"
               "\n"
        );
    } else if (format == FORMAT_WIKI) {
        printf("|}\n");
    }
}

void printheader(void)
{
    char tmp[0x100];
    int i;

    if (format == FORMAT_HTML) {
        printf("<tr>"
               "<th>Path</th>"
               "<th>Type</th>"
        );
    } else if (format == FORMAT_WIKI) {
        printf(
               "! |Path\n"
               "! |Type\n"
        );
    }

    for (i = 0; i < numfiles; i++) {
        switch (format) {
            case FORMAT_TEXT: 
                strcpy(tmp, headline[i]); tmp[8] = 0;
                printf(WHITE "%-8s" NC, tmp); 
                break;
            case FORMAT_HTML: 
                printf("<th width=120>%s</th>", headline[i]); 
                break;
            case FORMAT_WIKI: 
                printf("! width=\"80pt\" |%s\n", headline[i]); 
                break;
        }
    }
    
    if (format == FORMAT_TEXT) {
        printf("\n");
    } else if (format == FORMAT_HTML) {
        printf("</tr>\n");
    }

}

void printrowtestpath(int row)
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
            printf(" <a href=\"%s/%s/%s?format=raw\">%s</a>", 
                   sfurl, reflist[row].path, reflist[row].prog, reflist[row].prog); 
            switch (reflist[row].mediatype) {
                case MEDIA_D64:
                case MEDIA_G64:
                case MEDIA_CRT:
                    printf(" (<a href=\"%s/%s/%s?format=raw\">%s</a>)", 
                           sfurl, reflist[row].path, reflist[row].media, reflist[row].media); 
                    break;
            }
            printf("</td>");
        break;
        case FORMAT_WIKI:
            printf("||");
            printf("[%s/%s/ %s]", 
                   sfurl, reflist[row].path, reflist[row].path); 
            printf(" [%s/%s/%s?format=raw %s]", 
                   sfurl, reflist[row].path, reflist[row].prog, reflist[row].prog); 
            switch (reflist[row].mediatype) {
                case MEDIA_D64:
                case MEDIA_G64:
                case MEDIA_CRT:
                    printf(" ([%s/%s/%s?format=raw %s])", 
                           sfurl, reflist[row].path, reflist[row].media, reflist[row].media); 
                    break;
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
            }
        break;
        case FORMAT_HTML:
            switch (reflist[row].type) {
                case TYPE_EXITCODE: printf("<td></td>"); break;
                case TYPE_SCREENSHOT: printf("<td>screenshot</td>"); break;
                case TYPE_INTERACTIVE: printf("<td>interactive</td>"); break;
            }
        break;
        case FORMAT_WIKI:
            switch (reflist[row].type) {
                case TYPE_EXITCODE: printf("||\n"); break;
                case TYPE_SCREENSHOT: printf("||screenshot\n"); break;
                case TYPE_INTERACTIVE: printf("|style=\"background:lightgrey;\"|interactive\n"); break;
            }
        break;
    }
}

void printrowtestresult(int row, int res)
{
    switch (format) {
        case FORMAT_TEXT:
            switch (res) {
                case RESULT_ERROR:  printf(RED "error   " NC); break;
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
                case RESULT_ERROR:  printf("<td class=\"error\">error"); break;
                case RESULT_OK:  printf("<td class=\"ok\">ok"); break;
                case RESULT_TIMEOUT:  printf("<td class=\"timeout\">timeout"); break;
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
                case RESULT_ERROR:  printf("|style=\"background:red;\"|error\n"); break;
                case RESULT_OK:  printf("|style=\"background:lime;\"|ok\n"); break;
                case RESULT_TIMEOUT:  printf("|style=\"background:lightblue;\"|timeout\n"); break;
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

void printrow(int row, int *res)
{
    int ii;

    if (format == FORMAT_HTML) {
        printf("<tr>");
        printrowtestpath(row);
        printrowtesttype(row);
    } else if (format == FORMAT_WIKI) {
        printf("|-\n");
        printrowtestpath(row);
        printrowtesttype(row);
    }

    for (ii = 0; ii < numfiles; ii++) {
        printrowtestresult(row, res[ii]);
    }

    if (format == FORMAT_TEXT) {
        printrowtesttype(row);
        printrowtestpath(row);
        printf("\n");
    } else if (format == FORMAT_HTML) {
        printf("</tr>\n");
    }
    
}

void printtable(void)
{
    int i, ii, iserror;
    int res[MAXLISTS];

    printstart();

    // first the headers
    printheader();

    // loop over all tests
    for (i = 0; i < refnum; i++) {
        iserror = 0;
        // loop over all result files
        for (ii = 0; ii < numfiles; ii++) {
            res[ii] = findresult(testlist[ii], &reflist[i]);
            if (res[ii] == RESULT_ERROR) iserror = 1;
        }
        // skip this line if we only want to see errors
        if (errormode && !iserror) continue;

        printrow(i, res);
    }

    printend();
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
    "  --errors                     output only rows that contain errors\n"
    "  --verbose                    be more verbose\n", name, name
    );
}

int main(int argc, char *argv[])
{
    int i;
    for (i = 1; i < argc; i++) {
        if(!strcmp(argv[i], "--verbose")) {
            verbose = 1;
        } else if(!strcmp(argv[i], "--errors")) {
            errormode = 1;
        } else if(!strcmp(argv[i], "--html")) {
            format = FORMAT_HTML;
        } else if(!strcmp(argv[i], "--wiki")) {
            format = FORMAT_WIKI;
        } else if(!strcmp(argv[i], "--help")) {
            usage(argv[0]);
            exit(EXIT_SUCCESS);
        } else if(!strcmp(argv[i], "--list")) {
            i++;
            refname = argv[i];
        } else if(!strcmp(argv[i], "--results")) {
            i++;
            infilename[numfiles] = argv[i];
            i++;
            headline[numfiles] = argv[i];
            numfiles++;
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
        if (verbose) printf("%d tests in %s\n", testnum[i], infilename[i]);
    }

    // output the table
    printtable();

    return EXIT_SUCCESS;
}

