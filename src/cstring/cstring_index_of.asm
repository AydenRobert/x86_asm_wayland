segment .text
global  cstring_index_of

	; int cstring_index_of(char *str, char c)

cstring_index_of:
	xor eax, eax

.loop_start:
	cmp byte [rdi], 0
	je  .null
	cmp byte [rdi], sil
	je  .loop_end
	inc rdi
	inc eax
	jmp .loop_start

.null:
	mov eax, -1

.loop_end:

	ret
