#!/usr/bin/env python3

import romtools as rt
import sys
from ff5_lzss import decode_lzss, encode_lzss

# def encode_rle16(src):

def decode_rle16(src):
    # return an empty buffer if the source buffer is empty
    if len(src) == 0:
        return bytearray(0)

    s = 0  # source pointer

    # destination buffer
    dest = bytearray(0x10000)
    d = 0

    while s < len(src):
        b = src[s]
        s += 1

        if b == 0:
            # null terminator
            break

        elif b & 0x80:
            # raw string
            b &= 0x7F
            n = (b + 1) * 2
            dest[d:d + n] = src[s:s + n]
            s += n
            d += n

        else:
            # repeated 8-bit value
            n = b + 1
            n *= 2
            val1 = src[s]
            val2 = src[s + 1]
            dest[d:d + n] = [val1, val2] * n
            s += 2
            d += n

    return dest[:d]

# def encode_rle8(src):

def decode_rle8(src):

    # return an empty buffer if the source buffer is empty
    if len(src) == 0:
        return bytearray(0)

    s = 0  # source pointer

    # destination buffer
    dest = bytearray(0x10000)
    d = 0

    while s < len(src):
        b = src[s]
        s += 1

        if b == 0:
            # null terminator
            break

        elif b & 0x80:
            # raw string
            b &= 0x7F
            n = b + 1
            dest[d:d + n] = src[s:s + n]
            s += n
            d += n

        else:
            # repeated 8-bit value
            n = b + 1
            val = src[s]
            dest[d:d + n] = [val] * n
            s += 1
            d += n

    return dest[:d]

def decode_multi(src):
    mode = src[0]
    mode_lo = mode & 0x0F
    mode_hi = mode & 0xF0
    if mode_lo == 0:
        # no compression
        length = src[1]
        return src[2:2 + length]

    elif mode_lo == 1 and mode_hi == 0:
        # 8-bit rle
        return decode_rle8(src[1:])

    elif mode_lo == 1:
        # 16-bit rle
        return decode_rle16(src[1:])

    elif mode_lo == 2:
        # lzss
        return decode_lzss(src[1:])

    else:
        raise ValueError('Invalid compression mode:', mode)

if __name__ == '__main__':
    src_path = sys.argv[1]
    dest_path = sys.argv[2]

    with open(src_path, 'rb') as f:
        src_bytes = bytearray(f.read())

    # try all compression modes to find the best option
    # rle8_bytes = encode_rle8(src_bytes)
    # rle16_bytes = encode_rle16(src_bytes)
    lzss_bytes = encode_lzss(src_bytes)

    # size_list = [len(src_bytes), len(rle8_bytes), len(rle16_bytes), len(lzss_bytes)]

    with open(dest_path, 'wb') as f:
        f.write(encode_lzss(src_bytes))