extern _exit
extern buf_write_u32
extern mem_cpy

segment .text
global  buf_write_string

	; void buf_write_string(char *buf, unsigned long int *buf_size
	; unsigned long int buf_cap, char *src, unsigned int src_len)

buf_write_string:

	mov rax, [rsi]
	add rax, r8
	cmp rax, rdx
	jg  .Lbuf_write_string_exit

	;    save registers
	push rdi
	push rsi
	push rdx
	push rcx
	push r8

	xchg rcx, r8
	call buf_write_u32

	;   get registers back
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi

	add r8, 3
	and r8, 4

	;    save registers
	push rsi
	push r8

	add  rdi, [rsi]
	mov  rsi, rcx
	mov  rdx, r8
	call mem_cpy

	pop rsi
	pop rdi

	add [rdi], rsi

    ret

.Lbuf_write_string_exit:

	mov  rdi, 1
	call _exit
