BOOT_ASM = ./src/boot/boot.asm
BOOT_BIN = ./bin/boot.bin

KERNEL_ASM = ./src/kernel.asm
KERNEL_ELF_O = ./build/kernel.asm.o
KERNEL_LINKED_O = ./build/kernel_linked.o
KERNEL_BIN = ./bin/kernel.bin

OS_BIN = ./bin/os.bin

LINKER = ./src/linker.ld

all: clean $(BOOT_BIN) $(KERNEL_BIN)
	dd if=$(BOOT_BIN) > $(OS_BIN)
	dd if=$(KERNEL_BIN) >> $(OS_BIN)
	dd if=/dev/zero bs=512 count=100 >> $(OS_BIN)
	
./bin/boot.bin: $(BOOT_ASM)
	nasm -f bin $(BOOT_ASM) -o $(BOOT_BIN)

./build/kernel.asm.o: $(KERNEL_ASM)
	nasm -f elf -g $(KERNEL_ASM) -o $(KERNEL_ELF_O)

./bin/kernel.bin: $(KERNEL_ELF_O)
	i686-elf-ld -g -relocatable $(KERNEL_ELF_O) -o $(KERNEL_LINKED_O)
	i686-elf-gcc -T $(LINKER) -o $(KERNEL_BIN) -ffreestanding -O0 -nostdlib $(KERNEL_LINKED_O)

clean:
	rm -rf $(OS_BIN)
	rm -rf $(BOOT_BIN)
	rm -rf $(KERNEL_BIN)
	rm -rf $(KERNEL_ELF_O)
	rm -rf $(KERNEL_LINKED_O)
