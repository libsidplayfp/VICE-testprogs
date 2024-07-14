/*
 * main.c - Test entrypoint for VICE's binary monitor interface
 *
 * Written by
 *  Empathic Qubit <empathicqubit@entan.gl>
 *
 * This file is part of VICE, the Versatile Commodore Emulator.
 * See README for copyright notice.
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
 *  02111-1307  USA.
 *
 */

/* These tests are meant to be run against x64sc */

#include <stdint.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "CuTest.h"
#include "util.h"
#include "connection.h"
#include "checkpoint.h"

void request_id_is_set(CuTest* tc) {
    int length;

    unsigned char command[] = { 
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xa6, 0xea, 0x28, 0x1d, 

        0x81, 
    };

    connection_setup(tc);

    send_command(command);

    length = wait_for_response_id(tc, command);

    CuAssertIntEquals(tc, 0x81, response[RESPONSE_TYPE]);

    CuAssertIntEquals(tc, 0, length - HEADER_LENGTH);
}

void registers_set_works(CuTest *tc) {
    int length, count, i;
    int assert_count = 0;
    unsigned char* cursor;

    // Set A and X
    unsigned char set_command[] = { 
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xa9, 0xe3, 0x28, 0x37, 

        0x32, 

        0x00,

        0x02, 0x00,

        0x03,
        0x00,
        0xbe, 0x00,

        0x03,
        0x01,
        0xef, 0x00,
    };

    // set

    connection_setup(tc);

    send_command(set_command);

    length = wait_for_response_id(tc, set_command);

    CuAssertIntEquals(tc, 0x31, response[RESPONSE_TYPE]);

    count = little_endian_to_uint16(&response[HEADER_LENGTH]);

    CuAssertIntEquals(tc, 10, count);

    cursor = &response[HEADER_LENGTH + 2];

    for (i = 0 ; i < count ; i++) {
        uint8_t item_size = cursor[0];
        uint8_t id = cursor[1];
        uint16_t val = little_endian_to_uint16(&cursor[2]);

        if (id == 0x00) {
            CuAssertIntEquals(tc, little_endian_to_uint16(&set_command[COMMAND_HEADER_LENGTH + 5]), val);
            ++assert_count;
        } else if (id == 0x01) {
            CuAssertIntEquals(tc, little_endian_to_uint16(&set_command[COMMAND_HEADER_LENGTH + 9]), val);
            ++assert_count;
        } else if (id == 0x35) {
            ++assert_count;
        } else if (id == 0x36) {
            ++assert_count;
        }

        cursor += item_size + 1;
    }

    CuAssertIntEquals(tc, 4, assert_count);
}

void registers_get_drive_works(CuTest *tc) {
    int length, count, i;
    int assert_count = 0;
    unsigned char* cursor;

    // Get
    unsigned char get_command[] = { 
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xa9, 0xe3, 0x28, 0x37, 

        0x31, 

        0x01,
    };

    connection_setup(tc);

    send_command(get_command);

    length = wait_for_response_id(tc, get_command);

    CuAssertIntEquals(tc, 0x31, response[RESPONSE_TYPE]);

    count = little_endian_to_uint16(&response[HEADER_LENGTH]);

    CuAssertIntEquals(tc, 8, count);

    cursor = &response[HEADER_LENGTH + 2];

    for (i = 0 ; i < count ; i++) {
        uint8_t item_size = cursor[0];
        uint8_t id = cursor[1];
        uint16_t val = little_endian_to_uint16(&cursor[2]);

        if (id == 0x00 
                || id == 0x01
                || id == 0x02
                || id == 0x03
                || id == 0x04
                || id == 0x35
                || id == 0x36
                ) {
            ++assert_count;
        }

        cursor += item_size + 1;
    }

    CuAssertIntEquals(tc, 7, assert_count);
}


