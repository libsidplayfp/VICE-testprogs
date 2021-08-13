/*
 * main.c - Tests for VICE's binary monitor interface
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

#include <sys/socket.h>
#include <netinet/tcp.h>
#include <stdlib.h>
#include <stdio.h>
#include <arpa/inet.h>
#include <string.h>
#include <unistd.h>
#include <sys/poll.h>

#include "CuTest.h"

#define HEADER_LENGTH 12
#define RESPONSE_TYPE 6
#define RESPONSE_ERROR 7
#define RESPONSE_ID 8

#define COMMAND_ID 6
#define COMMAND_HEADER_LENGTH 11
#define COMMAND_LENGTH 2
#define API_VERSION 0x02

int response_count = 0;
int sock = 0;
struct pollfd fds[1];
int port = 0;

void setup(CuTest *tc) {
    struct sockaddr_in *serv_addr;

    if (sock) {
        close(sock);
        sock = 0;
    }

    response_count = 0;

    if (sock) {
        return;
    }

    sock = socket(AF_INET, SOCK_STREAM, 0);

    /* Disable nagle algorithm to ensure we split commands over multiple packets */
    int flag = 1;
    int result = setsockopt(sock, IPPROTO_TCP, TCP_NODELAY, (char *)&flag, sizeof(int));

    fds[0].fd = sock;
    fds[0].events = POLLIN;
    fds[0].revents = 0;

    CuAssertTrue(tc, sock >= 0);

    serv_addr = malloc(sizeof(struct sockaddr_in));

    serv_addr->sin_family = AF_INET;
    serv_addr->sin_port = htons(port);

    CuAssertTrue(tc, inet_pton(AF_INET, "127.0.0.1", &serv_addr->sin_addr) > 0);

    CuAssertTrue(tc, connect(sock, (struct sockaddr *)serv_addr, sizeof(*serv_addr)) >= 0);

    free(serv_addr);
}

static uint32_t little_endian_to_uint32(unsigned char *input) {
    return (input[3] << 24) + (input[2] << 16) + (input[1] << 8) + input[0];
}

static uint16_t little_endian_to_uint16(unsigned char *input) {
    return (input[1] << 8) + input[0];
}

static unsigned char *write_uint16(uint16_t input, unsigned char *output) {
    output[0] = input & 0xFFu;
    output[1] = (input >> 8) & 0xFFu;

    return output + 2;
}

static unsigned char *write_uint32(uint32_t input, unsigned char *output) {
    output[0] = input & 0xFFu;
    output[1] = (input >> 8) & 0xFFu;
    output[2] = (input >> 16) & 0xFFu;
    output[3] = (uint8_t)(input >> 24) & 0xFFu;

    return output + 4;
}

void really_send_command(unsigned char* command, size_t length) {
    write_uint32(length - COMMAND_HEADER_LENGTH, &command[COMMAND_LENGTH]);
    for (int i = 0; i < length; i++) {
        /* Send each byte to trigger incomplete reads on the other side */
        send(sock, command + i, 1, 0);
    }
}

#define send_command(command) really_send_command(command, sizeof(command))

unsigned char response[1<<24];

int readloop(CuTest *tc, unsigned char *ptr, int length) {
    int n = 0;
    while(n < length) {
        CuAssertTrue(tc, poll(fds, 1, 10000));
        int o = read(sock, &ptr[n], length - n);
        CuAssertTrue(tc, o > 0);
        n += o;
    }

    return n;
}

int read_response(CuTest *tc) {
    response_count++;
    readloop(tc, response, 6);
    return 6 + readloop(tc, &response[6], 6 + little_endian_to_uint32(&response[2]));
}

int wait_for_response_type(CuTest *tc, uint8_t response_type) {
    int length;

    do {
        length = read_response(tc);
        fprintf(stderr, "%s: request %d: CID %8x RID %8x length %d type %2x error %2x \n", 
            tc->name, 
            response_count, 
            0xffffffff, 
            little_endian_to_uint32(&response[RESPONSE_ID]), 
            length, 
            response[RESPONSE_TYPE], 
            response[RESPONSE_ERROR]
        );
    } while (response_type != response[RESPONSE_TYPE]);

    return length;
}

