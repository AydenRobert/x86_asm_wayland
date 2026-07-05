segment .text
global  str_cmp

	; char str_cmp(char *str1, char *str2, int len)

str_cmp:
	mov rcx, rdx
	dec rcx

.loop_start:
	cmp [rdi], 0
	je  .loop_end
	mov dl, [rdi]
	cmp dl, [rsi]
	jne .loop_end

	inc  rdi
	inc  rsi
	loop .loop_start

.loop_end:
	mov al, byte [rdi]
	sub al, byte [rsi]

	ret
