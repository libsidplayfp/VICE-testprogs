/*
   A program for calculating att/dec times from adsr.prg dumps
   2009 Hannu Nuotio
*/

#include <stdio.h>

int analyse(char *filename)
{
    enum {START, ATTACK, TOP, DECAY, STOP} state = START;
    FILE *fp;
    int count = 0;
    int delay;
    int cycles;
    int prev_cycles;
    int att_cycles_min = 100000;
    int att_cycles_max = -1;
    int dec_cycles_min = 100000;
    int dec_cycles_max = -1;
    int att_start = 0;
    int att_stop = 0;
    int dec_start = 0;
    int dec_stop = 0;
    unsigned char att_max_val = 0;
    unsigned char dec_min_val = 0xff;
    int c;
    unsigned char b, prev = 0;

    if((fp = fopen(filename, "r")) == NULL) {
        perror(filename);
        return 1;
    }

    fprintf(stdout,"\n\nProcessing %s\n", filename);

    while((c = getc(fp)) != EOF) {
        ++count;
        b = (unsigned char)c;

        switch(state) {
            case START:
                if(b > 0) {
                    cycles = 0;
                    prev_cycles = -1;
                    prev = b;
                    delay = count - 1;
                    ++state;
                    fprintf(stdout,"Delay %i", delay);
                    att_start = count;
                    if(b == 0xff) {
                        att_max_val = 0xff;
                        att_stop = att_start;
                        att_cycles_min = att_cycles_max = 0;
                        ++state;
                        fprintf(stdout,", attack = 0 cycles, skipping to TOP");
                    }
                    fprintf(stdout,"\n\n");
                }
                break;

            case ATTACK:
                ++cycles;
                if(b != prev) {
                    att_stop = count;
                    att_max_val = b;
                    if(cycles > att_cycles_max) {
                        att_cycles_max = cycles;
                    }
                    if(cycles < att_cycles_min) {
                        att_cycles_min = cycles;
                    }

                    if(prev_cycles != cycles) {
                        fprintf(stdout,"Attack: %i/%i cycles (%i), $%02x->$%02x\n", att_cycles_min*2, att_cycles_max*2, cycles*2, prev, b);
                    }

                    if(b == 0xff) {
                        ++state;
                        prev_cycles = 0;
                        fprintf(stdout,"Attack done, switching to TOP\n\n");
                    }

                    prev = b;
                    prev_cycles = cycles;
                    cycles = 0;
                }
                break;

            case TOP:
                if(b != 0xff) {
                    prev = b;
                    cycles = 0;
                    dec_start = count;
                    ++state;
                    fprintf(stdout,"TOP done, switching to DECAY\n\n");
                }
                break;

            case DECAY:
                ++cycles;
                if(b != prev) {
                    dec_stop = count;
                    dec_min_val = b;
                    if(cycles > dec_cycles_max) {
                        dec_cycles_max = cycles;
                    }
                    if(cycles < dec_cycles_min) {
                        dec_cycles_min = cycles;
                    }

                    if(prev_cycles != cycles) {
                        fprintf(stdout,"Decay: %i/%i cycles (%i), $%02x->$%02x\n", dec_cycles_min*2, dec_cycles_max*2, cycles*2, prev, b);
                    }

                    if(b == 0x00) {
                        ++state;
                        prev_cycles = 0;
                        fprintf(stdout,"Decay done, switching to STOP\n\n");
                    }

                    prev = b;
                    prev_cycles = cycles;
                    cycles = 0;
                }
                break;

            case STOP:
                break;
        }
    }

    fclose(fp);

    fprintf(stdout,"Results for %s: ", filename);

    if(state == START) {
        fprintf(stdout,"Couldn't find attack.\n");
        return 0;
    }

    fprintf(stdout,"Delay: %i, Attack: %i/%i total %i avg %i",
                    delay*2,
                    att_cycles_min*2, att_cycles_max*2,
                    (att_stop-att_start)*2,
                    (att_stop-att_start)*2/(att_max_val-1)
           );

    if(state >= DECAY) {
        fprintf(stdout,", Top: %i, Decay: %i/%i total %i avg %i",
                        (dec_start-att_stop)*2,
                        dec_cycles_min*2, dec_cycles_max*2,
                        (dec_stop-dec_start)*2,
                        (dec_stop-dec_start)*2/(0xfe - dec_min_val)
               );
    }

    fprintf(stdout,"\n");
    return 0;
}

int main(int argc, char **argv)
{
    int i;

    if(argc < 2) {
        fprintf(stderr,"Usage: %s file.raw\n", argv[0]);
        return 1;
    }

    for(i = 1; i < argc; ++i) {
        if(analyse(argv[i])) {
            return 1;
        }
    }
    return 0;
}

