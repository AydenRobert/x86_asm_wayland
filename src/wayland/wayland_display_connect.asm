extern get_env
extern cstring_len
extern print
extern print_line
extern mem_cpy

segment .data

xdg_rd_env_var db "XDG_RUNTIME_DIR", 0
wayland_d_env_var db "WAYLAND_DISPLAY", 0
wayland_display_default db "wayland-0", 0

segment .text

global wayland_display_connect

	; int wayland_display_connect()

wayland_display_connect:
	push rbp
	push r12
	mov  rbp, rsp

	;   rsp      = pxdg_runtime_dir - char *
	;   rsp + 8  = xdg_runtime_dir_len - uint64_t
	;   rsp + 16 = pwayland_display - char *
	;   rsp + 24 = wayland_display_default_len | wayland_display_len
	;   rsp + 32 = socket_path_len
	;   rsp + 48 = rbp
	;   rbp pppppppp-xxxxxxxx xxxxxxxx-xxxxxxxx xxxxxxxx-xxxxxxxx
	sub rsp, 48

	;    getenv("XDG_RUNTIME_DIR")
	lea  rdi, [rel xdg_rd_env_var]
	call get_env

	;   if null, ret 0
	cmp rax, 0
	je  .Lwayland_display_connect_ret_null

	;   store char *
	mov [rsp], rax

	;    get len
	mov  rdi, rax
	call cstring_len

	;   store len
	mov [rsp + 8], rax

	;    getenv("WAYLAND_DISPLAY")
	lea  rdi, [rel wayland_d_env_var]
	call get_env

	cmp rax, 0
	jne .Lwayland_display_connect_wenv_not_null

	;   return null, load default
	lea rdi, [rel wayland_display_default]

	jmp .Lwayland_display_connect_wenv_get_len

.Lwayland_display_connect_wenv_not_null:

	;   return string, mov to rdi
	mov rdi, rax

.Lwayland_display_connect_wenv_get_len:

	;   store pointer
	mov [rsp + 16], rdi

	;    get len
	call cstring_len

	;   store len
	mov [rsp + 24], rax

	; struct sockaddr_un {
	; sa_family_t sun_family; -> unsigned int
	; char sun_path[]
	; }

	;   back up rsp again
	mov r12, rsp

	mov rax, [rsp + 8]
	add rax, [rsp + 24]
	add rax, 8
	add rax, 17; '/' + '\0' + rounding
	and rax, 16

	;   rsp = sun_family -> uint32_t
	sub rsp, rax

	mov dword [rsp], 1

	lea  rdi, [rsp + 4]
	mov  rsi, [r12]
	mov  rdx, [r12 + 8]
	call mem_cpy

	mov rax, [r12 + 8]
	;   sun_path[xdg_runtime_dir_len++]
	mov byte [rsp + 4 + rax], 47
	inc rax

	mov qword [r12 + 32], rax

	lea  rdi, [rsp + 4 + rax]
	mov  rsi, [r12 + 16]
	mov  rdx, rax
	call mem_cpy

	mov rax, qword [r12 + 24]
	add rax, qword [r12 + 32]
	mov qword [r12 + 32], rax

	mov byte [rsp + 4 + rax], 0

	mov rax, 41
	mov rdi, 1
	mov rsi, 2
	mov rdx, 0
    syscall

    push rax

    mov rdi, rax
	mov rax, 42
	lea rsi, [rsp]
	mov rdx, qword [r12 + 32]
    add rdx, 4
	syscall

    pop rax

	mov rsp, rbp
	pop r12
	pop rbp
	ret

.Lwayland_display_connect_ret_null:
	mov rax, 0

	mov rsp, rbp
	pop r12
	pop rbp
	ret