void registers_get_works(CuTest *tc) {
    int length, count, i;
    int assert_count = 0;
    unsigned char* cursor;

    unsigned char reset_command[] = {
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xaf, 0xe9, 0x23, 0x3d, 

        0xcc,

        0x00,
    };

    // Get
    unsigned char get_command[] = { 
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xa9, 0xe3, 0x28, 0x37, 

        0x31, 

        0x00,
    };

    connection_setup(tc);

    send_command(reset_command);

    length = wait_for_response_id(tc, reset_command);

    CuAssertIntEquals(tc, 0xcc, response[RESPONSE_TYPE]);

    send_command(get_command);

    length = wait_for_response_id(tc, get_command);

    CuAssertIntEquals(tc, 0x31, response[RESPONSE_TYPE]);

    count = little_endian_to_uint16(&response[HEADER_LENGTH]);

    CuAssertIntEquals(tc, 10, count);

    cursor = &response[HEADER_LENGTH + 2];

    for (i = 0 ; i < count ; i++) {
        uint8_t item_size = cursor[0];
        uint8_t id = cursor[1];
        uint16_t val = little_endian_to_uint16(&cursor[2]);

        if (id == 0x00 
                || id == 0x01
                || id == 0x02
                || id == 0x03
                || id == 0x04
                || id == 0x35
                || id == 0x36
                || id == 0x37
                ) {
            ++assert_count;
        } else if(id == 0x38) {
            CuAssertIntEquals(tc, 0x17, val);
            ++assert_count;
        }

        fprintf(stderr, "REG 0x%02x: 0x%04x\n", id, val);

        cursor += item_size + 1;
    }

    CuAssertIntEquals(tc, 9, assert_count);
}

void dump_works(CuTest *tc) {
    int length;
    int strpos = COMMAND_HEADER_LENGTH + 3;

    unsigned char command[] =
        "\x02\x01"
        "\xff\xff\xff\xff"
        "\xaf\xe9\x23\x3d"

        "\x41"

        "\x01"
        "\x01"
        "\x09"
        "/dev/null"
    ;

    connection_setup(tc);

    send_command(command);

    length = wait_for_response_id(tc, command);

    CuAssertIntEquals(tc, 0x41, response[RESPONSE_TYPE]);
}

void undump_works(CuTest *tc) {
    int length, pc;
    int undump_strpos = COMMAND_HEADER_LENGTH + 1;

    int dump_strpos = COMMAND_HEADER_LENGTH + 3;

    unsigned char reset_command[] = {
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xaf, 0xe9, 0x23, 0x3d, 

        0xcc,

        0x00,
    };

    unsigned char dump_command[] =
        "\x02\x01"
        "\xff\xff\xff\xff"
        "\xaf\xe9\x23\x3d"

        "\x41"

        "\x01"
        "\x01"
        "\xd2"
        "                                                                      "
        "                                                                      "
        "                                                                      "
    ;

    unsigned char undump_command[] =
        "\x02\x01"
        "\xff\xff\xff\xff"
        "\xaf\xe9\x23\x3d"

        "\x42"

        "\xd2"
        "                                                                      "
        "                                                                      "
        "                                                                      "
    ;

    connection_setup(tc);

    /* reset */
    send_command(reset_command);
    length = wait_for_response_id(tc, reset_command);
    CuAssertIntEquals(tc, 0xcc, response[RESPONSE_TYPE]);

    /* dump */
    getcwd((char *)&dump_command[dump_strpos], 0xd2);
    strcpy((char *)&dump_command[dump_strpos + strlen((char *)&dump_command[dump_strpos])], "/undump.bin");
    send_command(dump_command);

    length = wait_for_response_id(tc, dump_command);
    CuAssertIntEquals(tc, 0x41, response[RESPONSE_TYPE]);

    /* undump */
    getcwd((char *)&undump_command[undump_strpos], 0xd2);
    strcpy((char *)&undump_command[undump_strpos + strlen((char *)&undump_command[undump_strpos])], "/undump.bin");
    send_command(undump_command);

    length = wait_for_response_id(tc, undump_command);
    CuAssertIntEquals(tc, 0x42, response[RESPONSE_TYPE]);

    pc = little_endian_to_uint16(&response[HEADER_LENGTH]);
    printf("PC: %04x\n", pc);

    /* this relies on that the "dump" command happens right after reset */
    CuAssertTrue(tc, pc >= 0xfce2);
    CuAssertTrue(tc, pc <= 0xff7d);
}

void keyboard_feed_works(CuTest *tc) {
    int length;

    unsigned char keyboard_command[] = { 
        "\x02\x02"
        "\xff\xff\xff\xff"
        "\xad\xe5\x30\x45"

        "\x72"

        "\x08"
        "\x53\x59\x53\x20\x32\x30\x36\x31"
    };

    // set mem

    connection_setup(tc);

    // keyboard

    send_command(keyboard_command);

    length = wait_for_response_id(tc, keyboard_command);

    CuAssertIntEquals(tc, 0x72, response[RESPONSE_TYPE]);
}

