extern _exit

segment .text
global  buf_read_u32

	; unsigned int buf_read_u32(char **buf, unsigned long int *buf_size)

buf_read_u32:

	mov r8, 4

	mov rax, [rsi]
	cmp rax, r8
	jl  .Lbuf_read_u32_exit

	xor rdx, rdx
	mov rax, [rdi]
	div r8
	cmp rdx, 0
    jne .Lbuf_read_u32_exit

    mov rax, [rdi]
    mov eax, dword [rax]
    add [rdi], r8
    sub [rsi], r8

    ret

.Lbuf_read_u32_exit:

	mov  rdi, 1
	call _exit
