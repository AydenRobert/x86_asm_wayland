extern set_errno

global recv

segment .text

	; size_t recv(int sockfd, void buf[size], size_t size, int flags)

recv:

	mov r10, rcx
	mov r8, 0
	mov r9, 0
	syscall

    mov rdi, rax
    call set_errno

	ret
