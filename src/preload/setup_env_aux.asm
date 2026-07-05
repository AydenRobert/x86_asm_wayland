extern ppenv
extern env_len

extern paux
extern aux_len

segment .text
global  setup_env_aux

	; void setup_env_aux(void *env_ptr)

setup_env_aux:

	mov rax, rdi
	mov [rel ppenv], rax

	; TODO: move to own function

	;   get env len
	xor rcx, rcx
	mov rdx, rax
	sub rax, 8

.L_start_env_loop:

	add rax, 8
	cmp rcx, [rax]
	jne .L_start_env_loop

	mov r8, rax

	sub rax, rdx
	shr rax, 3
	mov qword [rel env_len], rax

	;   save aux ptr
	lea rax, [r8 + 8]
	mov [rel paux], rax

	; TODO: move to own function

	;   get aux len
	xor rcx, rcx
	mov rdx, rax
	sub rax, 16

.L_start_aux_loop:

	add rax, 16
	cmp rcx, qword [rax]
	jne .L_start_aux_loop

	sub rax, rdx
	shr rax, 4
	mov qword [rel aux_len], rax

	ret
