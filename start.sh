# /bin/bash
make clean
make
gdb -ex 'target remote | qemu-system-x86_64 -hda ./bin/boot.bin -S -gdb stdio'
