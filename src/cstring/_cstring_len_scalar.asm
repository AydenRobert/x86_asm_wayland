segment .text
global  _cstring_len_scalar

	; int _cstring_len_scalar(char *str)

_cstring_len_scalar:
	xor eax, eax

.Lcstring_len_loop_start:
	cmp byte [rdi], 0
	je  .Lcstring_len_loop_end
	inc rdi
	inc eax
	jmp .Lcstring_len_loop_start

.Lcstring_len_loop_end:

	ret
