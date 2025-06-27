#!/usr/bin/env python3

if __name__ == '__main__':
    rom_path = 'vanilla/ff5-j.sfc'
    with open(rom_path, 'rb') as rom_file:
        rom_bytes = rom_file.read()

    mod_start = 0x726C
    mod_end = 0x79E6

    tiles_start = 0x79E6
    tiles_end = 0x83AE

    tile_ptrs = set()
    chunk_ptrs = set()
    mod_lines = []
    mod_ptr = []
    prev_switch = 0

    for offset in range(mod_start, mod_end, 6):
        mod_bytes = rom_bytes[offset:offset+6]
        ptr = mod_bytes[4] | (mod_bytes[5] << 8)
        if mod_bytes[3] != prev_switch:
            prev_switch = mod_bytes[3]
            chunk_ptrs.add(ptr)
            mod_string = '\nworld_mod'
        else:
            mod_string = 'world_mod'
        mod_string += ' {%3d, %3d}' % (mod_bytes[1], mod_bytes[0])
        mod_string += ', %2d' % mod_bytes[2]
        mod_string += ', $%04X' % (mod_bytes[3] + 0x01D0)
        mod_lines.append(mod_string)
        mod_ptr.append(ptr)
        tile_ptrs.add(ptr)

    curr_tile_block = 0
    tile_string = ''
    mod_tile_id = {}
    for offset in range(tiles_start, tiles_end):
        if offset in chunk_ptrs:
            tile_string += '\n'
        if offset in tile_ptrs:
            tile_string += '\nWorldModTiles%d: .byte   ' % curr_tile_block
            mod_tile_id[offset] = curr_tile_block
            curr_tile_block += 1

        tile_string += '$%02x,' % rom_bytes[offset]
    tile_string = tile_string.replace(',\n', '\n')

    for i in range(len(mod_lines)):
        print(mod_lines[i] + ', WorldModTiles%d' % mod_tile_id[mod_ptr[i]])

    print(tile_string)
