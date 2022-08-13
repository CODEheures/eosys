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

    ; Fast a20 line option 
    ; https://wiki.osdev.org/A20_Line#Fast_A20_Gate
    IN al, 0x92
    OR al, 2
    OUT 0x92, al

    JMP CODE_SEG:gdt_loaded


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
gdt_loaded:
    MOV ax, DATA_SEG
    MOV ds, eax
    MOV es, eax
    MOV ss, eax
    MOV fs, eax
    MOV gs, eax
    MOV ebp, 0x00200000
    MOV esp, ebp
    JMP $


times 510 -($ - $$) db 0

db 0x55
db 0xAA
