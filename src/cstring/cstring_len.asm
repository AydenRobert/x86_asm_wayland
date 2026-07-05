extern instruction_set_bits

extern _cstring_len_scalar
extern _cstring_len_avx2

segment .data

cstring_len_ptr: dq cstring_len_resolve

segment .text
global  cstring_len

	; int cstring_len(char *str)

cstring_len:
	jmp [rel cstring_len_ptr]

cstring_len_resolve:
	mov  rax, [rel instruction_set_bits]
	test rax, 1
	jnz  .use_avx2

.use_scalar:
	lea rax, [rel _cstring_len_scalar]
	mov qword [rel cstring_len_ptr], rax
	jmp rax

.use_avx2:
	lea rax, [rel _cstring_len_avx2]
	mov qword [rel cstring_len_ptr], rax
	jmp rax
