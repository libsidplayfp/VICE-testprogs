#!/usr/pkg/bin/python3.7
#
# Program to read "hi-res.asm" and reconstruct the image it
# is trying to create.

import sys

def printbits(number):
    mask = 128
    while mask:
        if number & mask:
            print('*', end='')
        else:
            print('.', end='')
        mask = mask >> 1
    print(' ', end='')


def printchar(ch, scanline):
    ch0 = ch & 127
    bits = chargen[ch0 * 8 + scanline]

    if ch >= 128:
        bits = bits ^ 0xFF

    printbits(bits)


# Super simplistic "argument parsing".
printhex = len(sys.argv) > 1

with open("characters-2.901447-10.bin", "rb") as f:
    chargen = f.read(2048)

with open("hi-res.asm", "r") as f:
    scanline = 0
    column = 0

    for line in f:
        if '#$' in line and '0f67  A0 DD' not in line: 
            p = line.index('#$')
            hex = line[p + 2 : p + 4]
            ch = int(hex, 16)

            if printhex:
                print(hex, end=' ')
            printchar(ch, scanline)

            column += 1
            if column >= 10:
                column = 0
                scanline += 1
                print()

                if scanline >= 8:
                    print()
                    scanline = 0


