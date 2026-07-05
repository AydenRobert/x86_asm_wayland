segment .text
global  _cstring_len_scalar

	; int _cstring_len_scalar(char *str)

_cstring_len_scalar:
	xor eax, eax

.loop_start:
	cmp byte [rdi], 0
	je  .loop_end
	inc rdi
	inc eax
	jmp .loop_start

.loop_end:

	ret
