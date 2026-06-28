segment .text
global  _exit

	; void _exit()

_exit:
	mov rax, 60
	syscall

