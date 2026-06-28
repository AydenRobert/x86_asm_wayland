segment .text
global  str_cmp

	; char str_cmp(char *str1, char *str2, int len)

str_cmp:
	mov rcx, rdx
	dec rcx

.Lstr_cmp_loop_start:
	cmp [rdi], 0
	je  .Lstr_cmp_loop_end
	mov dl, [rdi]
	cmp dl, [rsi]
	jne .Lstr_cmp_loop_end

	inc  rdi
	inc  rsi
	loop .Lstr_cmp_loop_start

.Lstr_cmp_loop_end:
	mov al, byte [rdi]
	sub al, byte [rsi]

	ret
