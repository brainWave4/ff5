from ff5_multi import decode_multi

with open('vanilla/ff5-j.sfc', 'rb') as f:
    src_bytes = bytearray(f.read())

start = 0x030200
end = 0x037E4D

while start < end:
    raw_bytes = src_bytes[start:end]
    decoded_bytes, l = decode_multi(raw_bytes)
    print('C3/%04X:' % (start - 0x30000), len(decoded_bytes), l)
    start += l + 1
