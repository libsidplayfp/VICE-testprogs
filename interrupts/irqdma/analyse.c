
// naive tool to compare dumps made by irqdma tests

// TODO: actually implement something more useful than just showing the
//       number of differences

#include <stdio.h>
#include <stdlib.h>

FILE *f1,*f2;

int main(int argc,char *argv[])
{
    int c1,c2,cnt,total;
    float percent;

    f1 = fopen(argv[1], "rb");
    f2 = fopen(argv[2], "rb");
    cnt = 0;total=0;

    fgetc(f1);fgetc(f1);
    fgetc(f2);fgetc(f2);

    while (!feof(f1)) {
        c1 = fgetc(f1);
        c2 = fgetc(f2);
        if (c1 != c2) {
            cnt++;
        }
        total++;
    }
    percent = (float)cnt * 100.0f / (float)total;
    printf("differences: %d of %d = %f%%\n", cnt, total, percent);
    fclose(f1);
    fclose(f2);
}