int wait_for_response_id(CuTest *tc, unsigned char *command) {
    int length;

    do {
        length = read_response(tc);
        fprintf(stderr, "%s: request %d: CID %8x RID %8x length %d type %2x error %2x \n", 
            tc->name, 
            response_count, 
            little_endian_to_uint32(&command[COMMAND_ID]), 
            little_endian_to_uint32(&response[RESPONSE_ID]), 
            length, 
            response[RESPONSE_TYPE], 
            response[RESPONSE_ERROR]
        );
    } while (little_endian_to_uint32(&command[COMMAND_ID]) != little_endian_to_uint32(&response[RESPONSE_ID]));

    return length;
}

void request_id_is_set(CuTest* tc) {
    int length;

    unsigned char command[] = { 
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xa6, 0xea, 0x28, 0x1d, 

        0x81, 
    };

    setup(tc);

    send_command(command);

    length = wait_for_response_id(tc, command);

    CuAssertIntEquals(tc, 0x81, response[RESPONSE_TYPE]);

    CuAssertIntEquals(tc, 0, length - HEADER_LENGTH);
}

void checkpoint_set_works(CuTest *tc) {
    int length;

    unsigned char set_command[] = { 
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xb4, 0xd8, 0x44, 0x19, 

        0x12, 

        0xe2, 0xfc,
        0xe3, 0xfc,
        0x01,
        0x00,
        0x04,
        0x00,
    };

    setup(tc);

    send_command(set_command);

    length = wait_for_response_id(tc, set_command);

    CuAssertTrue(tc, response[RESPONSE_TYPE] == 0x11);

    CuAssertTrue(tc, length - HEADER_LENGTH >= 21);

    // start
    CuAssertIntEquals(tc, little_endian_to_uint16(&set_command[COMMAND_HEADER_LENGTH + 0]), little_endian_to_uint16(&response[HEADER_LENGTH + 5]));

    // end
    CuAssertIntEquals(tc, little_endian_to_uint16(&set_command[COMMAND_HEADER_LENGTH + 2]), little_endian_to_uint16(&response[HEADER_LENGTH + 7]));

    // stop
    CuAssertIntEquals(tc, set_command[COMMAND_HEADER_LENGTH + 4], response[HEADER_LENGTH + 9]);

    // enabled
    CuAssertIntEquals(tc, set_command[COMMAND_HEADER_LENGTH + 5], response[HEADER_LENGTH + 10]);

    // operation
    CuAssertIntEquals(tc, set_command[COMMAND_HEADER_LENGTH + 6], response[HEADER_LENGTH + 11]);

    // temp
    CuAssertIntEquals(tc, set_command[COMMAND_HEADER_LENGTH + 7], response[HEADER_LENGTH + 12]);

    // hit count
    CuAssertIntEquals(tc, 0, little_endian_to_uint32(&response[HEADER_LENGTH + 13]));

    // ignore count
    CuAssertIntEquals(tc, 0, little_endian_to_uint32(&response[HEADER_LENGTH + 17]));
}

void checkpoint_get_works(CuTest *tc) {
    int length;
    uint32_t brknum;

    // set

    unsigned char set_command[] = { 
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xb7, 0xde, 0x2d, 0x1d, 

        0x12, 

        0xe2, 0xfc,
        0xe3, 0xfc,
        0x01,
        0x00,
        0x04,
        0x00,
    };

    unsigned char get_command[] = { 
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xe1, 0xc7, 0x52, 0x2f, 

        0x11,

        0xff, 0xff, 0xff, 0xff,
    };

    setup(tc);

    send_command(set_command);

    length = wait_for_response_id(tc, set_command);

    CuAssertIntEquals(tc, 0x11, response[RESPONSE_TYPE]);

    brknum = little_endian_to_uint32(&response[HEADER_LENGTH + 0]);

    // get

    write_uint32(brknum, &get_command[COMMAND_HEADER_LENGTH]);

    send_command(get_command);

    length = wait_for_response_id(tc, get_command);

    CuAssertIntEquals(tc, 0x11, response[RESPONSE_TYPE]);

    // start
    CuAssertIntEquals(tc, little_endian_to_uint16(&set_command[COMMAND_HEADER_LENGTH + 0]), little_endian_to_uint16(&response[HEADER_LENGTH + 5]));

    // end
    CuAssertIntEquals(tc, little_endian_to_uint16(&set_command[COMMAND_HEADER_LENGTH + 2]), little_endian_to_uint16(&response[HEADER_LENGTH + 7]));

    // stop
    CuAssertIntEquals(tc, set_command[COMMAND_HEADER_LENGTH + 4], response[HEADER_LENGTH + 9]);

    // enabled
    CuAssertIntEquals(tc, set_command[COMMAND_HEADER_LENGTH + 5], response[HEADER_LENGTH + 10]);

    // operation
    CuAssertIntEquals(tc, set_command[COMMAND_HEADER_LENGTH + 6], response[HEADER_LENGTH + 11]);

    // temp
    CuAssertIntEquals(tc, set_command[COMMAND_HEADER_LENGTH + 7], response[HEADER_LENGTH + 12]);

    // hit count
    CuAssertIntEquals(tc, 0, little_endian_to_uint32(&response[HEADER_LENGTH + 13]));

    // ignore count
    CuAssertIntEquals(tc, 0, little_endian_to_uint32(&response[HEADER_LENGTH + 17]));
}

