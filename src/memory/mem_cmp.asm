extern instruction_set_bits

extern _mem_cmp_scalar
extern _mem_cmp_avx2

segment .data

mem_cmp_ptr: dq mem_cmp_resolve

segment .text
global  mem_cmp

	; int mem_cmp(void *ptr1, void *ptr1, int len)

mem_cmp:
	jmp [rel mem_cmp_ptr]

mem_cmp_resolve:
	mov  rax, [rel instruction_set_bits]
	test rax, 1
	jnz  .use_avx2

.use_scalar:
	lea rax, [rel _mem_cmp_scalar]
	mov qword [rel mem_cmp_ptr], rax
	jmp rax

.use_avx2:
	lea rax, [rel _mem_cmp_avx2]
	mov qword [rel mem_cmp_ptr], rax
	jmp rax
