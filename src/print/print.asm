segment .text
global  print

	; void print(char *str, int len)

print:
	mov rdx, rsi
	mov rsi, rdi

	mov rax, 1
	mov rdi, 1
	syscall

	ret