void checkpoint_delete_works(CuTest *tc) {
    int length;
    uint32_t brknum;

    // set

    unsigned char set_command[] = { 
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xc3, 0xc7, 0x4e, 0x53, 

        0x12, 

        0xe2, 0xfc,
        0xe3, 0xfc,
        0x01,
        0x00,
        0x04,
        0x00,
    };

    unsigned char delete_command[] = { 
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xcc, 0xd2, 0x16, 0x2b, 

        0x13,

        0xff, 0xff, 0xff, 0xff,
    };

    setup(tc);

    send_command(set_command);

    length = wait_for_response_id(tc, set_command);

    CuAssertIntEquals(tc, 0x11, response[RESPONSE_TYPE]);

    brknum = little_endian_to_uint32(&response[HEADER_LENGTH + 0]);

    // delete

    write_uint32(brknum, &delete_command[COMMAND_HEADER_LENGTH]);

    send_command(delete_command);

    length = wait_for_response_id(tc, delete_command);

    CuAssertIntEquals(tc, 0x13, response[RESPONSE_TYPE]);
}

void checkpoint_list_works(CuTest *tc) {
    int length;

    unsigned char set_command[] = { 
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xb2, 0xcf, 0x49, 0x16, 

        0x12, 

        0xe2, 0xfc,
        0xe3, 0xfc,
        0x01,
        0x00,
        0x04,
        0x00,
    };

    unsigned char list_command[] = { 
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xe3, 0xb5, 0xa4, 0xe4, 

        0x14, 
    };

    setup(tc);

    send_command(set_command);

    length = wait_for_response_id(tc, set_command);

    CuAssertIntEquals(tc, 0x11, response[RESPONSE_TYPE]);

    send_command(list_command);

    length = wait_for_response_id(tc, list_command);

    while(response[RESPONSE_TYPE] != 0x14) {
        CuAssertIntEquals(tc, 0x11, response[RESPONSE_TYPE]);

        length = wait_for_response_id(tc, list_command);
    }

    CuAssertIntEquals(tc, 0x14, response[RESPONSE_TYPE]);

    CuAssertTrue(tc, little_endian_to_uint32(&response[HEADER_LENGTH]) >= 1);
}

void checkpoint_enable_works(CuTest *tc) {
    int length;
    uint32_t brknum;

    // set

    unsigned char set_command[] = { 
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xad, 0xde, 0x34, 0x12, 

        0x12, 

        0xe2, 0xfc,
        0xe3, 0xfc,
        0x01,
        0x00,
        0x04,
        0x00,
    };

    unsigned char toggle_command[] = { 
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xad, 0xde, 0xad, 0xde, 

        0x15, 

        0xff, 0xff, 0xff, 0xff,
        0x01,
    };

    unsigned char get_command[] = { 
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xef, 0xbe, 0x34, 0x12, 

        0x11,

        0xff, 0xff, 0xff, 0xff,
    };

    setup(tc);

    send_command(set_command);

    length = wait_for_response_id(tc, set_command);

    CuAssertIntEquals(tc, 0x11, response[RESPONSE_TYPE]);

    brknum = little_endian_to_uint32(&response[HEADER_LENGTH + 0]);

    // toggle

    write_uint32(brknum, &toggle_command[COMMAND_HEADER_LENGTH]);

    send_command(toggle_command);

    length = wait_for_response_id(tc, toggle_command);

    CuAssertIntEquals(tc, 0x15, response[RESPONSE_TYPE]);

    // get

    write_uint32(brknum, &get_command[COMMAND_HEADER_LENGTH]);

    send_command(get_command);

    length = wait_for_response_id(tc, get_command);

    CuAssertIntEquals(tc, 0x11, response[RESPONSE_TYPE]);

    // enabled
    CuAssertIntEquals(tc, 0x01, response[HEADER_LENGTH + 10]);
}

