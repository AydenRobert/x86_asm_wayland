extern li_str
extern print

segment .bss
li_arr resb 20

segment .text
global print_li

; void print_li(long int x)

print_li:
    
    lea rsi, [rel li_arr]
    mov rdx, 20
    call li_str

    lea rdi, [rel li_arr]
    mov rsi, rax
    call print

    ret
