extern _exit

segment .text
global  buf_read_u16

	; unsigned short buf_read_u16(char **buf, unsigned long int *buf_size)

buf_read_u16:

	mov r8, 2

	mov rax, [rsi]
	cmp rax, r8
	jl  .Lbuf_read_u16_exit

	xor rdx, rdx
	mov rax, [rdi]
	div r8
	cmp rdx, 0
    jne .Lbuf_read_u16_exit

    mov rax, [rdi]
    mov ax, word [rax]
    add [rdi], r8
    sub [rsi], r8

    ret

.Lbuf_read_u16_exit:

	mov  rdi, 1
	call _exit
