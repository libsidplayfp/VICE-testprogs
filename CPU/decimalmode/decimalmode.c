
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

unsigned int N;  /*7 Negative flag */
unsigned int V;  /*6 oVerflow flag */
unsigned int D;  /*3 Decimal flag */
unsigned int Z;  /*1 Zero flag */
unsigned int C;  /*0 Carry flag */

unsigned int M;  /* value written to memory */

unsigned int doADC(unsigned int A /* value in Accumulator */, unsigned int imm /* value to be added to Accumulator */) {

    unsigned int tmp;

    /* Calculate the lower nybble. */
    tmp = (A & 0x0f) + (imm & 0x0f) + C;
    /* BCD fixup for lower nybble. */
    if (tmp > 9) { tmp += 6; }
    if (tmp <= 15) {
        tmp = (tmp & 0x0f) + (A & 0xf0) + (imm & 0xf0);
    }else{
        tmp = (tmp & 0x0f) + (A & 0xf0) + (imm & 0xf0) + 0x10;
    }
    /* Zero flag is set just  like in Binary mode. */
    Z = ((A + imm + C) & 0xff) ? 0 : 1;
    /* Negative and Overflow flags are set with the same logic than in
       Binary mode, but after fixing the lower nybble. */
    N = (tmp & 0x80) >> 7;
    V = ((A ^ tmp) & 0x80) && !((A ^ imm) & 0x80);

    /* BCD fixup for higher nybble. */
    if ((tmp & 0x1f0) > 0x90) {
        tmp += 0x60;
    }
    /* Carry is the only flag set after fixing the result. */
    C = (tmp & 0xff0) > 0xf0;

    A = tmp;

    return A & 0xff; /* value in Accumulator */
}

unsigned int doSBC(unsigned int A /* value in Accumulator */, unsigned int imm /* value to be substracted from Accumulator */) {

    unsigned int tmp;
    unsigned int tmp2;

    tmp = A - imm - (C ^ 1);
    tmp2 = (A & 0x0f) - (imm & 0x0f) - (C ^ 1);

    C = (tmp < 0x100) ? 1 : 0;
    N = (tmp & 0x80) >> 7;
    Z = ((tmp & 0xff) == 0) ? 1 : 0;
    V = (((A ^ tmp) & 0x80) && ((A ^ imm) & 0x80));

    if (tmp2 & 0x10) {
        tmp2 = ((tmp2 - 6) & 0xf) | ((A & 0xf0) - (imm & 0xf0) - 0x10);
    } else {
        tmp2 = (tmp2 & 0xf) | ((A & 0xf0) - (imm & 0xf0));
    }
    if (tmp2 & 0x100) {
        tmp2 -= 0x60;
    }

    A = tmp2;
    
    return A & 0xff; /* value in Accumulator */
}

unsigned int doARR(unsigned int A /* value in Accumulator */, unsigned int imm /* argument value */) {

    unsigned int tmp;
    unsigned int tmp2;

    tmp = A & imm;  /* perform the AND */

    /* perform ROR */
    tmp2 = tmp | (C << 8);
    tmp2 >>= 1;

    N = C; /* original carry state is preserved in N */
    Z = (tmp2 == 0 ? 1 : 0); /* Z is set when the ROR produced a zero result */
    /* V is set when bit 6 of the result was changed by the ROR */
    V = ((tmp2 ^ tmp) & 0x40) >> 6;

    /* fixup for low nibble */
    if (((tmp & 0xf) + (tmp & 0x1)) > 0x5) {
        tmp2 = (tmp2 & 0xf0) | ((tmp2 + 0x6) & 0xf);
    }
    /* fixup for high nibble, set carry */
    if (((tmp & 0xf0) + (tmp & 0x10)) > 0x50) {
        tmp2 = (tmp2 & 0x0f) | ((tmp2 + 0x60) & 0xf0);
        C = 1;
    } else {
        C = 0;
    }

    A = tmp2;

    return A & 0xff; /* value in Accumulator */
}

unsigned int doISC(unsigned int A /* value in Accumulator */, unsigned int val /* value read from memory */) {

    M = (val + 1) & 0xff; /* perform INC, write back to memory */
    A = doSBC(A, M);      /* perform SBC */

    return A & 0xff; /* value in Accumulator */
}

unsigned int doRRA(unsigned int A /* value in Accumulator */, unsigned int val /* value read from memory */) {
    unsigned int tmp;

    /* ROR: shift right, lsb goes to carry */
    tmp = val | (C << 8);
    C = tmp & 1;
    tmp >>= 1;

    M = tmp; /* value written back to memory */

    A = doADC(A, M);    /* perform ADC */

    return A & 0xff; /* value in Accumulator */
}

//------------------------------------------------------------------------------

unsigned char result_akku[0x10000];
unsigned char result_flags[0x10000];
unsigned char result_mem[0x10000];

int savetable_akku(char *name)
{
    FILE *f;
    f = fopen(name, "wb");
    fwrite(result_akku, 1, 0x10000, f);
    fclose (f);
}

