[BITS 32]

global _start

CODE_SEG EQU 0x08
DATA_SEG EQU 0x10

_start:
    MOV ax, DATA_SEG
    MOV ds, eax
    MOV es, eax
    MOV ss, eax
    MOV fs, eax
    MOV gs, eax
    MOV ebp, 0x00200000
    MOV esp, ebp

    ; Fast a20 line option 
    ; https://wiki.osdev.org/A20_Line#Fast_A20_Gate
    IN al, 0x92
    OR al, 2
    OUT 0x92, al

    JMP $