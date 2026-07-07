extern set_errno

segment .data
newline_char db 10

segment .text
global  print_line

	; void print_line()

print_line:
	mov rax, 1
	mov rdi, 1
	lea rsi, [rel newline_char]
	mov rdx, 1
	syscall

    mov rdi, rax
    call set_errno

	ret
