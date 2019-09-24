static inline void outb(uint16_t port, uint8_t val)
{
	__asm volatile ( "outb %0, %1" : : "a"(val), "Nd"(port) );
}

static inline uint8_t inb(uint16_t port)
{
	uint8_t ret;
	__asm volatile ( "inb %1, %0"
									: "=a"(ret)
									: "Nd"(port) );
	return ret;
}

static inline void outl(uint16_t port, uint32_t val)
{
	__asm volatile ( "outl %0, %1" : : "a"(val), "Nd"(port) );
}

static inline uint32_t inl(uint16_t port)
{
	uint32_t ret;
	__asm volatile ( "inl %1, %0"
									: "=a"(ret)
									: "Nd"(port) );
	return ret;
}

static inline void io_wait()
{
		__asm volatile ( "outb %%al, $0x80" : : "a"(0) );
}

char getScancode()
{
	char flag = inb(0x64);
	while(!(flag & 1)) {
		flag = inb(0x64);
	}
	return inb(0x60);
}

char getChar()
{
	char scancode = getScancode()+1;
	if (scancode <= MAX_SUPPORTED_SCANCODE) {
		return scancodes[scancode];
	} else {
		return 0;
	}
}