segment .text
global  _mem_cmp_scalar

	; int _mem_cmp_scalar(void *ptr1, void *ptr1, int len)

_mem_cmp_scalar:
	mov rcx, rdx
	dec rcx

.loop_start:
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
