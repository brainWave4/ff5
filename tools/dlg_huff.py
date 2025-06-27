#!/usr/bin/env python3

import json
import os
import sys

if __name__ == '__main__':
    with open('src/text/dlg_en.dat', 'rb') as dlg_file:
        dlg_bytes = bytearray(dlg_file.read())
    print(len(dlg_bytes))

    huff_tree = []
    huff_node = {}

    for offset in range(len(dlg_bytes)):
        if (offset != 0) and dlg_bytes[offset - 1] == 0x17:
            continue
        b = dlg_bytes[offset]

        if b not in huff_node:
            new_node = {
                'count': 0,
                'value': b
            }
            huff_node[b] = new_node
            huff_tree.append(new_node)
        huff_node[b]['count'] += 1

    # collapse the huffman tree
    while len(huff_tree) > 2:
        # sort the huffman tree by count
        huff_tree.sort(key=lambda node: node['count'])
        left_node = huff_tree[0]
        right_node = huff_tree[1]
        huff_tree = huff_tree[2:]
        new_node = {
            'count': left_node['count'] + right_node['count'],
            'value': [left_node, right_node]
        }
        huff_tree.insert(0, new_node)

    huff_table = {}
    for b in range(2**18):
        mask = 1
        huff_code = ''
        node = {'value': huff_tree}

        while isinstance(node['value'], list):
            if (mask & b) == 0:
                huff_code += '0'
                node = node['value'][0]
            else:
                huff_code += '1'
                node = node['value'][1]
            mask <<= 1

        huff_table[node['value']] = huff_code
    print(len(huff_table))

    encoded_length = 0
    for offset in range(len(dlg_bytes)):
        if (offset != 0) and dlg_bytes[offset - 1] == 0x17:
            encoded_length += 8
            continue
        b = dlg_bytes[offset]

        huff_code = huff_table[b]
        encoded_length += len(huff_code)
        if b == 0 and (encoded_length % 8) != 0:
            encoded_length += 8 - (encoded_length % 8)
    print(encoded_length // 8)

    print('ratio:', (encoded_length // 8) / len(dlg_bytes))

    for value in sorted(huff_table.keys()):
        print('%02x:' % value, str(huff_node[value]['count']).rjust(6), "'" + huff_table[value])