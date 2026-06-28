segment .text
global  cstring_index_of

	; int cstring_index_of(char *str, char c)

cstring_index_of:
	xor eax, eax

.Lcstring_index_of_loop_start:
	cmp byte [rdi], 0
	je  .Lcstring_index_of_null
	cmp byte [rdi], sil
	je  .Lcstring_index_of_loop_end
	inc rdi
	inc eax
	jmp .Lcstring_index_of_loop_start

.Lcstring_index_of_null:
	mov eax, -1

.Lcstring_index_of_loop_end:

	ret
