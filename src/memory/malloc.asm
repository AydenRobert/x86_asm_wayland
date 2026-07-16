%include "src/memory/malloc.inc"

extern sbrk
extern rup2

segment .data

malloc_base dq 0

segment .text
global  malloc

	; void *malloc(size_t size)

malloc:

	cmp qword [rel malloc_base], 0
	je  .Linit_malloc

.Lstart_malloc:

	mov r8, qword [rel malloc_base]
	;   check if the block is free
	mov eax, dword [r8 + Meta_Block.free]
	cmp eax, 1
	je  .Lloop_start
	;   check if the block is big enough
	mov rax, qword [r8 + Meta_Block.block_size]
	cmp rax, rdi
	jl  .Lloop_start

	;   return block
	mov rax, r8
	add rax, Meta_Block_size

	ret

.Lloop_start:

	;   check if at end of linked list
	cmp [r8 + Meta_Block.next], 0
	je  .Lnew_block
	mov r8, qword [r8 + Meta_Block.next]

	;   check if the block is free
	mov eax, dword [r8 + Meta_Block.free]
	cmp eax, 1
	je  .Lloop_start
	;   check if the block is big enough
	mov rax, qword [r8 + Meta_Block.block_size]
	cmp rax, rdi
	jl  .Lloop_start

	;   return block
	mov rax, r8
	add rax, Meta_Block_size

	ret

.Lnew_block:

	push r12

	;    round up to nearest power of 2
	call rup2
	mov  rdi, rax
	mov  r12, rdi
	add  rdi, Meta_Block_size

	;    get memory
	call sbrk

	cmp rax, -1
	je  .Lret_null

	;   set meta data
	mov qword [r8 + Meta_Block.next], rax
	mov qword [rax + Meta_Block.block_size], r12
	mov qword [rax + Meta_Block.next], 0
	mov dword [rax + Meta_Block.free], 1

	;   return pointer to memory
	add rax, Meta_Block_size
	pop r12
	ret

.Linit_malloc:

	push r12

	;    round up to nearest power of 2
	call rup2
	mov  rdi, rax
	mov  r12, rdi
	add  rdi, Meta_Block_size

	;    get memory
	call sbrk

	cmp rax, -1
	je  .Lret_null

	;   set meta data
	mov qword [rel malloc_base], rax
	mov qword [rax + Meta_Block.block_size], r12
	mov qword [rax + Meta_Block.next], 0
	mov dword [rax + Meta_Block.free], 1

	;   return pointer to memory
	add rax, Meta_Block_size
	pop r12
	ret

.Lret_null:

	mov rax, 0
	ret

global free

	; void free(void *ptr)

free:

	cmp qword [rel malloc_base], 0
	je  .Lret

	cmp rdi, 0
	je  .Lret

	mov r8, qword [rel malloc_base]

	cmp rdi, r8
	jl  .Lret

	sub rdi, Meta_Block_size

	cmp r8, rdi
	je  .Lfree

.Lloop_free:

	cmp qword [r8 + Meta_Block.next], 0
	je  .Lret
	mov r8, qword [r8 + Meta_Block.next]
	cmp r8, rdi
	je  .Lfree

	jmp .Lloop_free

.Lfree:

	mov dword [r8 + Meta_Block.free], 0

.Lret:

	ret
