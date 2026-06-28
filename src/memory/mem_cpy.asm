segment .text
global  mem_cpy

	; void mem_cpy(void *dst, void *src, uint64_t len)

mem_cpy:

.Lmem_cpy_loop_start:

	cmp rdx, 0
	je  .Lmem_cpy_loop_end

	mov     cl, byte [rsi]
	mov     byte [rdi], cl

    inc rdi
    inc rsi
	dec rdx
	jmp .Lmem_cpy_loop_start

.Lmem_cpy_loop_end:

	ret
