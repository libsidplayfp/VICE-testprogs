
/*
 * prg2ul by Wolfram Sang (Ninja/The Dreams) - Public Domain
 */

#include <stdio.h>
#include <stdlib.h>

#define BUFFER_SIZE 32768
#define FPUT_WITH_CHK(_val) \
        do { fputc(_val, outfile); chk += _val; chk -= (chk > 255) * 255; } while(0);

int main(int argc, char **argv)
{

        FILE *infile, *outfile;
        unsigned char *buffer;
        unsigned char *b;
        long chk;
        int i;
        size_t size, len, pc;

        if (argc == 1) {
		printf("prg2ul v0.3 by Wolfram Sang (Ninja/The Dreams) in 2008\n");
		printf("Convert standard C64 prg-files to utility loader-files (&USR).\n");
		printf("Part of the 1541-Testsuite.\n");
		printf("Usage: 'prg2ul <infile> <outfile>'\n");
		return 128;
        }

        if (!(infile = fopen(argv[1], "rb"))) {
                printf("Could not read infile!\n");
                return 1;
        }

        if (!(outfile = fopen(argv[2], "wb"))) {
                printf("Could not open destination!\n");
                return 2;
        }
        if (!(buffer = (unsigned char *)malloc(BUFFER_SIZE * sizeof(unsigned char)))) {
                printf("Mem error!\n");
                return 3;
        }

        size = fread(buffer, sizeof(unsigned char), BUFFER_SIZE, infile);
        fclose(infile);

        pc = buffer[1] << 8 | buffer[0];

        b = buffer + 2;
        size -= 2;

        while (size) {

              chk = 0;

              FPUT_WITH_CHK(pc & 255);
              FPUT_WITH_CHK(pc >> 8);

              len = (size > 256) ? 256 : size;
              FPUT_WITH_CHK(len & 255);
              for (i = 0; i < len; i++)
                  FPUT_WITH_CHK(b[i]);

              fputc(chk, outfile);

              size -= len;
              pc += len;
              b += len;
        }

        fclose(outfile);
        free(buffer);
        return 0;

}
