def make_descriptor(base, limit, type, granularity = 0):
	descr = 0x0000008000000000

	descr = descr | ((base & 0xFFFF) << 16)	    # base[0..15] 16-31 bits
	descr = descr | ((base & 0x00FF0000) << 32) # base[16..23] 32-39 bits
	descr = descr | ((base & 0xFF000000) << 56) # base[24..31] 56..63 bits
	descr = descr | (limit & 0xFFFF)            # limit[0..15] 0..15 bits
	descr = descr | ((limit & 0xF0000) << 48)   # limit[16..19] 48-51 bits
	descr = descr | (type << 40)                # type[0..3] 40-43 bits
	descr = descr | (granularity << 55)         # granularity bit

	return descr

def type(code = 0, e = 0, w = 0, accessed = 0):
	return (code << 3) | (e << 2) | (w << 1) | accessed

if __name__ == "__main__":
	video = make_descriptor(0xB800, 0xFFFF, type())
	print(hex(video) + ": " + bin(video))
