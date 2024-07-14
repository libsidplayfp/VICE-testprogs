/*
 * connection.h - Connection setup and utility functions for tests
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

#ifndef BINMONTEST_CONNECTION_H
#define BINMONTEST_CONNECTION_H

#include <stdlib.h>

#include "CuTest.h"

extern unsigned char response[1<<24];
void connection_set_port(int p);
void connection_setup(CuTest *tc);
void really_send_command(unsigned char* command, size_t length);
#define send_command(command) really_send_command(command, sizeof(command));

int wait_for_response_type(CuTest *tc, uint8_t response_type);
int wait_for_response_id(CuTest *tc, unsigned char *command);
void connection_close();

#endif