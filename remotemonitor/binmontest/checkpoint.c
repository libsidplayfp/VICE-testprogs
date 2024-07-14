/*
 * checkpoint.c - Checkpoint command tests
 *
 * Written by
 *  Empathic Qubit <empathicqubit@entan.gl>
 *  Andreas Signer
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

#include <stdint.h>

#include "CuTest.h"

#include "util.h"
#include "connection.h"

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
        0x01,
    };

    connection_setup(tc);

    send_command(set_command);

    length = wait_for_response_id(tc, set_command);

    CuAssertTrue(tc, response[RESPONSE_TYPE] == 0x11);

    CuAssertTrue(tc, length - HEADER_LENGTH >= 22);

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

    // condition
    CuAssertIntEquals(tc, 0, response[HEADER_LENGTH + 17]);

    // memspace
    CuAssertIntEquals(tc, 1, response[HEADER_LENGTH + 22]);
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

    connection_setup(tc);

    send_command(set_command);

    length = wait_for_response_id(tc, set_command);

    CuAssertIntEquals(tc, 0x11, response[RESPONSE_TYPE]);

    brknum = little_endian_to_uint32(&response[HEADER_LENGTH + 0]);

    // get

    write_uint32(brknum, &get_command[COMMAND_HEADER_LENGTH]);

    send_command(get_command);

    length = wait_for_response_id(tc, get_command);

    CuAssertTrue(tc, length - HEADER_LENGTH >= 22);

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

    // condition
    CuAssertIntEquals(tc, 0, response[HEADER_LENGTH + 17]);

    // memspace
    CuAssertIntEquals(tc, 0, response[HEADER_LENGTH + 22]);
}

static uint32_t list_checkpoint_ids(CuTest *tc, uint32_t* checkpoint_ids, uint32_t maxcheckpoints) {
    uint32_t length;
    uint32_t nof_checkpoints;
    unsigned char list_command[] = { 
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, // length
        0xe1, 0xc7, 0x52, 0x2f, // request id

        0x14, // command "checkpoint list"
    };

    nof_checkpoints = 0;
    send_command(list_command);
    for(;;) {
        wait_for_response_id(tc, list_command);
        if (response[RESPONSE_TYPE] == 0x14) {
            break;
        }
        if (response[RESPONSE_TYPE]== 0x11) {
            CuAssertTrue(tc, nof_checkpoints < maxcheckpoints);
            checkpoint_ids[nof_checkpoints++] = little_endian_to_uint32(&response[HEADER_LENGTH + 0]);
        }
    }
    return nof_checkpoints;
}

static void delete_checkpoint(CuTest* tc, uint32_t checkpointId) {
    unsigned char delete_command[] = { 
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, 
        0xcc, 0xd2, 0x16, 0x2b, 

        0x13,

        0xff, 0xff, 0xff, 0xff,
    };

    write_uint32(checkpointId, &delete_command[COMMAND_HEADER_LENGTH]);
    send_command(delete_command);
    wait_for_response_id(tc, delete_command);
    CuAssertIntEquals(tc, 0x13, response[RESPONSE_TYPE]);
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

    connection_setup(tc);

    send_command(set_command);

    length = wait_for_response_id(tc, set_command);

    CuAssertIntEquals(tc, 0x11, response[RESPONSE_TYPE]);

    brknum = little_endian_to_uint32(&response[HEADER_LENGTH + 0]);

    // delete
    delete_checkpoint(tc, brknum);
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

    connection_setup(tc);

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

void checkpoint_list_does_dedupe(CuTest *tc) {
    int length;
    uint32_t nof_checkpoints;
    uint32_t checkpoint_ids[1024];

    unsigned char set_command[] = { 
        0x02, API_VERSION, 
        0xff, 0xff, 0xff, 0xff, // length
        0xb7, 0xde, 0x2d, 0x1d, // request id

        0x12, // command "checkpoint set"

        0xe2, 0xfc, // address start
        0xe3, 0xfc, // address end
        0x01,       // stop when hit
        0x00,       // enabled
        0x07,       // operation (load | store | exec)
        0x00,       // memspace
    };

    connection_setup(tc);

    // Delete all the existing checkpoints
    nof_checkpoints = list_checkpoint_ids(tc, checkpoint_ids, sizeof(checkpoint_ids)/sizeof(uint32_t));
    while (nof_checkpoints > 0) {
        delete_checkpoint(tc, checkpoint_ids[--nof_checkpoints]);
    }

    // Verify that there are no checkpoints left
    nof_checkpoints = list_checkpoint_ids(tc, checkpoint_ids, sizeof(checkpoint_ids)/sizeof(uint32_t));
    CuAssertIntEquals(tc, 0, nof_checkpoints);

    // Create a new checkpoint for load, store, exec
    send_command(set_command);
    wait_for_response_id(tc, set_command);
    CuAssertIntEquals(tc, 0x11, response[RESPONSE_TYPE]);

    // Verify that we only get back 1 checkpoint
    nof_checkpoints = list_checkpoint_ids(tc, checkpoint_ids, sizeof(checkpoint_ids)/sizeof(uint32_t));
    CuAssertIntEquals(tc, 1, nof_checkpoints);
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

    connection_setup(tc);

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

    connection_setup(tc);

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

    connection_setup(tc);

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