void mem_set_works(CuTest *tc) {
    unsigned char real_command[10000];
    int length;
    long prg_size;
    FILE* fil = fopen("./cc65-test.prg", "rb");

    unsigned char command[] = {
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xa9, 0xe3, 0x28, 0x37, 

        0x02,

        0x00,
        0xff, 0x07,
        0xff, 0xff,
        0x00,
        0x01, 0x00,
    };

    unsigned char keyboard_command[] = { 
        "\x02\x02"
        "\xff\xff\xff\xff"
        "\xad\xe5\x30\x45"

        "\x72"

        "\x09"
        "\x53\x59\x53\x20\x32\x30\x36\x31\x0d"
    };

    // directly load the program into memory, then manually start it by typing out the sys line

    connection_setup(tc);

    CuAssertIntEquals(tc, 0, fseek(fil, 0, SEEK_END));
    prg_size = ftell(fil);
    rewind(fil);

    memcpy(real_command, command, sizeof(command));

    write_uint16(0x7ff + prg_size - 1, &real_command[COMMAND_HEADER_LENGTH + 3]);

    CuAssertTrue(tc, fread(&real_command[sizeof(command)], prg_size, 1, fil) > 0);

    really_send_command(real_command, sizeof(command) + prg_size);

    length = wait_for_response_id(tc, command);

    CuAssertIntEquals(tc, 0x02, response[RESPONSE_TYPE]);

    // keyboard (sys 2061)

    send_command(keyboard_command);

    length = wait_for_response_id(tc, keyboard_command);

    CuAssertIntEquals(tc, 0x72, response[RESPONSE_TYPE]);
}

void mem_set_sidefx(CuTest *tc) {
    int length;
    #define sidefx_size 0x10000
    FILE* fil = fopen("./cc65-test.prg", "rb");

    unsigned char get_command[] = {
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xae, 0xed, 0xdf, 0xcb, 

        0x01,

        0x00, // sidefx
        0x00, 0x00, // start
        0xff, 0xff, // end
        0x00, // memspace
        0x00, 0x00, // bank id
    };

    unsigned char set_command[] = {
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xae, 0xeb, 0xe1, 0xcb, 

        0x02,

        0x01, // sidefx
        0x00, 0x00, // start
        0xff, 0xff, // end
        0x00, // memspace
        0x00, 0x00, // bank id
    };

    unsigned char color_set_command[] = {
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xad, 0xeb, 0xe3, 0xc9, 

        0x02,

        0x01, // sidefx
        0xd0, 0x20, // start
        0xd0, 0x21, // end
        0x00, // memspace
        0x00, 0x00, // bank id
        0x00, // border color
        0x00, // bg color
    };

    unsigned char real_command[sizeof(set_command) + sidefx_size];
    unsigned char border_color;
    unsigned char bg_color;
    uint16_t border_addr = 0xd020;
    uint16_t bg_addr = 0xd021;
    unsigned char *border_ptr = &real_command[sizeof(set_command) + border_addr];
    unsigned char *bg_ptr = &real_command[sizeof(set_command) + bg_addr];

    // read the entire memory

    connection_setup(tc);

    send_command(get_command);

    length = wait_for_response_id(tc, get_command);

    memcpy(real_command, set_command, sizeof(set_command));

    memcpy(&real_command[sizeof(set_command)], &response[HEADER_LENGTH + 2], sidefx_size);

    // assert the end of the memory contains the cold reset address

    CuAssertIntEquals(tc, 0xfce2, little_endian_to_uint16(&real_command[sizeof(real_command) - 4]));

    // check that the memory is still the same

    send_command(get_command);

    length = wait_for_response_id(tc, get_command);

    for(int i = 0; i < sidefx_size; i++) {
        usleep(0);
        fprintf(stderr, "  Comparing memory@%4x\r", i);
        // compare to previous value
        CuAssertIntEquals(tc, real_command[sizeof(set_command) + i], response[HEADER_LENGTH + 2 + i]);
    }

    fprintf(stderr, "\nMemory hasn't changed between multiple reads.\n");

    // flip border and background colors
    border_color = *border_ptr;
    bg_color = *bg_ptr;

    *border_ptr = bg_color;
    *bg_ptr = border_color;

    // write only the two bytes

    color_set_command[COMMAND_HEADER_LENGTH + 8] = bg_color;
    color_set_command[COMMAND_HEADER_LENGTH + 9] = border_color;

    send_command(color_set_command);

    length = wait_for_response_id(tc, color_set_command);

    // assert the two bytes
    send_command(get_command);

    CuAssertIntEquals(tc, bg_color, response[HEADER_LENGTH + 2 + border_addr]);
    CuAssertIntEquals(tc, border_color, response[HEADER_LENGTH + 2 + bg_addr]);

    // write the entire memory

    send_command(real_command);

    length = wait_for_response_id(tc, set_command);


    // check that the memory is still the same

    send_command(get_command);

    length = wait_for_response_id(tc, get_command);

    for(int i = 0; i < sidefx_size; i++) {
        usleep(0);
        fprintf(stderr, "  Comparing memory@%4x\r", i);
        // compare to previous value
        CuAssertIntEquals(tc, real_command[sizeof(set_command) + i], response[HEADER_LENGTH + 2 + i]);
    }

    fprintf(stderr, "\nMemory hasn't changed after writing.\n");
}

