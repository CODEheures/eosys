ORG 0
BITS 16

JMP SHORT START

times 33 db 0


START:
    JMP 0x7C0:_start

_start:
    CLI
    MOV ax, 0x7C0
    MOV ds, ax
    MOV es, ax
    MOV ax, 0x0
    MOV ss, ax
    MOV sp, 0x7C00
    STI

    MOV si, message
    CALL PRINT

    JMP $

PRINT:
    MOV bx, 0
.begin_print:
    MOV al, [si]
    CMP al, 0
    JE .end_print
    CALL PRINT_CHAR
    INC si
    JMP .begin_print

.end_print:
    RET

PRINT_CHAR:
    MOV ah, 0Eh
    INT 0x10
    RET

message: db 'Hello world!', 0


times 510 -($ -$$) db 0

db 0x55
db 0xAA