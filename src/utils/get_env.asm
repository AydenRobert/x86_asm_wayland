extern ppenv
extern cstring_index_of
extern cstring_len
extern mem_cmp

segment .text
global  get_env

; char *get_env(char *str)

get_env:
	push rbx

	mov r9, [rel ppenv]
	mov r10, rdi

.loop_start:

	mov rdi, [r9]
	mov r11, rdi

	cmp rdi, 0
	je  .loop_end

	mov  rsi, 61
	call cstring_index_of

	mov rbx, rax

	mov  rdi, r10
	call cstring_len

	cmp rax, rbx
	jne .loop_inc

    push r9

	mov  rdi, r10
	mov  rsi, r11
	mov  rdx, rbx
	call mem_cmp

    pop r9

	cmp rax, 0
	jne .loop_inc

	mov rax, r11
	add rax, rbx
	inc rax

	pop rbx
	ret

.loop_inc:

	add r9, 8
	jmp .loop_start

.loop_end:

	mov rax, 0

	pop rbx
	ret
