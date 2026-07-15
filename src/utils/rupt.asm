segment .text
global rup2

; long int rup2(long int num);

rup2:

    dec rdi
    lzcnt rcx, rdi
    mov rax, 63
    sub rax, rcx
    inc rax

    mov rcx, rax
    mov rax, 1
    shl eax, cl

    ret
