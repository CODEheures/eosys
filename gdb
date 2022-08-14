add-symbol-file ./build/kernel_linked.o 0x100000
break kernel_main
target remote | qemu-system-x86_64 -hda ./bin/os.bin -S -gdb stdio
c
layout asm
