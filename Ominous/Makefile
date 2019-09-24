OUT_PATH = out/
OBJ_PATH = $(OUT_PATH)obj/
BIN_PATH = $(OUT_PATH)bin/
ARCH = i686
TARGET = $(ARCH)-pc-none-elf

all: clean
	clang -c arch/$(ARCH)/boot.s -o $(OBJ_PATH)boot.o --target=$(TARGET) -march=$(ARCH)
	clang -c kernel.c -o $(OBJ_PATH)kernel.o -std=c99 -ffreestanding --target=$(TARGET) -march=$(ARCH)
	ld.lld --script arch/$(ARCH)/linker.ld -o $(BIN_PATH)kernel.bin --nostdlib $(OBJ_PATH)boot.o $(OBJ_PATH)kernel.o
clean:
	rm -Rf $(OBJ_PATH)*
	rm -Rf $(BIN_PATH)*
test: all
	qemu-system-x86_64 -kernel $(BIN_PATH)kernel.bin
#	qemu-system-x86_64 -drive id=disk,file=img/disk.img,if=none -device ahci,id=ahci -device ide-drive,drive=disk,bus=ahci.0 -kernel $(BIN_PATH)kernel.bin
