def parse_selector(selector):
	rpl = selector & 0b11        # requested priveleges level
	ti  = (selector >> 2) & 1    # table indicator
	index = selector >> 3        # descriptor index

	print(hex(selector) + ': ' + priveleges(rpl) + ', ' + table(ti))

def priveleges(flags):
	privs = {
		0: 'ring 0',
		1: 'ring 1',
		2: 'ring 2',
		3: 'ring 3'
	}
	return privs[flags]

def table(flags):
	tables = {
		0: 'GDT',
		1: 'LDT'
	}
	return tables[flags]

if __name__ == "__main__":
	code_kernel = 0b000000001000
	data_kernel = 0b0000000000010000
	code_user   = 0b0000000000011011
	data_user   = 0b0000000000100111

	parse_selector(code_kernel)
	parse_selector(data_kernel)
	parse_selector(code_user)
	parse_selector(data_user)
