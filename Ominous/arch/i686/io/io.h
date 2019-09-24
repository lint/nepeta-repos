#ifndef IO_H
#define IO_H
static inline void outb(uint16_t port, uint8_t val);
static inline uint8_t inb(uint16_t port);
static inline void outl(uint16_t port, uint32_t val);
static inline uint32_t inl(uint16_t port);
static inline void io_wait();

const int MAX_SUPPORTED_SCANCODE = 0x40;
char scancodes[] = {0, 0, 0,
                    '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', 8 /* backspace */, 
          /* tab */ ' ', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\n', 0 /* left control */,
                    'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', '\'', '`', 0 /* left shift */, '\\',
                    'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', 0 /* right shift */, '*',
                    0 /* left alt */, ' ', 0 /* caps lock */};
#endif