void mem_get_works(CuTest *tc) {
    int length;
    uint16_t mem_size;

    unsigned char command[] = {
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xa9, 0xe3, 0x28, 0x37, 

        0x01,

        0x00,
        0xfc, 0xff,
        0xfd, 0xff,
        0x00,
        0x00, 0x00,
    };

    connection_setup(tc);

    send_command(command);

    length = wait_for_response_id(tc, command);

    CuAssertIntEquals(tc, 0x01, response[RESPONSE_TYPE]);

    mem_size = little_endian_to_uint16(&response[HEADER_LENGTH]);

    CuAssertIntEquals(tc, 2, mem_size);

    CuAssertIntEquals(tc, 0xfce2, little_endian_to_uint16(&response[HEADER_LENGTH + 2]));
}

void exit_works(CuTest *tc) {
    int length;

    unsigned char command[] = {
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xaf, 0xe9, 0x23, 0x3d, 

        0xaa,
    };

    connection_setup(tc);

    send_command(command);

    length = wait_for_response_id(tc, command);

    CuAssertIntEquals(tc, 0xaa, response[RESPONSE_TYPE]);

    length = wait_for_response_type(tc, 0x63);

    CuAssertIntEquals(tc, 0x63, response[RESPONSE_TYPE]);
}

void advance_instructions_works(CuTest *tc) {
    int length;

    unsigned char command[] = {
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xb3, 0xe4, 0x2d, 0x30, 

        0x71,

        0x00,
        0x01, 0x00,
    };

    connection_setup(tc);

    send_command(command);

    length = wait_for_response_id(tc, command);

    CuAssertIntEquals(tc, 0x71, response[RESPONSE_TYPE]);

    length = wait_for_response_type(tc, 0x63);

    CuAssertIntEquals(tc, 0x63, response[RESPONSE_TYPE]);

    length = wait_for_response_type(tc, 0x62);

    CuAssertIntEquals(tc, 0x62, response[RESPONSE_TYPE]);
}

void execute_until_return_works(CuTest *tc) {
    unsigned char real_command[10000];
    int length;
    long prg_size;
    FILE* fil = fopen("./cc65-test.prg", "rb");

    unsigned char mem_command[] = {
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xa9, 0xe3, 0x28, 0x37, 

        0x02,

        0x00,
        0xff, 0x07,
        0xff, 0xff,
        0x00,
        0x01, 0x00,
    };

    unsigned char keyboard_command[] = { 
        "\x02\x02"
        "\xff\xff\xff\xff"
        "\xad\xe5\x30\x45"

        "\x72"

        "\x0a"
        "sys 2061\\n"
    };

    unsigned char exec_command[] = {
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xb3, 0xe4, 0x2d, 0x30, 

        0x73,

        0x00,
        0x01, 0x00,
    };

    unsigned char brk_command[] = { 
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xb4, 0xd8, 0x44, 0x19, 

        0x12, 

        0x0d, 0x08,
        0x0d, 0x08,
        0x01,
        0x01,
        0x04,
        0x00,
    };

    unsigned char exit_command[] = {
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xaf, 0xe9, 0x23, 0x3d, 

        0xaa,
    };

    // set mem

    connection_setup(tc);

    CuAssertIntEquals(tc, 0, fseek(fil, 0, SEEK_END));
    prg_size = ftell(fil);
    rewind(fil);

    memcpy(real_command, mem_command, sizeof(mem_command));

    write_uint16(0x7ff + prg_size - 1, &real_command[COMMAND_HEADER_LENGTH + 3]);

    CuAssertTrue(tc, fread(&real_command[sizeof(mem_command)], prg_size, 1, fil) > 0);

    really_send_command(real_command, sizeof(mem_command) + prg_size);

    length = wait_for_response_id(tc, mem_command);

    CuAssertIntEquals(tc, 0x02, response[RESPONSE_TYPE]);

    // break

    send_command(brk_command);

    length = wait_for_response_id(tc, brk_command);

    CuAssertIntEquals(tc, 0x11, response[RESPONSE_TYPE]);

    // keyboard

    send_command(keyboard_command);

    length = wait_for_response_id(tc, keyboard_command);

    CuAssertIntEquals(tc, 0x72, response[RESPONSE_TYPE]);

    // continue

    send_command(exit_command);

    length = wait_for_response_id(tc, exit_command);

    CuAssertIntEquals(tc, 0xaa, response[RESPONSE_TYPE]);

    length = wait_for_response_type(tc, 0x63);

    CuAssertIntEquals(tc, 0x63, response[RESPONSE_TYPE]);

    length = wait_for_response_type(tc, 0x62);

    CuAssertIntEquals(tc, 0x62, response[RESPONSE_TYPE]);

    // exec

    send_command(exec_command);

    length = wait_for_response_id(tc, exec_command);

    CuAssertIntEquals(tc, 0x73, response[RESPONSE_TYPE]);

    length = wait_for_response_type(tc, 0x63);

    CuAssertIntEquals(tc, 0x63, response[RESPONSE_TYPE]);

    length = wait_for_response_type(tc, 0x62);

    CuAssertIntEquals(tc, 0x62, response[RESPONSE_TYPE]);
}

