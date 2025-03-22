/*
 * util.c - Utility functions for converting to/from little endian, header constants
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

#include "util.h"

#include <stdint.h>

uint64_t little_endian_to_uint64(unsigned char *input) {
    uint64_t sum = 0;
    for (int i = 0 ; i < 8 ; i++) {
        sum += ((uint64_t)input[i]) << (8 * i);
    }
    return sum;
}

uint32_t little_endian_to_uint32(unsigned char *input) {
    return (input[3] << 24) + (input[2] << 16) + (input[1] << 8) + input[0];
}

uint16_t little_endian_to_uint16(unsigned char *input) {
    return (input[1] << 8) + input[0];
}

unsigned char *write_uint16(uint16_t input, unsigned char *output) {
    output[0] = input & 0xFFu;
    output[1] = (input >> 8) & 0xFFu;

    return output + 2;
}

unsigned char *write_uint32(uint32_t input, unsigned char *output) {
    output[0] = input & 0xFFu;
    output[1] = (input >> 8) & 0xFFu;
    output[2] = (input >> 16) & 0xFFu;
    output[3] = (uint8_t)(input >> 24) & 0xFFu;

    return output + 4;
}

void little_endian_to_uint64_works(CuTest *tc) {
    unsigned char max[] = {
        0xff, 0xff, 0xff, 0xff,
        0xff, 0xff, 0xff, 0xff,
    };
    unsigned char min[] = {
        0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00,
    };
    unsigned char asc[] = {
        0xf0, 0xde, 0xbc, 0x9a,
        0x78, 0x56, 0x34, 0x12,
    };

    CuAssertTrue(tc, 0 == little_endian_to_uint64(min));
    CuAssertTrue(tc, 0xffffffffffffffff == little_endian_to_uint64(max));
    CuAssertTrue(tc, 0x123456789abcdef0 == little_endian_to_uint64(asc));
}

