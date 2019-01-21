
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAXLISTS    0x10

#define BLUE    "\033[1;34m"
#define YELLOW  "\033[1;33m"
#define GREEN   "\033[1;32m"
#define RED     "\033[1;31m"
#define GREY    "\033[1;30m"
#define WHITE   "\033[1;29m"
#define NC      "\033[0m"

int verbose = 0;
int format = 0;
int errormode = 0;

char *infilename[MAXLISTS];
int numfiles = 0;
char *headline[MAXLISTS];

typedef struct
{
    char path[0x100];
    char prog[0x100];
    int result;
    int type;
    char media[0x100];
    int mediatype;
    int ciatype;
    int sidtype;
    int videotype;
} TEST;

char *refname = NULL;
TEST reflist[2000];
int refnum = 0;

TEST testlist[MAXLISTS][2000];
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
//        printf("line:%s\n", line);
        if (isresultfile) {
            splitline(line, list->path, list->prog, result, type, opt1, opt2, opt3, opt4, opt5);
//            printf("|%s|%s|%s|%s|%s|%s|%s|",list->path, list->prog, result, type, opt1, opt2, opt3, opt4, opt5);
        } else {
            splitline(line, list->path, list->prog, type, timeout, opt1, opt2, opt3, opt4, opt5);
        }
        // check error status
        if (!strcmp(result, "error")) {
            list->result = 0;
        } else if (!strcmp(result, "ok")) {
            list->result = 1;
        } else if (!strcmp(result, "timeout")) {
            list->result = 2;
        } else {
            list->result = -1;
        }
        // check test type
        if (!strcmp(type, "exitcode")) {
            list->type = 0;
        } else if (!strcmp(type, "screenshot")) {
            list->type = 1;
        } else if (!strcmp(type, "interactive")) {
            list->type = 2;
        } else {
            list->type = -1;
        }
        // check extra option for mounted media,cia/sid/vic type
        list->mediatype = -1;
        list->ciatype = -1;
        list->sidtype = -1;
        list->videotype = -1;
        if (isresultfile) {
            // 1) d64
            len = strlen(opt1);
            if (len > 0) {
                strcpy(list->media, opt1);
                list->mediatype = 0;
            }
            // 2) g64
            len = strlen(opt2);
            if (len > 0) {
                strcpy(list->media, opt2);
                list->mediatype = 1;
            }
            // 3) crt
            len = strlen(opt3);
            if (len > 0) {
                strcpy(list->media, opt3);
                list->mediatype = 2;
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
//            printf("opt1:%s|", opt1);
//            printf("mediatype:%d|", list->mediatype);
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
                list->mediatype = 0;
            } else if (!strncmp(opt1, "mountg64:", 9)) {
                strcpy(list->media, &opt1[9]);
                list->mediatype = 1;
            } else if (!strncmp(opt1, "mountcrt:", 9)) {
                strcpy(list->media, &opt1[9]);
                list->mediatype = 2;
            }
//            printf("opt1:%s|", opt1);
//            printf("mediatype:%d|", list->mediatype);
        }

        len = strlen(list->path);
        if ((len > 0) && (list->path[len - 1] == '/')) {
            list->path[len - 1] = 0;
        }
        
//        printf("\n");

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
    if (format == 1) {
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
    }
}

void printend(void)
{
    if (format == 1) {
        printf("</table>"
               "</html>"
               "\n"
        );
    }
}

void printheader(void)
{
    char tmp[0x100];
    int i;

    if (format == 1) {
        printf("<tr>"
               "<th>Path</th>"
               "<th>Type</th>"
        );
    }

    for (i = 0; i < numfiles; i++) {
        switch (format) {
            case 0: 
                strcpy(tmp, headline[i]); tmp[8] = 0;
                printf(WHITE "%-8s" NC, tmp); 
                break;
            case 1: 
                printf("<th width=120>%s</th>", headline[i]); 
                break;
        }
    }
    
    if (format == 1) {
        printf("</tr>");
    }
    
    printf("\n");
}

void printrowtestpath(int row)
{
    switch (format) {
        case 0:
            printf("%s/ %s", reflist[row].path, reflist[row].prog); 
            switch (reflist[row].mediatype) {
                case 0: printf(" (%s)", reflist[row].media); break;
            }
        break;
        case 1:
            printf("<td>");
            printf("<a href=\"%s/%s/\">%s</a>", sfurl, reflist[row].path, reflist[row].path); 
            printf(" <a href=\"%s/%s/%s?format=raw\">%s</a>", sfurl, reflist[row].path, reflist[row].prog, reflist[row].prog); 
            switch (reflist[row].mediatype) {
                case 0: printf(" (%s)", reflist[row].media); break;
            }
            printf("</td>");
        break;
    }
}

void printrowtesttype(int row)
{
    switch (format) {
        case 0:
            switch (reflist[row].type) {
                case 0: printf("        "); break;
                case 1: printf("screens "); break;
                case 2: printf("interac "); break;
            }
        break;
        case 1:
            switch (reflist[row].type) {
                case 0: printf("<td></td>"); break;
                case 1: printf("<td>screenshot</td>"); break;
                case 2: printf("<td>interactive</td>"); break;
            }
        break;
    }
}

void printrowtestresult(int row, int res)
{
    switch (format) {
        case 0:
            switch (res) {
                case 0:  printf(RED "error   " NC); break;
                case 1:  printf(GREEN "ok      " NC); break;
                case 2:  printf(BLUE "timeout " NC); break;
                case -1: 
                    if (reflist[row].type == 2) {
                        printf(GREY "manual  " NC);
                    } else {
                        printf(GREY "n/a     " NC); 
                    }
                    break;
            }
        break;
        case 1:
            switch (res) {
                case 0:  printf("<td class=\"error\">error"); break;
                case 1:  printf("<td class=\"ok\">ok"); break;
                case 2:  printf("<td class=\"timeout\">timeout"); break;
                case -1: 
                    if (reflist[row].type == 2) {
                        printf("<td class=\"inter\">interactive");
                    } else {
                        printf("<td class=\"na\">n/a"); 
                    }
                    break;
            }
            printf("</td>");
        break;
    }
}

void printrow(int row, int *res)
{
    int ii;

    if (format == 1) {
        printf("<tr>");
        printrowtestpath(row);
        printrowtesttype(row);
    }

    for (ii = 0; ii < numfiles; ii++) {
        printrowtestresult(row, res[ii]);
    }

    if (format == 0) {
        printrowtesttype(row);
        printrowtestpath(row);
//        printf("(ref:%s)", reflist[row].media);
//        printf("(media:%d)", reflist[row].mediatype);
//        printf("(cia:%d)", reflist[row].ciatype);
//        printf("(sid:%d)", reflist[row].sidtype);
    }
    
    if (format == 1) {
        printf("</tr>");
    }
    
    printf("\n");
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
            if (res[ii] == 0) iserror = 1;
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
            format = 1;
        } else if(!strcmp(argv[i], "--wiki")) {
            format = 2;
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

    // output the table
    refnum = readlist(reflist, refname, 0);
    if (verbose) printf("%d tests in %s\n", refnum, refname);
    
    for (i = 0; i < numfiles; i++) {
        testnum[i] = readlist(testlist[i], infilename[i], 1);
        if (verbose) printf("%d tests in %s\n", testnum[i], infilename[i]);
    }
    
    printtable();

    return EXIT_SUCCESS;
}

