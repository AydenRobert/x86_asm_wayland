segment .text
global  cstring_len

	; int cstring_len(char *str)

cstring_len:
	xor eax, eax

.Lcstring_len_loop_start:
	cmp byte [rdi], 0
	je  .Lcstring_len_loop_end
	inc rdi
	inc eax
	jmp .Lcstring_len_loop_start

.Lcstring_len_loop_end:

	ret