int savetable_flags(char *name)
{
    FILE *f;
    f = fopen(name, "wb");
    fwrite(result_flags, 1, 0x10000, f);
    fclose (f);
}

int savetable_mem(char *name)
{
    FILE *f;
    f = fopen(name, "wb");
    fwrite(result_mem, 1, 0x10000, f);
    fclose (f);
}

int savehtml_akku(char *name)
{
    FILE *f;
    unsigned int x,y,res;

    f = fopen(name, "w");
    fprintf(f, "<html>\n");
    fprintf(f, "<table cellpadding=0 cellspacing=0 style=\"font-size:5px\">\n");
    for (y=0;y<0x100;y++) {
        fprintf(f, "<tr height=6px>");
        for (x=0;x<0x100;x++) {
            res = result_akku[(y * 0x100) + x];
#if 1
            if (((res & 0x0f) < 0x0a) && ((res & 0xf0) < 0xa0)) {
                fprintf(f, "<td width=6px bgcolor=00%02x00><font color=%s><tt>", res, 
                    ((x & 1) ^ (y & 1)) ? "668866" : "aaccaa"
                );
            } else {
                fprintf(f, "<td width=6px bgcolor=%02x0000><font color=%s><tt>", res, 
                    ((x & 1) ^ (y & 1)) ? "886666" : "ccaaaa"
                );
            }
            fprintf(f, "%02x</tt></font>", res);
#else
            fprintf(f, "<td width=7px bgcolor=%02x%02x%02x>", res, res, res);
            fprintf(f, "&nbsp;");
#endif
            fprintf(f, "</td>");
        }
        fprintf(f, "</tr>\n");
    }
    fprintf(f, "</table>\n");
    fprintf(f, "</html>\n");
    fclose (f);
}

int savehtml_mem(char *name)
{
    FILE *f;
    unsigned int x,y,res;

    f = fopen(name, "w");
    fprintf(f, "<html>\n");
    fprintf(f, "<table cellpadding=0 cellspacing=0 style=\"font-size:5px\">\n");
    for (y=0;y<0x100;y++) {
        fprintf(f, "<tr height=6px>");
        for (x=0;x<0x100;x++) {
            res = result_mem[(y * 0x100) + x];
#if 1
#if 0
            if (((res & 0x0f) < 0x0a) && ((res & 0xf0) < 0xa0)) {
                fprintf(f, "<td width=6px bgcolor=00%02x00><font color=%s><tt>", res, 
                    ((x & 1) ^ (y & 1)) ? "668866" : "aaccaa"
                );
            } else {
                fprintf(f, "<td width=6px bgcolor=%02x0000><font color=%s><tt>", res, 
                    ((x & 1) ^ (y & 1)) ? "886666" : "ccaaaa"
                );
            }
#endif
            fprintf(f, "<td width=6px bgcolor=%02x%02x%02x><font color=%s><tt>", res, res, res,  
                ((x & 1) ^ (y & 1)) ? "666666" : "aaaaaa"
            );
            fprintf(f, "%02x</tt></font>", res);
#else
            fprintf(f, "<td width=7px bgcolor=%02x%02x%02x>", res, res, res, 
                    ((x & 1) ^ (y & 1)) ? "666666" : "aaaaaa"
                );
            fprintf(f, "&nbsp;");
#endif
            fprintf(f, "</td>");
        }
        fprintf(f, "</tr>\n");
    }
    fprintf(f, "</table>\n");
    fprintf(f, "</html>\n");
    fclose (f);
}

int html = 0;

