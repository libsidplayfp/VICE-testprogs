/*
 * connection.c - Connection setup and utility functions for tests
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

#include <sys/socket.h>
#include <netinet/tcp.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/poll.h>

#include "CuTest.h"

#include "util.h"

static int response_count = 0;
static int sock = 0;
static int port = 0;
static struct pollfd fds[1];

unsigned char response[1<<24];

void connection_set_port(int p) {
    port = p;
}

void connection_setup(CuTest *tc) {
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

void connection_close() {
    close(sock);
}

void really_send_command(unsigned char* command, size_t length) {
    write_uint32(length - COMMAND_HEADER_LENGTH, &command[COMMAND_LENGTH]);
    for (int i = 0; i < length; i++) {
        /* Send each byte to trigger incomplete reads on the other side */
        send(sock, command + i, 1, 0);
    }
}

#define send_command(command) really_send_command(command, sizeof(command))

static int readloop(CuTest *tc, unsigned char *ptr, int length) {
    int n = 0;
    while(n < length) {
        CuAssertTrue(tc, poll(fds, 1, 10000));
        int o = read(sock, &ptr[n], length - n);
        CuAssertTrue(tc, o > 0);
        n += o;
    }

    return n;
}

static int read_response(CuTest *tc) {
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
