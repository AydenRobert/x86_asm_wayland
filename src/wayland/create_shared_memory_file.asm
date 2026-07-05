extern _exit

segment .data
memory_file_name db "shm", 0

segment .text
global  create_shared_memory_file

	; void *create_shared_memory_file(long int size)

create_shared_memory_file:

	push r12
	push r13

	;   save size arg
	mov r13, rdi

	;   memfd_create("shm", 0)
	mov eax, 319; memfd_create
	lea rdi, [rel memory_file_name]
	mov rsi, 0
	syscall

	test rax, rax
	js   .exit
	mov  r12d, eax

	;   ftruncate(fd, size)
	mov eax, 77; ftruncate
	mov edi, r12d
	mov rsi, r13
	syscall

	test rax, rax
	js   .exit

	;   mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0)
	mov eax, 9
	xor rdi, rdi
	mov rsi, r13
	mov rdx, 0b11; PROT_READ | PROT_WRITE
	mov r10, 0x1; MAP_SHARED
	mov r8, r12
	xor r9, r9
	syscall

	test rax, rax
	js   .exit

	; mapped address in rax

	pop r13
	pop r12

	ret

.exit:

	mov  rdi, 1
	call _exit
