extern _exit

segment .text
global assert

    ; void assert(bool)

assert:

    cmp rdi, 0
    jne .exit
    ret

.exit:

    mov rdi, 1
    call _exit
