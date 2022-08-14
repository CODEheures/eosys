ORG 0x7C00
BITS 16

CODE_SEG EQU GDT_CODE - GDT_START
DATA_SEG EQU GDT_DATA - GDT_START

JMP SHORT START
NOP

times 33 db 0


START:
    JMP 0:_start

_start:
    CLI
    MOV ax, 0
    MOV ds, ax
    MOV es, ax
    MOV ss, ax
    MOV sp, 0x7C00
    STI

load_gdt:
    CLI
    LGDT[GDT_DESCRIPTOR]
    MOV eax, cr0
    OR eax, 0x1
    MOV cr0, eax

    JMP CODE_SEG:load32


; https://wiki.osdev.org/GDT_Tutorial
; GDT 32-bit mode
GDT_START:
GDT_NULL:           ; 0x00
    dd 0x00000000
    dd 0x00000000
GDT_CODE:           ; CS 0x08
    dw 0xFFFF       ; Limit 0-15
    dw 0x0000       ; Base 16-31
    db 0x00         ; Base 32-39
    db 0x9A         ; Access Byte 40-47
    db 0xCF         ; Limit 48-51 Flag 52-55
    db 0x00         ; Base 56-63
GDT_DATA:           ; DS ES SS FS GS 0x10
    dw 0xFFFF       ; Limit 0-15
    dw 0x0000       ; Base 16-31
    db 0x00         ; Base 32-39
    db 0x92         ; Access Byte 40-47
    db 0xCF         ; Limit 48-51 Flag 52-55
    db 0x00         ; Base 56-63
GDT_END:

GDT_DESCRIPTOR:
    dw GDT_END - GDT_START - 1
    dd GDT_START

[BITS 32]
load32:
    MOV eax, 1
    MOV ecx, 100
    MOV edi, 0x0100000
    CALL ata_lba_read

    JMP CODE_SEG:0x0100000

%include "./src/boot/ata_lba_read.asm"

times 510 -($ - $$) db 0

db 0x55
db 0xAA
