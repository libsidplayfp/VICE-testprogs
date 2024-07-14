/*
 * checkpoint.h - Checkpoint command tests
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

#ifndef BINMONTEST_CHECKPOINT_H
#define BINMONTEST_CHECKPOINT_H

#include "CuTest.h"

void checkpoint_set_works(CuTest *tc);
void checkpoint_get_works(CuTest *tc);
void checkpoint_delete_works(CuTest *tc);
void checkpoint_list_works(CuTest *tc);
void checkpoint_list_does_dedupe(CuTest *tc);
void checkpoint_enable_works(CuTest *tc);
void checkpoint_disable_works(CuTest *tc);
void condition_set_works(CuTest *tc);

#endif