void reset_works(CuTest *tc) {
    int length;

    unsigned char command[] = {
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xaf, 0xe9, 0x23, 0x3d, 

        0xcc,

        0x00,
    };

    connection_setup(tc);

    send_command(command);

    length = wait_for_response_id(tc, command);

    CuAssertIntEquals(tc, 0xcc, response[RESPONSE_TYPE]);
}

void autostart_works(CuTest *tc) {
    int length;
    int strpos = COMMAND_HEADER_LENGTH + 4;

    unsigned char command[] =
        "\x02\x02"
        "\xff\xff\xff\xff"
        "\xaf\xe9\x23\x3d"

        "\xdd"

        "\x01"
        "\x00\x00"
        "\xd2"
        "                                                                      "
        "                                                                      "
        "                                                                      "
    ;

    getcwd((char *)&command[strpos], 0xd2);

    strcpy((char *)&command[strpos + strlen((char *)&command[strpos])], "/cc65-test.prg");

    connection_setup(tc);

    send_command(command);

    length = wait_for_response_id(tc, command);

    CuAssertIntEquals(tc, 0xdd, response[RESPONSE_TYPE]);

    length = wait_for_response_type(tc, 0x63);

    CuAssertIntEquals(tc, 0x63, response[RESPONSE_TYPE]);

    length = wait_for_response_type(tc, 0x62);

    CuAssertIntEquals(tc, 0x62, response[RESPONSE_TYPE]);
}

void autoload_works(CuTest *tc) {
    int length;
    int strpos = COMMAND_HEADER_LENGTH + 4;

    unsigned char command[] =
        "\x02\x02"
        "\xff\xff\xff\xff"
        "\x45\x09\x90\xae"

        "\xdd"

        "\x00"
        "\x00\x00"
        "\xd2"
        "                                                                      "
        "                                                                      "
        "                                                                      "
    ;

    getcwd((char *)&command[strpos], 0xd2);

    strcpy((char *)&command[strpos + strlen((char *)&command[strpos])], "/cc65-test.prg");

    connection_setup(tc);

    send_command(command);

    length = wait_for_response_id(tc, command);

    // autoload
    CuAssertIntEquals(tc, 0xdd, response[RESPONSE_TYPE]);

    // wait for resumed
    length = wait_for_response_type(tc, 0x63);

    CuAssertIntEquals(tc, 0x63, response[RESPONSE_TYPE]);
}

void banks_available_works(CuTest *tc) {
    int length, i, count;
    int assert_count = 0;
    unsigned char *cursor;

    unsigned char command[] = {
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xaf, 0xe9, 0x23, 0x3d, 

        0x82,
    };

    connection_setup(tc);

    send_command(command);

    length = wait_for_response_id(tc, command);

    CuAssertIntEquals(tc, 0x82, response[RESPONSE_TYPE]);

    count = little_endian_to_uint16(&response[HEADER_LENGTH + 0]);

    cursor = &response[HEADER_LENGTH + 2];

    for (i = 0 ; i < count ; i++) {
        uint8_t item_size = cursor[0];
        uint16_t id = little_endian_to_uint16(&cursor[1]);
        uint8_t name_length = cursor[3];
        char* name = (char *)&cursor[4];

        fprintf(stderr, "NAME %.*s\n", name_length, name);

        if (id == 0) {
            if(strncmp(name, "cpu", 3) == 0) {
                ++assert_count;
            }
        } else if (id == 2) {
            CuAssertTrue(tc, strncmp(name, "rom", 3) == 0);
            ++assert_count;
        }

        cursor += item_size + 1;
    }

    CuAssertIntEquals(tc, 2, assert_count);
}

