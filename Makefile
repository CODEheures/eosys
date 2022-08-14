BINS = ./bin/*
BUILDS = ./build/*

BOOT_ASM = ./src/boot/boot.asm
BOOT_BIN = ./bin/boot.bin

KERNEL_ASM = ./src/kernel.asm
KERNEL_ASM_O = ./build/kernel.asm.o
KERNEL_ASM_LINKED_O = ./build/kernel_linked.o
KERNEL_BIN = ./bin/kernel.bin

KERNEL_C = ./src/kernel.c
KERNEL_C_O = ./build/kernel_c.o

OS_BIN = ./bin/os.bin

LINKER = ./src/linker.ld

INCLUDES = -I./src
FLAGS = -g -ffreestanding -falign-jumps -falign-functions -falign-labels -falign-loops -fstrength-reduce -fomit-frame-pointer -finline-functions -Wno-unused-function -fno-builtin -Werror -Wno-unused-label -Wno-cpp -Wno-unused-parameter -nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -Iinc
	
$(BOOT_BIN): $(BOOT_ASM)
	nasm -f bin $(BOOT_ASM) -o $(BOOT_BIN)

$(KERNEL_C_O): $(KERNEL_C)
	i686-elf-gcc $(INCLUDES) $(FLAGS) -std=gnu99 -c $(KERNEL_C) -o $(KERNEL_C_O)

$(KERNEL_ASM_O): $(KERNEL_ASM)
	nasm -f elf -g $(KERNEL_ASM) -o $(KERNEL_ASM_O)

$(KERNEL_BIN): $(KERNEL_ASM_O) $(KERNEL_C_O)
	i686-elf-ld -g -relocatable $(KERNEL_ASM_O) $(KERNEL_C_O) -o $(KERNEL_ASM_LINKED_O)
	i686-elf-gcc $(FLAGS) -T $(LINKER) -o $(KERNEL_BIN) $(KERNEL_ASM_LINKED_O)

clean:
	rm -rf $(BINS)
	rm -rf $(BUILDS)

all: clean $(BOOT_BIN) $(KERNEL_BIN)
	dd if=$(BOOT_BIN) > $(OS_BIN)
	dd if=$(KERNEL_BIN) >> $(OS_BIN)
	dd if=/dev/zero bs=512 count=100 >> $(OS_BIN)
