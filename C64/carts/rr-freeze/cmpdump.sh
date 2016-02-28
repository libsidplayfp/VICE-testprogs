#! /bin/bash
./analyze $1 > /tmp/dump1.txt
./analyze $2 > /tmp/dump2.txt
diff -y /tmp/dump1.txt /tmp/dump2.txt

# eof