void registers_available_works(CuTest *tc) {
    int length, i, count;
    int assert_count = 0;
    unsigned char *cursor;

    unsigned char command[] = {
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xb5, 0xe9, 0x23, 0x3d, 

        0x83,

        0x00,
    };

    connection_setup(tc);

    send_command(command);

    length = wait_for_response_id(tc, command);

    CuAssertIntEquals(tc, 0x83, response[RESPONSE_TYPE]);

    count = little_endian_to_uint16(&response[HEADER_LENGTH + 0]);

    cursor = &response[HEADER_LENGTH + 2];

    for (i = 0 ; i < count ; i++) {
        uint8_t item_size = cursor[0];
        uint16_t id = cursor[1];
        uint16_t size = cursor[2];
        uint8_t name_length = cursor[3];
        char* name = (char *)&cursor[4];

        fprintf(stderr, "REGISTER %.*s\n", name_length, name);

        if (id == 0x03) {
            CuAssertTrue(tc, strncmp(name, "PC", 2) == 0);
            CuAssertIntEquals(tc, 16, size);
            ++assert_count;
        } else if (id == 0x00) {
            CuAssertTrue(tc, strncmp(name, "A", 1) == 0);
            CuAssertIntEquals(tc, 8, size);
            ++assert_count;
        } else if (id == 0x35) {
            ++assert_count;
        } else if (id == 0x36) {
            ++assert_count;
        } else if (id == 0x37) {
            ++assert_count;
        } else if (id == 0x38) {
            ++assert_count;
        }

        cursor += item_size + 1;
    }

    CuAssertIntEquals(tc, 6, assert_count);
}

void resource_set_works(CuTest *tc) {
    int length;

    unsigned char command[] =
        "\x02\x01"
        "\xff\xff\xff\xff"
        "\xad\xf9\x23\x3d"

        "\x52"

        "\x01"
        "\x0f"
        "VICIIBorderMode"
        "\x02"
        "\x02\x00"
    ;

    connection_setup(tc);

    send_command(command);

    length = wait_for_response_id(tc, command);

    CuAssertIntEquals(tc, 0x52, response[RESPONSE_TYPE]);
}

void resource_get_works(CuTest *tc) {
    int length;

    unsigned char command[] =
        "\x02\x01"
        "\xff\xff\xff\xff"
        "\xad\xf9\x23\x3d"

        "\x51"

        "\x0f"
        "VICIIBorderMode"
    ;

    connection_setup(tc);

    send_command(command);

    length = wait_for_response_id(tc, command);

    CuAssertIntEquals(tc, 0x51, response[RESPONSE_TYPE]);

    /* Type */
    CuAssertIntEquals(tc, 0x01, response[HEADER_LENGTH]);

    /* Length */
    CuAssertIntEquals(tc, 0x04, response[HEADER_LENGTH + 1]);
}

void palette_get_works(CuTest *tc) {
    int length, i;
    unsigned char *cursor;
    int assert_count = 0;

    unsigned char command[] = {
        0x02, API_VERSION,
        0xff, 0xff, 0xff, 0xff,
        0xa3, 0x52, 0x09, 0x9f,

        0x91,   /* command type = get palette */

        0x01   /* VIC-II */
    };

    connection_setup(tc);

    send_command(command);

    length = wait_for_response_id(tc, command);

    CuAssertIntEquals(tc, 0x91, response[RESPONSE_TYPE]);

    CuAssertIntEquals(tc, 16, little_endian_to_uint16(&response[HEADER_LENGTH]));

    cursor = &response[HEADER_LENGTH + 2];

    for (i = 0 ; i < 16 ; i++) {
        uint8_t item_size = cursor[0];
        uint8_t r = cursor[1];
        uint8_t g = cursor[2];
        uint8_t b = cursor[3];

        CuAssertIntEquals(tc, 3, item_size);

        /* black */
        if (i == 0) {
            CuAssertTrue(tc, r < 0x10);
            CuAssertTrue(tc, g < 0x10);
            CuAssertTrue(tc, b < 0x10);
            ++assert_count;
        /* white */
        } else if (i == 1) {
            CuAssertTrue(tc, r > 0xff - 0x10);
            CuAssertTrue(tc, g > 0xff - 0x10);
            CuAssertTrue(tc, b > 0xff - 0x10);
            ++assert_count;
        }

        cursor += item_size + 1;
    }

    CuAssertIntEquals(tc, 2, assert_count);
}

