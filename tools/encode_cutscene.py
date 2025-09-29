#!/usr/bin/env python3

import binascii
import os
import sys
import romtools as rt
from ff5_compress import encode_lzss


if __name__ == '__main__':
    src_path = sys.argv[1]
    dest_path = sys.argv[2]

    # open source file
    with open(src_path, 'rb') as src_file:
        src_data = bytearray(src_file.read())

    # calculate CRC32
    crc32 = binascii.crc32(src_data) & 0xFFFFFFFF
    print('Cutscene CRC32:', rt.hex_string(crc32))

    # check if it matches a vanilla cutscene program
    if crc32 == 0xAEF2C05E:
        print('Copying vanilla cutscene program')
        cutscene_file = open('src/cutscene/cutscene_code.bin.lz', 'rb')
        cutscene_data = bytearray(cutscene_file.read())
    else:
        print('Encoding modified cutscene program')
        cutscene_data = encode_lzss(src_data)

    # write the encoded cutscene data to the destination file
    os.makedirs(os.path.dirname(dest_path), exist_ok=True)
    with open(dest_path, 'wb') as dest_file:
        dest_file.write(cutscene_data)
