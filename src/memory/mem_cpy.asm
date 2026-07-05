segment .text
global  mem_cpy

	; void mem_cpy(void *dst, void *src, uint64_t len)

mem_cpy:

.loop_start:

	cmp rdx, 0
	je  .loop_end

	mov cl, byte [rsi]
	mov byte [rdi], cl

	inc rdi
	inc rsi
	dec rdx
	jmp .loop_start

.loop_end:

	ret