void joyport_set_works(CuTest *tc) {
    int length;

    unsigned char command[] = {
        0x02, API_VERSION,
        0xff, 0xff, 0xff, 0xff,
        0x23, 0x09, 0x24, 0xba,

        0xa2,   /* command type */

        0x00, 0x00,   /* Joyport 1 */
        0xff, 0x00,
    };

    connection_setup(tc);

    send_command(command);

    length = wait_for_response_id(tc, command);

    CuAssertIntEquals(tc, 0xa2, response[RESPONSE_TYPE]);
}

void userport_set_works(CuTest *tc) {
    int length;

    unsigned char command[] = {
        0x02, API_VERSION,
        0xff, 0xff, 0xff, 0xff,
        0xa5, 0x5f, 0x2a, 0x33,

        0xb2,   /* command type */

        0xff, 0x00,
    };

    connection_setup(tc);

    send_command(command);

    length = wait_for_response_id(tc, command);

    CuAssertIntEquals(tc, 0xb2, response[RESPONSE_TYPE]);
}

void display_get_works(CuTest *tc) {
    int length;
    unsigned char *cursor;

    unsigned char command[] = {
        0x02, API_VERSION,             /* STX, Api v1 */
        0xff, 0xff, 0xff, 0xff, /* length of command body */
        0xaf, 0xe9, 0x23, 0x3d, /* request ID */

        0x84,   /* command type = get display */

        0x01,   /* VIC-II */
        0x00,
    };

    connection_setup(tc);

    send_command(command);

    length = wait_for_response_id(tc, command);

    CuAssertIntEquals(tc, 0x84, response[RESPONSE_TYPE]);

    printf("Length of the fields before the display buffer: %d\n", little_endian_to_uint32(&response[HEADER_LENGTH]));

    printf("Debug width of display buffer (uncropped): %d\n", little_endian_to_uint16(&response[HEADER_LENGTH + 4]));
    printf("Debug height of display buffer (uncropped): %d\n", little_endian_to_uint16(&response[HEADER_LENGTH + 4 + 2]));
    printf("X offset to the inner part of the screen: %d\n", little_endian_to_uint16(&response[HEADER_LENGTH + 4 + 4]));
    printf("Y offset to the inner part of the screen: %d\n", little_endian_to_uint16(&response[HEADER_LENGTH + 4 + 6]));
    printf("width of display buffer (cropped): %d\n", little_endian_to_uint16(&response[HEADER_LENGTH + 4 + 8]));
    printf("height of display buffer (cropped): %d\n", little_endian_to_uint16(&response[HEADER_LENGTH + 4 + 10]));
    printf("Bits per pixel of display buffer: %d\n", response[HEADER_LENGTH + 4 + 12]);

    printf("Length of display buffer: %d\n", little_endian_to_uint32(&response[HEADER_LENGTH + 4 + 13]));

    CuAssertIntEquals(tc, 13, little_endian_to_uint32(&response[HEADER_LENGTH]));
    CuAssertIntEquals(tc, little_endian_to_uint32(&response[HEADER_LENGTH + 4 + 13]),
            little_endian_to_uint16(&response[HEADER_LENGTH + 4]) *
            little_endian_to_uint16(&response[HEADER_LENGTH + 4 + 2]));
}

void vice_info_works(CuTest *tc) {
    int length, misc_fields_length;
    unsigned char *cursor;

    unsigned char command[] = {
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xaf, 0xe9, 0x23, 0x3d, 

        0x85,
    };

    connection_setup(tc);

    send_command(command);

    length = wait_for_response_id(tc, command);

    CuAssertIntEquals(tc, 0x85, response[RESPONSE_TYPE]);

    /* VICE Version */
    CuAssertIntEquals(tc, 4, response[HEADER_LENGTH]);
    CuAssertTrue(tc, response[HEADER_LENGTH + 1] >= 3);
    printf("VICE Version: %d.%d.%d.%d\n",
        response[HEADER_LENGTH + 1],
        response[HEADER_LENGTH + 2],
        response[HEADER_LENGTH + 3],
        response[HEADER_LENGTH + 4]
    );

    /* SVN Version */
    CuAssertIntEquals(tc, 4, response[HEADER_LENGTH + 5]);
    printf("SVN Version: %d\n", little_endian_to_uint32(&response[HEADER_LENGTH + 6]));
    CuAssertTrue(tc, little_endian_to_uint32(&response[HEADER_LENGTH + 6]) > 38911);
}

