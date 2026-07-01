extern _exit
extern mem_cpy

segment .text
global  buf_read_n

	; void buf_read_n(char **buf, unsigned long int *buf_size, char *dst
	; unsigned long int n)

buf_read_n:

	mov rax, [rsi]
	cmp rax, rcx
	jl  .Lbuf_read_n_exit

	push rdi
	push rsi
	push rcx

	mov  rsi, [rdi]
	mov  rdi, rdx
	mov  rdx, rcx
	call mem_cpy

	pop rcx
	pop  rsi
	pop  rdi

	add [rdi], rcx
	sub [rsi], rcx

	ret

.Lbuf_read_n_exit:

	mov  rdi, 1
	call _exit