int main(int argc, char *argv[])
{
    unsigned int x,y;

    
    if (argv[1] && !strcmp(argv[1], "--html")) { html = 1; }
    
    for (y=0;y<0x100;y++) {
        for (x=0;x<0x100;x++) {
            C = 0;
            N = V = Z = 0;
            D = 1;
            result_akku[(y * 0x100) + x] = doADC(x,y);
            result_flags[(y * 0x100) + x] = (N<<7)|(V<<6)|(D<<3)|(Z<<1)|(C<<0);
        }
    }
    if (html) {
        savehtml_akku("adc_akku.html");
    } else {
        savetable_akku("ref_adc_akku.bin");
        savetable_flags("ref_adc_flags.bin");
    }

    for (y=0;y<0x100;y++) {
        for (x=0;x<0x100;x++) {
            C = 1;
            N = V = Z = 0;
            D = 1;
            result_akku[(y * 0x100) + x] = doADC(x,y);
            result_flags[(y * 0x100) + x] = (N<<7)|(V<<6)|(D<<3)|(Z<<1)|(C<<0);
        }
    }
    if (html) {
        savehtml_akku("adc_sec_akku.html");
    } else {
        savetable_akku("ref_adc_sec_akku.bin");
        savetable_flags("ref_adc_sec_flags.bin");
    }

    for (y=0;y<0x100;y++) {
        for (x=0;x<0x100;x++) {
            C = 0;
            N = V = Z = 0;
            D = 1;
            result_akku[(y * 0x100) + x] = doSBC(x,y);
            result_flags[(y * 0x100) + x] = (N<<7)|(V<<6)|(D<<3)|(Z<<1)|(C<<0);
        }
    }
    if (html) {
        savehtml_akku("sbc_akku.html");
    } else {
        savetable_akku("ref_sbc_akku.bin");
        savetable_flags("ref_sbc_flags.bin");
    }

    for (y=0;y<0x100;y++) {
        for (x=0;x<0x100;x++) {
            C = 1;
            N = V = Z = 0;
            D = 1;
            result_akku[(y * 0x100) + x] = doSBC(x,y);
            result_flags[(y * 0x100) + x] = (N<<7)|(V<<6)|(D<<3)|(Z<<1)|(C<<0);
        }
    }
    if (html) {
        savehtml_akku("sbc_sec_akku.html");
    } else {
        savetable_akku("ref_sbc_sec_akku.bin");
        savetable_flags("ref_sbc_sec_flags.bin");
    }

    for (y=0;y<0x100;y++) {
        for (x=0;x<0x100;x++) {
            C = 0;
            N = V = Z = 0;
            D = 1;
            result_akku[(y * 0x100) + x] = doARR(x,y);
            result_flags[(y * 0x100) + x] = (N<<7)|(V<<6)|(D<<3)|(Z<<1)|(C<<0);
        }
    }
    if (html) {
        savehtml_akku("arr_akku.html");
    } else {
        savetable_akku("ref_arr_akku.bin");
        savetable_flags("ref_arr_flags.bin");
    }

    for (y=0;y<0x100;y++) {
        for (x=0;x<0x100;x++) {
            C = 1;
            N = V = Z = 0;
            D = 1;
            result_akku[(y * 0x100) + x] = doARR(x,y);
            result_flags[(y * 0x100) + x] = (N<<7)|(V<<6)|(D<<3)|(Z<<1)|(C<<0);
        }
    }
    if (html) {
        savehtml_akku("arr_sec_akku.html");
    } else {
        savetable_akku("ref_arr_sec_akku.bin");
        savetable_flags("ref_arr_sec_flags.bin");
    }

    for (y=0;y<0x100;y++) {
        for (x=0;x<0x100;x++) {
            C = 0;
            N = V = Z = 0;
            D = 1;
            result_akku[(y * 0x100) + x] = doISC(x,y);
            result_flags[(y * 0x100) + x] = (N<<7)|(V<<6)|(D<<3)|(Z<<1)|(C<<0);
            result_mem[(y * 0x100) + x] = M;
        }
    }
    if (html) {
        savehtml_akku("isc_akku.html");
        savehtml_mem("isc_mem.html");
    } else {
        savetable_akku("ref_isc_akku.bin");
        savetable_flags("ref_isc_flags.bin");
        savetable_mem("ref_isc_mem.bin");
    }

    for (y=0;y<0x100;y++) {
        for (x=0;x<0x100;x++) {
            C = 1;
            N = V = Z = 0;
            D = 1;
            result_akku[(y * 0x100) + x] = doISC(x,y);
            result_flags[(y * 0x100) + x] = (N<<7)|(V<<6)|(D<<3)|(Z<<1)|(C<<0);
            result_mem[(y * 0x100) + x] = M;
        }
    }
    if (html) {
        savehtml_akku("isc_sec_akku.html");
        savehtml_mem("isc_sec_mem.html");
    } else {
        savetable_akku("ref_isc_sec_akku.bin");
        savetable_flags("ref_isc_sec_flags.bin");
        savetable_mem("ref_isc_sec_mem.bin");
    }

    for (y=0;y<0x100;y++) {
        for (x=0;x<0x100;x++) {
            C = 0;
            N = V = Z = 0;
            D = 1;
            result_akku[(y * 0x100) + x] = doRRA(x,y);
            result_flags[(y * 0x100) + x] = (N<<7)|(V<<6)|(D<<3)|(Z<<1)|(C<<0);
            result_mem[(y * 0x100) + x] = M;
        }
    }
    if (html) {
        savehtml_akku("rra_akku.html");
        savehtml_mem("rra_mem.html");
    } else {
        savetable_akku("ref_rra_akku.bin");
        savetable_flags("ref_rra_flags.bin");
        savetable_mem("ref_rra_mem.bin");
    }

    for (y=0;y<0x100;y++) {
        for (x=0;x<0x100;x++) {
            C = 1;
            N = V = Z = 0;
            D = 1;
            result_akku[(y * 0x100) + x] = doRRA(x,y);
            result_flags[(y * 0x100) + x] = (N<<7)|(V<<6)|(D<<3)|(Z<<1)|(C<<0);
            result_mem[(y * 0x100) + x] = M;
        }
    }
    if (html) {
        savehtml_akku("rra_sec_akku.html");
        savehtml_mem("rra_sec_mem.html");
    } else {
        savetable_akku("ref_rra_sec_akku.bin");
        savetable_flags("ref_rra_sec_flags.bin");    
        savetable_mem("ref_rra_sec_mem.bin");    
    }
}