static CuSuite* get_suite(void)
{
    CuSuite* suite = CuSuiteNew();

    SUITE_ADD_TEST(suite, request_id_is_set);

    SUITE_ADD_TEST(suite, checkpoint_set_works);
    SUITE_ADD_TEST(suite, checkpoint_get_works);
    SUITE_ADD_TEST(suite, checkpoint_delete_works);
    SUITE_ADD_TEST(suite, checkpoint_list_works);
    SUITE_ADD_TEST(suite, checkpoint_list_does_dedupe);
    SUITE_ADD_TEST(suite, checkpoint_enable_works);
    SUITE_ADD_TEST(suite, checkpoint_disable_works);

    SUITE_ADD_TEST(suite, condition_set_works);

    SUITE_ADD_TEST(suite, registers_set_works);
    SUITE_ADD_TEST(suite, registers_get_works);
    SUITE_ADD_TEST(suite, registers_get_drive_works);

    SUITE_ADD_TEST(suite, mem_set_works);
    //SUITE_ADD_TEST(suite, mem_set_sidefx);
    SUITE_ADD_TEST(suite, mem_get_works);

    SUITE_ADD_TEST(suite, dump_works);
    SUITE_ADD_TEST(suite, undump_works);

    SUITE_ADD_TEST(suite, resource_get_works);
    SUITE_ADD_TEST(suite, resource_set_works);

    SUITE_ADD_TEST(suite, advance_instructions_works);
    SUITE_ADD_TEST(suite, keyboard_feed_works);
    SUITE_ADD_TEST(suite, execute_until_return_works);

    SUITE_ADD_TEST(suite, banks_available_works);
    SUITE_ADD_TEST(suite, registers_available_works);
    SUITE_ADD_TEST(suite, display_get_works);
    SUITE_ADD_TEST(suite, vice_info_works);

    SUITE_ADD_TEST(suite, palette_get_works);

    SUITE_ADD_TEST(suite, joyport_set_works);

    SUITE_ADD_TEST(suite, userport_set_works);

    SUITE_ADD_TEST(suite, exit_works);
    SUITE_ADD_TEST(suite, reset_works);

    SUITE_ADD_TEST(suite, autostart_works);
    SUITE_ADD_TEST(suite, autoload_works);

    return suite;
}

static int run_tests(CuSuite* inner)
{
	CuString *output = CuStringNew();
	CuSuite* suite = CuSuiteNew();

	CuSuiteAddSuite(suite, inner);

	CuSuiteRun(suite);
	CuSuiteSummary(suite, output);
	CuSuiteDetails(suite, output);
	printf("%s\n", output->buffer);

    return suite->failCount;
}

static void mon_quit() {
    int length;

    unsigned char command[] = {
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xaf, 0xe9, 0x23, 0x3d, 

        0xbb,
    };

    send_command(command);

    sleep(1);
}

int main(int argc, char** argv)
{
    char* single_test_name = NULL;
    int ret;
    int i;
    int port;
    CuSuite* suite = get_suite();

    if (argc < 2 || strcmp(argv[1], "--help") == 0 || strcmp(argv[1], "-help") == 0) {
        printf("Syntax: %s <port of x64sc binary monitor> [name of test to run]\n", argv[0]);
        printf("\nTests available: \n\n");

        for (i = 0 ; i < suite->count ; i++) {
            CuTest* test = suite->list[i];

            printf("%s\n", test->name);
        }

        return EXIT_FAILURE;
    } else if (argc >= 3) {
        single_test_name = argv[2];
    }

    if (!sscanf(argv[1], "%d", &port)) {
        printf("You need to enter a port number only: %s\n", argv[1]);
        return EXIT_FAILURE;
    }

    connection_set_port(port);

    if (single_test_name) {
        for (i = 0 ; i < suite->count ; i++) {
            CuTest* test = suite->list[i];

            if (strcmp(test->name, single_test_name) == 0) {
                CuSuite* single_suite = CuSuiteNew();

                CuSuiteAdd(single_suite, test);

                ret = run_tests(single_suite);
            }
        }
    } else {
        ret = run_tests(suite);
    }

    if (getenv("MON_QUIT") && getenv("MON_QUIT")[0] == '1') {
        mon_quit();
    }

    connection_close();

    return ret;
}
