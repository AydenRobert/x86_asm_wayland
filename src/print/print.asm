extern set_errno

segment .text
global  print

	; void print(char *str, int len)

print:
	mov rdx, rsi
	mov rsi, rdi

	mov rax, 1; SYS_write
	mov rdi, 1; STDOUT_FD
	syscall

    mov rdi, rax
    call set_errno

	ret
