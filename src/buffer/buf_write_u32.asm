extern _exit

segment .text
global  buf_write_u32

	; void buf_write_u32(char *buf, unsigned long int *buf_size, unsigned long int buf_cap, unsigned int x)

buf_write_u32:

	;   sizeof(x)
	mov r8, 4

	;   *buf_size + sizeof(x) <= buf_cap
	mov rax, [rsi]
	add rax, r8
	cmp rax, rdx
	jg  .Lbuf_write_u32_exit

	push rdx
	xor  rdx, rdx

	;   ((size_t)buf + *buf_size) % sizeof(x) == 0
	mov rax, rdi
	add rax, [rsi]
	div r8
	cmp rdx, 0
	jne .Lbuf_write_u32_exit

	pop rdx

	;   *(uint32_t *)(buf + *buf_size) = x
	mov rax, rdi
	add rax, [rsi]
	mov [rax], ecx

	;   *buf_size += sizeof(x)
	add [rsi], r8

    ret

.Lbuf_write_u32_exit:

	mov  rdi, 1
	call _exit
