extern penv
extern cstring_index_of
extern cstring_len
extern str_cmp

segment .text
global  get_env

get_env:
	push rbx

	mov r9, [rel penv]
	mov r10, rdi

.Lget_env_loop_start:

	mov rdi, [r9]
	mov r11, rdi

	cmp rdi, 0
	je  .Lget_env_loop_end

	mov  rsi, 61
	call cstring_index_of

	mov rbx, rax

	mov  rdi, r10
	call cstring_len

	cmp rax, rbx
	jne .Lget_env_loop_inc

	mov  rdi, r10
	mov  rsi, r11
	mov  rdx, rbx
	call str_cmp

	cmp rax, 0
	jne .Lget_env_loop_inc

	mov rax, r11
    add rax, rbx
    inc rax

	pop rbx
	ret

.Lget_env_loop_inc:

	add r9, 8
	jmp .Lget_env_loop_start

.Lget_env_loop_end:

	mov rax, 0

	pop rbx
	ret
