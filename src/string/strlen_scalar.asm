segment .text
global  _strlen_scalar

	; int _strlen_scalar(char *str)

_strlen_scalar:
	xor eax, eax

.loop_start:
	cmp byte [rdi], 0
	je  .loop_end
	inc rdi
	inc eax
	jmp .loop_start

.loop_end:

	ret
