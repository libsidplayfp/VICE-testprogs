
#include <stdlib.h>
#include <stdio.h>

FILE *in1, *in2;

int main(int argc, char *argv[])
{
    int line, lastline = -1, cycles = 0;

    in1 = fopen(argv[1], "rb");
    in2 = fopen(argv[2], "rb");

    /* throw away start addr */
    fgetc(in1);fgetc(in1);
    fgetc(in2);fgetc(in2);

    do {
        line = (fgetc(in2) * 2) - (((fgetc(in1) & 0x80) != 0) ? -1 : 0);
        if (feof(in1) || feof(in2)) break;
        if (line != lastline) {
            if (cycles != 0) {
                printf("LINE %03d / CYCLES %03d\n", lastline, cycles);
            }
            cycles = 1;
            lastline = line;
        } else {
            cycles++;
        }
    } while(1);
    printf("LINE %03d / CYCLES %03d\n", lastline, cycles);

    fclose(in1);fclose(in2);
}
