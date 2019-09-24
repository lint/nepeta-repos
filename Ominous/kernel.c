#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include "libc/lib.h"
#include "arch/i686/tty/tty.h"
#include "arch/i686/io/io.h"

#include "libc/lib.c"
#include "arch/i686/tty/tty.c"
#include "arch/i686/io/io.c"

#include "drivers/pci/pci.c"
#include "drivers/ahci/ahci.c"

#include "shell/shell.c"

#if defined(__linux__)
#error "Wrong compiler, you fool."
#endif

#if !defined(__i386__)
#error "Wrong compiler, you fool."
#endif
 
void kernel_main(void) 
{
	terminal_initialize();
	terminal_writestring("Ominous kernel - integrated shell\n");
	shell(); //move this to an elf
}
