extern set_errno

segment .data

curbrk dq 0

segment .text
global  sbrk

	; void *sbrk(size_t inc)

sbrk:

	push r12
	push r13

	mov r12, rdi

	;   get current addr
	mov eax, 12
	mov rdi, 0
	syscall

	;     if curbrk == 0, replace with actual curbrk
	mov   r13, qword [rel curbrk]
	cmp   r13, 0
	cmove r13, rax

	;   if curbrk != brk(0), return -1
	cmp rax, r13
	jne .Lret_err

	mov [rel curbrk], r13

	cmp r12, 0
	je  .Lret_curbrk

	add r13, r12

	;   if (brk(curbrk + inc) < curbrk + inc) return -1
	mov eax, 12
	mov rdi, r13
	syscall

	cmp rax, r13
	jl  .Lret_err

.Lret_curbrk:

    mov r12, [rel curbrk]
	mov [rel curbrk], rax
    mov rax, r12

	pop r13
	pop r12
	ret

.Lret_err:

	mov  edi, 12; ENOMEM
	call set_errno

	mov rax, -1

	pop r13
	pop r12
	ret