void checkpoint_disable_works(CuTest *tc) {
    int length;
    uint32_t brknum;

    // set

    unsigned char set_command[] = { 
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xad, 0xdf, 0x35, 0x11, 

        0x12, 

        0xe2, 0xfc,
        0xe3, 0xfc,
        0x01,
        0x01,
        0x04,
        0x00,
    };

    unsigned char toggle_command[] = { 
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xa6, 0xe0, 0xab, 0xdf, 

        0x15, 

        0xff, 0xff, 0xff, 0xff,
        0x00,
    };

    unsigned char get_command[] = { 
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xf2, 0xba, 0x39, 0x10, 

        0x11,

        0xff, 0xff, 0xff, 0xff,
    };

    setup(tc);

    send_command(set_command);

    length = wait_for_response_id(tc, set_command);

    CuAssertIntEquals(tc, 0x11, response[RESPONSE_TYPE]);

    brknum = little_endian_to_uint32(&response[HEADER_LENGTH + 0]);

    // toggle

    write_uint32(brknum, &toggle_command[COMMAND_HEADER_LENGTH]);

    send_command(toggle_command);

    length = wait_for_response_id(tc, toggle_command);

    CuAssertIntEquals(tc, 0x15, response[RESPONSE_TYPE]);

    // get

    write_uint32(brknum, &get_command[COMMAND_HEADER_LENGTH]);

    send_command(get_command);

    length = wait_for_response_id(tc, get_command);

    CuAssertIntEquals(tc, 0x11, response[RESPONSE_TYPE]);

    // enabled
    CuAssertIntEquals(tc, 0x00, response[HEADER_LENGTH + 10]);
}

void condition_set_works(CuTest *tc) {
    int length;
    uint32_t brknum;

    // set

    unsigned char set_command[] = { 
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xad, 0xdf, 0x35, 0x11, 

        0x12, 

        0xe2, 0xfc,
        0xe3, 0xfc,
        0x01,
        0x01,
        0x04,
        0x00,
    };

    unsigned char cond_set[] =
        "\x02\x01"
        "\xff\xff\xff\xff"
        "\xa6\xe0\xab\xdf"

        "\x22"

        "\xff\xff\xff\xff"
        "\x0e"
        "$9531 == $9531"
    ;

    unsigned char get_command[] = { 
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xf2, 0xba, 0x39, 0x10, 

        0x11,

        0xff, 0xff, 0xff, 0xff,
    };

    setup(tc);

    send_command(set_command);

    length = wait_for_response_id(tc, set_command);

    CuAssertIntEquals(tc, 0x11, response[RESPONSE_TYPE]);

    brknum = little_endian_to_uint32(&response[HEADER_LENGTH + 0]);

    // toggle

    write_uint32(brknum, &cond_set[COMMAND_HEADER_LENGTH]);

    send_command(cond_set);

    length = wait_for_response_id(tc, cond_set);

    CuAssertIntEquals(tc, 0x22, response[RESPONSE_TYPE]);

    // get

    write_uint32(brknum, &get_command[COMMAND_HEADER_LENGTH]);

    send_command(get_command);

    length = wait_for_response_id(tc, get_command);

    CuAssertIntEquals(tc, 0x11, response[RESPONSE_TYPE]);

    // condition set
    CuAssertIntEquals(tc, 0x01, response[HEADER_LENGTH + 21]);
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

    setup(tc);

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

    setup(tc);

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

    setup(tc);

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

    setup(tc);

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

    setup(tc);

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

    setup(tc);

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

    // set mem

    setup(tc);

    CuAssertIntEquals(tc, 0, fseek(fil, 0, SEEK_END));
    prg_size = ftell(fil);
    rewind(fil);

    memcpy(real_command, command, sizeof(command));

    write_uint16(0x7ff + prg_size - 1, &real_command[COMMAND_HEADER_LENGTH + 3]);

    CuAssertTrue(tc, fread(&real_command[sizeof(command)], prg_size, 1, fil) > 0);

    really_send_command(real_command, sizeof(command) + prg_size);

    length = wait_for_response_id(tc, command);

    CuAssertIntEquals(tc, 0x02, response[RESPONSE_TYPE]);

    // keyboard

    send_command(keyboard_command);

    length = wait_for_response_id(tc, keyboard_command);

    CuAssertIntEquals(tc, 0x72, response[RESPONSE_TYPE]);
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

    setup(tc);

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

    setup(tc);

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

    setup(tc);

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

    setup(tc);

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

    setup(tc);

    send_command(command);

    length = wait_for_response_id(tc, command);

    CuAssertIntEquals(tc, 0xcc, response[RESPONSE_TYPE]);
}

