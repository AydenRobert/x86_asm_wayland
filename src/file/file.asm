%include "src/file/file.inc"

extern mem_cpy
extern malloc
extern free
extern set_errno

segment .text
global  file_write

	; int file_write(file *f, char *buffer, size_t write_len)

file_write:

	push r12
	push r13
	push r14
	push r15

	mov r12, rdi
	mov r13, rsi
	mov r14, rdx

	cmp qword [r12 + File.char_buffer], 0
	je  .Lcreate_buffer

	mov rax, qword [r12 + File.buffer_cap]
	sub rax, qword [r12 + File.buffer_len]
	cmp rax, rdx
	jb  .Lextend_buffer

.Lwrite_to_buffer:

	mov  rdi, qword [r12 + File.char_buffer]
	add  rdi, qword [r12 + File.buffer_len]
	mov  rsi, r13
	mov  rdx, r14
	call mem_cpy

	add [r12 + File.buffer_len], r14

	mov eax, 0

	pop r15
	pop r14
	pop r13
	pop r12

	ret

.Lcreate_buffer:

	mov rdi, 64
	cmp rdi, r14
	jae .Lmalloc_mem

.Lcalc_mem_size:

	;   should not be great enough to overflow
	shl rdi, 1
	cmp rdi, r14
	jb  .Lcalc_mem_size

.Lmalloc_mem:

	push rdi
	call malloc
	pop  rdi

	cmp rax, 0
	je  .Lwrite_ret_error

	mov qword [r12 + File.char_buffer], rax
	mov qword [r12 + File.buffer_len], 0
	mov qword [r12 + File.buffer_cap], rdi

	jmp .Lwrite_to_buffer

.Lextend_buffer:

	mov r15, qword [r12 + File.char_buffer]

	mov rdi, qword [r12 + File.buffer_cap]

.Lcalc_new_mem:

	;   should not be great enough to overflow
	shl rdi, 1

	mov rsi, r14
	add rsi, qword [r12 + File.buffer_len]

	cmp rdi, rsi
	jb  .Lcalc_new_mem

	push rdi
	call malloc
	pop  rdi

	cmp rax, 0
	je  .Lwrite_ret_error

	mov qword [r12 + File.char_buffer], rax
	mov qword [r12 + File.buffer_cap], rdi

	mov  rdi, rax
	mov  rsi, r15
	mov  rdx, qword [r12 + File.buffer_len]
	call mem_cpy

	mov  rdi, r15
	call free

	jmp .Lwrite_to_buffer

.Lwrite_ret_error:

	pop r15
	pop r14
	pop r13
	pop r12

	mov rax, -1
	ret

global file_read

	; size_t file_read(file *f, char *out_buffer, size_t buffer_cap)

file_read:

	mov r8, rdi

	mov eax, 0
	mov edi, dword [r8 + File.fd]
	syscall

	cmp rax, 0
	jl  .Lread_ret_error

	ret

.Lread_ret_error:

	mov  edi, eax
	call set_errno

	mov rax, 0
	ret

global file_flush

	; int file_flush(file *f)

file_flush:

	mov r8, rdi
	xor rdi, rdi

	mov eax, 1
	mov edi, dword [r8 + File.fd]
	mov rsi, qword [r8 + File.char_buffer]
	mov rdx, qword [r8 + File.buffer_len]
	syscall

	mov qword [r8 + File.buffer_len], 0

	ret
