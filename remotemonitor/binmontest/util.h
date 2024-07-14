/*
 * util.h - Utility functions for converting to/from little endian, header constants
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

#ifndef BINMONTEST_UTIL_H
#define BINMONTEST_UTIL_H

#define HEADER_LENGTH 12
#define RESPONSE_TYPE 6
#define RESPONSE_ERROR 7
#define RESPONSE_ID 8

#define COMMAND_ID 6
#define COMMAND_HEADER_LENGTH 11
#define COMMAND_LENGTH 2
#define API_VERSION 0x02

uint32_t little_endian_to_uint32(unsigned char *input);
uint16_t little_endian_to_uint16(unsigned char *input);
unsigned char *write_uint16(uint16_t input, unsigned char *output);
unsigned char *write_uint32(uint32_t input, unsigned char *output);

#endif