void autostart_works(CuTest *tc) {
    int length;
    int strpos = COMMAND_HEADER_LENGTH + 4;

    unsigned char command[] =
        "\x02\x01"
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

    setup(tc);

    send_command(command);

    length = wait_for_response_id(tc, command);

    CuAssertIntEquals(tc, 0xdd, response[RESPONSE_TYPE]);

    length = wait_for_response_type(tc, 0x63);

    CuAssertIntEquals(tc, 0x63, response[RESPONSE_TYPE]);

    length = wait_for_response_type(tc, 0x62);

    CuAssertIntEquals(tc, 0x62, response[RESPONSE_TYPE]);
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

    setup(tc);

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

    setup(tc);

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

    setup(tc);

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

    setup(tc);

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

    setup(tc);

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
        uint8_t d = cursor[4];

        CuAssertIntEquals(tc, 4, item_size);

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

    setup(tc);

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

    setup(tc);

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

CuSuite* get_suite(void)
{
    CuSuite* suite = CuSuiteNew();

    SUITE_ADD_TEST(suite, request_id_is_set);

    SUITE_ADD_TEST(suite, checkpoint_set_works);
    SUITE_ADD_TEST(suite, checkpoint_get_works);
    SUITE_ADD_TEST(suite, checkpoint_delete_works);
    SUITE_ADD_TEST(suite, checkpoint_list_works);
    SUITE_ADD_TEST(suite, checkpoint_enable_works);
    SUITE_ADD_TEST(suite, checkpoint_disable_works);

    SUITE_ADD_TEST(suite, condition_set_works);

    SUITE_ADD_TEST(suite, registers_set_works);
    SUITE_ADD_TEST(suite, registers_get_works);
    SUITE_ADD_TEST(suite, registers_get_drive_works);

    SUITE_ADD_TEST(suite, mem_set_works);
    SUITE_ADD_TEST(suite, mem_get_works);

    SUITE_ADD_TEST(suite, advance_instructions_works);
    SUITE_ADD_TEST(suite, keyboard_feed_works);
    SUITE_ADD_TEST(suite, execute_until_return_works);

    SUITE_ADD_TEST(suite, exit_works);
    SUITE_ADD_TEST(suite, reset_works);

    SUITE_ADD_TEST(suite, dump_works);
    SUITE_ADD_TEST(suite, undump_works);

    SUITE_ADD_TEST(suite, banks_available_works);
    SUITE_ADD_TEST(suite, registers_available_works);
    SUITE_ADD_TEST(suite, display_get_works);
    SUITE_ADD_TEST(suite, vice_info_works);

    SUITE_ADD_TEST(suite, palette_get_works);

    SUITE_ADD_TEST(suite, resource_get_works);
    SUITE_ADD_TEST(suite, resource_set_works);

    SUITE_ADD_TEST(suite, autostart_works);

    return suite;
}

int run_tests(CuSuite* inner)
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

void mon_quit() {
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

    close(sock);

    return ret;
}
